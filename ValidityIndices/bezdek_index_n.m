% Generalized Dunn Index
%   MAIN REFERENCES:
%       - J. C. Bezdek and N. R. Pal, “Cluster validation with generalized Dunn’s indices,” in Proceedings - 1995 2nd New Zealand International Two-Stream Conference on Artificial Neural Networks and Expert Systems, ANNES 1995, 1995, pp. 190–193, doi: 10.1109/ANNES.1995.499469.

function bez=bezdek_index(a)
%% how to use the function
% for example considering 4 clusters
% If each cluster is codified as a matrix where
% each row is a sample and each feature is a column 
% you have 4 matrices that could have different size in the
% row (samples in the cluster) but same size in the column (number of
% features). If you give the following name to the four matrix:
% alfa, beta, gamma, delta. You have to write the function in this way:

% indice=bezdek_index_n([{alfa} {beta} {gamma} {delta}]);

% the output indice will be the value computed for the Bezdek_index

%%

numeratore=1e10;
for i=1:length(a)-1
    for j=i+1:length(a)
    numeratore=min([numeratore, num(a{i},a{j})]);
    end
end

denominatore=0;
for i=1:length(a)
       denominatore=max([denominatore, 2*den([a{i}])]); 
end

if (numeratore>0)
    %bez=round(100*numeratore/denominatore)/100;
    bez=numeratore/denominatore;
    else
        bez=0;
end
    
%% support functions



function num=num(sf1,sf2)

n1=size(sf1,1);
n2=size(sf2,1);

num=0;
for i=1:n1
        for j=1:n2
            num=num+sqrt(sum((sf1(i,:)-sf2(j,:)).^2,2));
        end
end
num=num/(n1*n2);


function den=den(sf1)

den=sf1-repmat(mean(sf1),size(sf1,1),1);

den=mean(sqrt(sum(den.^2,2)));


