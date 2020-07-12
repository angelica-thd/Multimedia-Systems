%image construction
N = 3;
A = [1 7 0 3 2; 1 7 0 8 1; 1 7 1 8 1;];
img = zeros(104,200,3);
for r = 1:104
    for c = 1:200 
        for N = 1:3
            if c<=5
                am = A(randi(3),:);
                am(randi(5)) = 5;
                img(r,1:5,N) = am;
            elseif c>5 && rem(c,5)==0
                am = A(randi(3),:);
                am(randi(5)) = 5;
                img(r,c-4:c,N) = am;
            end      
        end
    end
end
figure(1)
subplot(2,1,1);
img = rgb2gray(img);
imshow(img); %constructed image
title('Constructed Image.');

%perform the compression  process: 
[rows,cols,rgb] = size(img);
imgBlocks = mat2cell(img,8*ones(1,rows/8),8*ones(1,cols/8));  %divide image in 8x8 blocks


quantization =  [16 11 10 16 24 40 51 61; 
                12 12 14 19 26 58 60 55;
                14 13 16 24 40 58 69 56; 
                14 17 22 29 51 87 80 62;
                18 22 37 56 68 109 103 77;
                24 35 55 64 81 104 113 92;
                49 64 78 87 103 121 120 101;
                72 92 95 98 112 100 103 99];
            
for r = 1:size(imgBlocks,1)
    for c = 1:size(imgBlocks,2)
        dctMatrix = dctmtx(size(imgBlocks{r,c},1)); %dct matrix of 8x8
        dct{r,c} = ceil(dctMatrix*cell2mat(imgBlocks(r,c))*dctMatrix');
        quantized{r,c} = cell2mat(dct(r,c))/quantization;
        dequantized{r,c} = cell2mat(quantized(r,c))*quantization;                 
        idct{r,c} = ceil(dctMatrix'*cell2mat(dequantized(r,c))*dctMatrix); 
    end
end

reconIMG = cell2mat(idct);
figure(1)
subplot(2,1,2);
imshow(reconIMG);
title('Dequantized Image');

%further compress the image with Huffman encoding
img2encode = zigzag(cell2mat(quantized));
syms = unique(img2encode);
counts = hist(img2encode,syms);
p = double(counts)./sum(counts);
[dict,avgLen] = huffmandict(syms,p);
compressedIMG = huffmanenco(img2encode,dict);

disp('The compression ratio of the quantized DCT image is:');
compressionRatio = numel(img) / numel(compressedIMG)
        
