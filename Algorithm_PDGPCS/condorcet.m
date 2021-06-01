function cohort_ranking = condorcet(u,rank)
%function:
%         rank the candidate genes with the condorcet method
%Input:
%      u:    the union of all patients' driver genes
%      rank: the result of personalized driver ranking
%Output:
%      cohort_ranking: the rank information of all genes
    
    A = zeros(length(u));
    [num_x,num_y] = size(rank);
    
    for y = 1 : num_y
        
        r = rank(2:num_x,y);
        for x = 1 : (num_x - 1)
            if isempty(r{x,1})
                r = r(1:(x - 1),:);
                break;
            end
        end
        
        
        [~,sample_driver] = ismember(r,u);

        A0 = zeros(length(u));

        for i = 1 : length(u)
            for j = i + 1 : length(u)

                [~,value_x] = ismember(i,sample_driver(:,1));
                [~,value_y] = ismember(j,sample_driver(:,1));

                if value_x * value_y == 0
                    if value_x ~= 0
                        A0(i,j) = 1;
                    end
                    if value_y ~= 0
                        A0(j,i) = 1;
                    end
                else
                    if value_x < value_y
                       A0(i,j) = 1; 
                    else
                       A0(j,i) = 1;
                    end
                end
            end
        end
        A = A + A0;
    end
    total = sum(A,2);
    [~,id] = sort(total,'descend');
    cohort_ranking = u(id);
end


