function [cohort_driver_rank,personalized_driver_rank] = ...
                    PDGPCS(ppi,expression_normal,expression_tumor,cnv_filename,snv_filename,pathway)
%  PDGPCS outputs the patient-specific driver profiles
%  Input:
%         ppi: ppi network information
%         cnv_fileName,snv_fileName: mutation profiles(CNV and SNV)
%         expression_normal & expression_tumor: expression profiles (normal and normal) 
%         pathway: pathway data
%  Output:
%         cohort_driver_rank: driver genes ranking in the population. 
%         personalized_driver_rank: the ranking of each patient.
 
    [tumor,~,~] = importdata(expression_tumor);
    tumor_data = tumor.data;
    samples = tumor.textdata(1,2:end);
    gene_list = tumor.textdata(2:end,1);    
    [normal,~,~] = importdata(expression_normal);
    normal_data = normal.data;
    
    snv = importdata(snv_filename); 
    snv_samples = snv.textdata(1,2:end);
    
    cnv = importdata(cnv_filename); 
    cnv_samples = cnv.textdata(1,2:end);
    
    mutated_samples = intersect(snv_samples,cnv_samples);
    
    all_driver = [];
    
    for i = 1 : size(tumor_data,2)
        [~,index] = ismember(samples(:,i),mutated_samples);
        if index ~= 0
            
            % construct personalized gene interaction network
            sample_tumor = tumor_data(:,i);        
            sample_normal = normal_data(:,i);
            fprintf('construct network ...\n');
            [gene,edge] = construct_network(ppi,gene_list,normal_data,sample_normal,sample_tumor);
            net.gene = [gene(edge(:,1)) gene(edge(:,2))];
            net.w = edge(:,3); 
            
            gene1 = edge(:,1);  gene2 = edge(:,2);
            N1 = length(gene1); N2 = length(gene);
            Net = zeros(N2);
            for j = 1 : N1    
                Net(gene1(j,1),gene2(j,1)) = net.w(j,1);  %undirected gene-gene interaction network
            end        
            G1 = tril(Net);
            [g1,g2] = find(G1 ~= 0);
            G = graph(g1,g2);
            D = degree(G);
            fprintf('RWR selecting...\n');
            RWR_mutated_gene = get_mutated_gene(G,snv,cnv,samples(i),gene);
            hub_mutated_gene = gene(D > mean(D),:);
            mutated_gene = intersect(RWR_mutated_gene,hub_mutated_gene);
                     
            if ~isempty(mutated_gene)            
                
            %   node weight              
                beta = 1;      % FC    
                value = 0.01 * ones(length(sample_normal),1);
                node = abs(log2((sample_tumor + value) ./ (sample_normal + value)));             
                [~,index] = ismember(gene,gene_list);       
                node = node(index);
                DEG = gene(node > beta); 
                node = node(node > beta);
                
             %  calculate influence score  
                influence_score = mutation_dysregulation_network(pathway,DEG,D,node,net,mutated_gene);
             %  personalized ranking
                influence_score_total = sum(influence_score,1);
                mutated_gene(influence_score_total == 0,:) = [];
                influence_score_total(:,influence_score_total == 0) = [];
                [~,id] = sort(influence_score_total,'descend');
                driver = mutated_gene(id);                
            end 
            personalized_driver_rank(1,i) = samples(:,i);
            for  k = 1 : length(driver)
                personalized_driver_rank(k + 1,i) = driver(k,1);
            end
            all_driver = [all_driver;driver];
        end
    end 
    
    % cohort driver ranking
    cohort_driver_rank = condorcet(all_driver,personalized_driver_rank);
    
    % personalized driver ranking
    [num_x,num_y] = size(personalized_driver_rank);
    for x = 2: num_x
       for y = 1 : num_y
           if isempty(personalized_driver_rank{x,y})
              personalized_driver_rank{x,y} = ''; 
           end
       end
    end
    
end
