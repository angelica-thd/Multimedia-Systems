function [min] = minimumSAD(sad)
min= 1;
for i = 1:4
    minMx{i} = zeros(16,16,3);
end

for i = 1:4
    if cell2mat(sad(i)) < cell2mat(minMx(i))
        minMx(i) = sad(i)
        min = i
    end    
end

