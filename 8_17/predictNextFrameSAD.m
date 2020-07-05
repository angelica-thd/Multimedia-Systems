function [next] = predictNextFrameSAD(targetFrame,referenceFrame)
    [rows,cols,rgb] = size(targetFrame);
    count = 0;
    while rem(rows,16)~=0
        count = count+1;
        rows = rows+1;  %count how many rows are missing from the frames in order for mod(rows,16) = 0
    end
    tmp = zeros(1,cols,rgb);

    %initialize matrices
    for k = 1:4
        differ{k} = zeros(16,16,3);
        sad{k} = zeros(16,16,3);
    end
    
  %divide current frame into 16x16 macroblocks
    targetFrame = [targetFrame; repmat(tmp,count,1)]; %add 0-rows to each frame
    target = mat2cell(targetFrame,16*ones(1,rows/16),16*ones(1,cols/16),rgb);  %divide each frame into a cellarray of 16 blocks

    %divide previous block into 16x16 macroblocks
    referenceFrame = [referenceFrame; repmat(tmp,count,1)];
    ref = mat2cell(referenceFrame,16*ones(1,rows/16),16*ones(1,cols/16),rgb);

    %predict next frame using SAD metric
    for r = 1:size(target,1)
        for c = 1:size(target,2)
         [kRows,kCols] = kCoordinates(r,c);                  
            for k = 1:size(kRows)
                tmpRow = r+kRows(k);
                tmpCol = c+kCols(k);                 
                differ{k} = abs(cell2mat(target(r,c)) - cell2mat(ref(tmpRow,tmpCol)));
                sad{k}  = cell2mat(sad(k)) + double(cell2mat(differ(k)));                   
            end
           min  = minimumSAD(sad);
           next{r,c} = ref{r+kRows(min),c+kCols(min)};
        end                        
    end
     
    
end

