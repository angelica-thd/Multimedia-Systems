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
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);
conIMG = cat(3,R,G,B);
figure(1)
subplot(2,1,1);
imshow(conIMG); %constructed rgb image
title('Constructed RGB image.');

%perform the compression  process: 
%shift by 128 -> dct2 coefficients -> quantization -> matrix2vector -> huffman encoding
img = rgb2gray(conIMG);
shifted_img = double(img) - 128;      %shift image by 128
[rows,cols,rgb] = size(shifted_img);
imgBlocks = mat2cell(shifted_img,8*ones(1,rows/8),8*ones(1,cols/8));  %divide image in 8x8 blocks
for i = 1:13
    for j = 1:25
        dct2Blks{i,j} = zeros(8,8);
    end
end

quantization =  [16 12 14 14 18 24 49 72; 
                11 12 13 17 22 35 64 92;
                10 14 16 22 37 55 78 95; 
                16 19 24 29 56 64 87 98;
                24 26 40 51 68 81 103 112;
                40 58 57 87 109 104 121 100;
                49 64 78 89 103 113 120 103;
                72 92 95 98 112 100 103 99];
            
for r = 1:size(imgBlocks,1)
    for c = 1:size(imgBlocks,2)
        dct2Blks{r,c} = dct2(cell2mat(imgBlocks(r,c)));
        for blkR = 1:size(dct2Blks{r,c},1)
            for blkC = 1:size(dct2Blks{r,c},2)
                quantBlks(blkR,blkC) = round(dct2Blks{r,c}(blkR,blkC)/quantization(blkR,blkC));
                quantized{r,c} = quantBlks;
            end
        end
    end
end

img2encode = zigzag(cell2mat(quantized));
[p,edges] = histcounts(img2encode,2,'Normalization','probability');
[dict,avgLen] = huffmandict(unique(img2encode),p);
encodedIMG = huffmanenco(img2encode,dict);

%perform the decompression process: 
%huffman decoding -> vector2matrix > dequantization -> invDCT -> unshift by
%128

img2decode = huffmandeco(encodedIMG,dict); 
decodedIMG = invZigzag(img2decode,size(imgRGB,1),size(imgRGB,2));
decodedBlks = mat2cell(decodedIMG,8*ones(1,rows/8),8*ones(1,cols/8),N);

for r = 1:size(decodedBlks,1)
    for c = 1:size(decodedBlks,2)
        for blkR = 1:size(decodedBlks{r,c},1)
            for blkC = 1:size(decodedBlks{r,c},2)
                dequantBlks(blkR,blkC) = decodedBlks{r,c}(blkR,blkC)*quantization(blkR,blkC);
                dequantized{r,c} = dequantBlks;
            end
        end
        reconstructedBlks{r,c} = idct(cell2mat(dequantized(r,c)));
    end
end

reconGrayIMG = cell2mat(reconstructedBlks);
reconGrayIMG = reconGrayIMG + 128;
reconGrayIMG = uint8(mat2gray(reconGrayIMG)*255);
map = hsv(256);
figure(1)
subplot(2,1,2);
reconRGB = ind2rgb(reconGrayIMG,map);
imshow(reconRGB,[]);
title('Decompressed RGB Image');

        
