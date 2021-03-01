function [node,edge] = construct_network(ppi,gene_list,normal_data,sample_normal,sample_tumor)
   

    [~,y1] = ismember(ppi(:,1),gene_list);   
    [~,y2] = ismember(ppi(:,2),gene_list);
    
    y = y1 .* y2;
    z = [y1 y2];
    z(y == 0,:) = [];
    N1 = length(gene_list);
    [N2,~] = size(z);

    Net = zeros(N1,N1);
    for i = 1 : N2    
         Net(z(i,2),z(i,1)) = 1;  %undirected gene-gene interaction network
         Net(z(i,1),z(i,2)) = 1;    
    end
% ***************paired SSN*********************** 
               
    % construct the tumor SSN   
    [W0,P0] = SSN(sample_tumor,normal_data);
    P0(isnan(P0)) = 1;
    P0(P0 >= 0.05) = 0;
    P0(P0 ~= 0) = 1;         

    % construct the normal SSN     
    [W1,P1] = SSN(sample_normal,normal_data);
    P1(isnan(P1)) = 1;
    P1(P1 >= 0.05) = 0;
    P1(P1 ~= 0) = 1;

    % edge's weight
    W = abs(log2(W1 ./ W0)); 
    W(isnan(W)) = 0;
    W(isinf(W)) = 0;
    P = abs(P0 - P1);
    connected = P .* Net;
    W_edge = connected .* W;

    % delete isolated edges and nodes
    W_zero = find(sum(W_edge == 0,1) == size(W_edge,1));
    W_edge(W_zero,:) = [];
    W_edge(:,W_zero) = [];        
    node = gene_list;
    node(W_zero) = [];
    
    W_edge = tril(W_edge);
    [gene1,gene2] = find(W_edge ~= 0);
    weight = W_edge(W_edge ~= 0);
    edge = [gene1 gene2 weight];
end