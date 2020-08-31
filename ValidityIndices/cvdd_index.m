function cvddindex = cvdd_index(X, piX)

    d = pdist2(X,X,'minkowski',2); %Euclidean distance of X
    try
        DD = Density_involved_distance(d, 7); %Density-involved distance of X
        cvddindex = CVDD(piX, d, DD);
    catch
        % an error will be catch when the Rel function fails
        % because of 0 distances between some points (total overlap)
        % in this case, the minimum value of the index will be returned
        cvddindex = 0;
    end

    function CVDD = CVDD(piX,d,DD)
        % -------------------------------------------------------------------------
        %Aim: The matlab code of "An internal validity index based on density-involved distance"
        %Algorithm 1: CVDD
        % -------------------------------------------------------------------------
        %Input:
        %pi: the partition of X
        %d: the Euclidean distance between objects in X
        % -------------------------------------------------------------------------
        %Output:
        %results: the CVDD index of pi
        % -------------------------------------------------------------------------
        % Written by Lianyu Hu
        % Department of Computer Science, Ningbo University 
        % February 2019

        %% initialization
        NC = length(unique(piX));
        sc_list = zeros(NC,1); %separation
        com_list = zeros(NC,1);%compactness
        %% 
        for i = 1: NC
            a = find(piX == i);
            b = piX ~= i;
            n = length(a);
            if isempty(a)~=1
                %% compute the separation sep[i]
                sc_list(i,1) = min(min(DD(a,b)));
                %% compute the compactness com[i]
                try
                    Ci = fast_PathbasedDist(d(a,a));
                    % std2 requires Image Processing Toolbox
                    com_list(i,1) = (std2(Ci)/n)*mean(Ci(:));
                    %com_list(i,1) = (std(Ci(:))/n)*mean(Ci(:));
                catch
                    com_list(i,1) = max(com_list);
                end
            else
                sc_list(i,1)=0;
                com_list(i,1) = max(com_list);
            end
        end
        %% compute the validity index CVDD 
        sep = sum(sc_list);
        com = sum(com_list);
        CVDD = sep/com;
    end
end