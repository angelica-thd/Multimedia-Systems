%cell array info: refer to sets of cells be enclosing indices in ()
%access contents of cells by indexing with {}
%access blocks -> frames{1}(1,1,1)

v = VideoReader('catvideo.mp4')
[rows,cols,rgb] = size(readFrame(v));  %use one frame to store the size of rows,cols and color array
count = 0;
while rem(rows,16)~=0
    count = count+1;
    rows = rows+1;  %count how many rows are missing from the frames in order for mod(rows,16) = 0
end
tmp = zeros(1,cols,rgb);
for k = 1:4
    diff{k} = zeros(16,16,3);
    sad{k} = zeros(16,16,3);
    minus{k} = zeros(16,16,3);
end

for i = 1:10
    curr = read(v,i);
    curr = [curr; repmat(tmp,count,1)]; %add 0-rows to each frame
    currBlock{i} = mat2cell(curr,16*ones(1,rows/16),16*ones(1,cols/16),rgb);  %divide each frame into a cellarray of 16 blocks
    current = currBlock{i};
    if i>1
        prev = read(v,i-1);
        prev = [prev; repmat(tmp,count,1)];
        prevBlock{i} = mat2cell(prev,16*ones(1,rows/16),16*ones(1,cols/16),rgb);
        previous = prevBlock{i};
        for r = 1:size(current,1)
            for c = 1:size(current,2)
             [kRows,kCols] = kCoordinates(r,c);                  
                for k = 1:size(kRows)
                    tmpRow = r+kRows(k);
                    tmpCol = c+kCols(k);                 
                    diff(k) = cellfun(@minus, current(r,c), previous(tmpRow,tmpCol),'UniformOutput',0);                  
                    tmpSAD = sad{k};
                    tmpDiff = double(abs(diff{k}));
                    tmpSAD = tmpSAD + tmpDiff;
                    sad{k} = tmpSAD;
                end
               minimum = sad{1};
               nextBlock{r,c} = minimum;
               nextFrame{i} = nextBlock;
            end
            
                   
        end

    end
            imshow(nextFrame);
end  
        







