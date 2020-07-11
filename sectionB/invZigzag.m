function [img] = invZigzag(vector,rows,cols)
img = zeros(rows,cols,3);
row = 1;
col = 1;
i = 1;

while row<=rows && col<=cols
    if rem(row+col,2)==0
        if row == 1
            img(row,col) = vector(i);
            if col == cols
                row = row+1;
            else
                col = col+1;
            end
            i = i+1;
        elseif col==cols && row<rows
            img(row,col) = vector(i);
            row = row+1;
            i = i+1;
        elseif row>1 && col<cols
            img(row,col) = vector(i);
            row = row-1;
            col = col+1;
            i = i+1;
        end
    else
        if row==rows && col<cols
            img(row,col)=vector(i);
            col = col+1;
            i = i+1;
        elseif col==1
            img(row,col) = vector(i);
            if row ==rows
                col = col+1;
            else
                row = row+1;
            end
            i = i+1;
        elseif row<rows && col>1
            img(row,col) = vector(i);
            row = row+1;
            col = col-1;
            i = i+1;
        end
    end
    if row == rows && col == cols
        img(row,col) = vector(i);
        break
    end                     
end
end

