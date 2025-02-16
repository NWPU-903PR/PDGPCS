function influence_score = mutation_dysregulation_network(pathway,DEG,D,Node,net,mutated_gene)
 
%  identify dysregulated pathway
    pathway_name = pathway.pathway_name;
    pathway_id = pathway.pathway_id;
    pathway_gene_all = pathway.pathway_gene_all;
    
    deregulated_pathway_name = [];

    for i = 1 : length(pathway_id)
        [index,~] = ismember(pathway_name,pathway_id(i));
        pathway_genes = pathway_gene_all(index,:);
        pathway_gene = union(pathway_genes(:,1),pathway_genes(:,2));
        [~,A] = ismember(pathway_gene,DEG);
        
        M = length(D(D ~= 0));
        N = length(pathway_gene);
        K = length(DEG);
        n = length(A(A ~= 0));       
        p = hygecdf(n,M,K,N);
        pvalue = 1 - p;
        fdr = mafdr(pvalue,'BHFDR',true);
        if n > 0
            if fdr < 0.05
                deregulated_pathway_name = [deregulated_pathway_name;pathway_id(i)];
            end
        end   
    end

    % construct mutation-dysregulated network
    % cost                   
    net_w = (mapminmax(net.w',0,1))';
    net_w = ones(length(net_w),1) - net_w;
    net_w(net_w == 0) = min(net_w(net_w > 0));
    
    influence_score = [];
    if ~isempty(deregulated_pathway_name)
        for i = 1 : length(deregulated_pathway_name)
            [index,~] = ismember(pathway_name,deregulated_pathway_name(i));
            % pathway link      
            pathway_genes = pathway_gene_all(index,:);
            pathway_gene = union(pathway_genes(:,1),pathway_genes(:,2));
            [index,~] = ismember(pathway_gene,DEG);
            diff_gene = pathway_gene(index);
            vn = pathway_gene(1);
            [~,index] = ismember(net.gene(:,1),pathway_gene);
            A = find(index ~= 0);
            [~,index] = ismember(net.gene(:,2),pathway_gene);        
            B = find(index ~= 0);
            C = union(A,B);
            background_net = net.gene(C,:);
            background_net_w = net_w(C,:);        
            Y = union(background_net(:,1),background_net(:,2));            
            X = union(pathway_gene,Y);
            res = [];
            for j = 1 : length(mutated_gene)         
                fprintf('   pathway : %d/%d ,mutated gene: %d/%d\n',i,...
                        length(deregulated_pathway_name),j,length(mutated_gene));
                
                v = mutated_gene(j);            
            % mutated gene link      
                [~,index] = ismember(net.gene(:,1),v);
                A = find(index ~= 0);
                [~,index] = ismember(net.gene(:,2),v);        
                B = find(index ~= 0);
                C = union(A,B);
                mutated_net = net.gene(C,:);
                mutated_net_w = net_w(C,:);
                Y = union(mutated_net(:,1),mutated_net(:,2));            
                Z = union(X,Y);           
            % pathway     
                [~,index1] = ismember(background_net(:,1),Z);
                [~,index2] = ismember(background_net(:,2),Z);
                background_net_id = [index1 index2 background_net_w];
            % mutated         
                [~,index1] = ismember(mutated_net(:,1),Z);
                [~,index2] = ismember(mutated_net(:,2),Z);
                mutated_net_id = [index1 index2 mutated_net_w];
            % delete duplicate edges        
                background = [background_net_id;mutated_net_id];
                background = unique(background,'row','stable');
            % pathway link weight    
                [~,index1] = ismember(pathway_genes(:,1),Z);
                [~,index2] = ismember(pathway_genes(:,2),Z);
                W = ones(length(index1),1) * min(background_net_w);
                pathway_gene_pair = [index1 index2];
                [index3,index4] = ismember(pathway_gene_pair,background(:,1:2),'row');                
                W(index3) = background(index4(index4 ~= 0),3);        
                [index3,index4] = ismember(pathway_gene_pair,background(:,2:-1:1),'row');
                W(index3) = background(index4(index4 ~= 0),3);
                pathway_gene_id = [index1 index2 W];
                pathway_gene_id = unique(pathway_gene_id,'row','stable');
                
             % delete duplicate edges     
                [~,id1] = setdiff(background(:,1:2),pathway_gene_id(:,1:2),'row','stable');
                background = background(id1,:);
                [~,id2] = setdiff(background(:,1:2),[pathway_gene_id(:,2) pathway_gene_id(:,1)],'row','stable');
                deregulated_net = [background(id2,:);pathway_gene_id];
                
                N1 = length(Z);
                Net = zeros(N1);
                for k = 1 : size(deregulated_net,1)
                    Net(deregulated_net(k,1),deregulated_net(k,2)) = deregulated_net(k,3);
                    Net(deregulated_net(k,2),deregulated_net(k,1)) = deregulated_net(k,3);                    
                end
                
         % calculate influence socre using PCST
                Net = sparse(Net);
                G = tril(Net);  
                [~,s] = ismember(v,Z);   s = s(s ~= 0);
                [~,t] = ismember(vn,Z);  t = t(t ~= 0);
                [sp,~,~] = graphshortestpath(G,s,t,'directed',false);  % whether the network is connected
                if ~isinf(sp)
                    
                    [~,index] = ismember(diff_gene,DEG);
                    node_deg = Node(index);                   
                    diff_value = sum(node_deg);                    
                    [~,index] = ismember(diff_gene,Z);
                    node = zeros(N1,1);
                    node(index) = node_deg;
                    
                    [~,r] = MsgSteiner(Net,node',length(node_deg),50,s);
                    score = (sum(node) - r) / diff_value;
                    res = [res score];             
                else
                    res = [res 0];
                end
            end
            influence_score = [influence_score;res];
        end
    end   
end