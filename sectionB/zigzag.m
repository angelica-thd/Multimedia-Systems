function [vector] = zigzag(img)
vector = zeros(1,size(img,1)*size(img,2));  %vector of size [height*width] of the img
row = 1;
col = 1;
i = 1;

while row <= size(img,1) && col <= size(img,2)
    if rem(row+col,2)==0
        if row == 1
            vector(i) = img(row,col);
            if col == size(img,2)
                row = row +1;
            else
                col = col+1;
            end
            i = i+1;
        elseif row < size(img,1) && col == size(img,2)
            vector(i) = img(row,col);
            row = row+1;
            i = i+1;
        elseif row >1 && col<size(img,2)
            vector(i) = img(row,col);
            row = row -1;
            col = col+1;
            i = i+1;
        end
    else 
        if  row == size(img,1) && col <= size(img,2)
            vector(i) = img(row,col);
            col = col+1;
            i = i+1;
        elseif col == 1
            vector(i) = img(row,col);
            if row == size(img,1)
                col = col+1;
            else
                row = row+1;
            end
            i =i+1;
        elseif row<size(img,1) && col>1
            vector(i) = img(row,col);
            row = row+1;
            col = col+1;
            i = i+1;
        end
    end
    if row == size(img,1) && col==size(img,2)
        vector(i) = img(row,col);
        break
    end
end


