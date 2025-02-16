function mutated_gene = select_mutated_genes(Adj,mutation)
    
    q_new = RWR(Adj,mutation);

    number = 1;
    ind =1 ;
    max_iter = 20;
    
    % random reconnect 
    A = tril(Adj);
    while ind       
        dir = dir_generate_srand(A);
        dir_srand = dir + dir';
        [X1,~] = find(dir_srand == 2);
        [X2,Y2] = find(dir_srand == 0);
        
        n = length(X1)/2;  m = length(X2);
        z = randperm(m); Z = z(1:n);
        X = X2(Z);       Y = Y2(Z);
        for i = 1 : length(X)
            dir_srand(X(i),Y(i)) = 1;
            dir_srand(Y(i),X(i)) = 1;
        end
        dir_srand(dir_srand > 0) = 1;
        
        q_rand = RWR(dir_srand,mutation);
        Q_rand(:,number) = q_rand;
        number = number + 1;
        if number > max_iter
            ind = 0;
        end
    end

    [row,~] = size(Q_rand);
    for i = 1 : row
        p(i,1) = (max(Q_rand(i,:)) < q_new(i,1));
    end
    p = double(p);
    q_new0 = q_new;
    q_new0(q_new0 > 0.0001) = 1;
    p_value = q_new0 .* p;
    down_stream = find(p_value > 0);
    mutated_gene = intersect(mutation,down_stream);

end