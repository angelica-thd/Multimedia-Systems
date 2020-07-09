tic;
[frames, map]=imread('birdGif.gif', 'gif','Frames','all');
s=size(frames);
numOfFrames=s(4);

blkMatcher = vision.BlockMatcher;
blkSize = 16;
%blkSize = 8;
%blockSize = 4;
blkMatcher.BlockSize = [17 17];
%blkMatcher.BlockSize = [9 9];
%blkMatcher.BlockSize = [5 5];
blkMatcher.MaximumDisplacement = [10 10];
blkMatcher.MatchCriteria = 'Mean absolute difference (MAD)';
blkMatcher.ReferenceFrameSource = 'Input port';
halphablend = vision.AlphaBlender;

[last, cmap] = imread('birdGif.gif', numOfFrames);
rgbLast = uint8(255*ind2rgb(last,cmap));
lastImage = im2double(rgbLast);
lastBlocks = mat2cell(lastImage,blkSize*ones(1,s(1)/blkSize),blkSize*ones(1,s(2)/blkSize),3);    %last frame doubled with 3 dimensions for the division to 16x16 blocks

for i = 1:numOfFrames-1
    %take 2 continious frames and convert them to matrices.
    [ref, colours] = imread('birdGif.gif',i);
    rgbRef = uint8(255*ind2rgb(ref,colours));   %reference frame doubled with 3 dimensions for the division to 16x16 blocks
    referenceImage = im2double(rgbRef);
   
    ref4mv = im2double(ref);        %reference frame doubled with 2 dimensions for the motionVectors
    
    [curr,coloursC] = imread('birdGif.gif',i+1);  
    rgbCurr = uint8(255*ind2rgb(curr,coloursC));  
    currentImage = im2double(rgbCurr);      %current frame doubled with 3 dimensions for the division to 16x16 blocks
    
    current4mv = im2double(curr);   %current frame doubled with 2 dimensions for the motionVectors
    
    %with blkMatcher we divide the image in blocks and calculate the motion vectors. 
    motionVectors = blkMatcher(ref4mv,current4mv);
    currentBlocks = mat2cell(currentImage,blkSize*ones(1,s(1)/blkSize),blkSize*ones(1,s(2)/blkSize),3);
    for r = 1:31
        for c = 1:31
            if motionVectors(r,c) ~= 0
               currentBlocks{r,c} = lastBlocks{r,c};
            end
        end                
    end
    currentImage = cell2mat(currentBlocks);     %reconstructed the current frame from the blocks
    
    %original image
    figure(1);
    subplot(2,2,1);
    imshow(ref, colours);
    caption = sprintf('Original frame %d of %d.',i,numOfFrames-1);
    title(caption,'FontSize',10);
    drawnow;
    
    %reconstructed image
    figure(1);
    subplot(2,2,2);
    imshow(uint8(round(currentImage*255)));
    caption = sprintf('Reconstructed frame %d of %d.',i,numOfFrames-1);
    title(caption,'FontSize',10);
    drawnow;
    
    figure(1);
    subplot(2,2,4);
    imagesc(motionVectors);
    caption = sprintf('Motion Vectors for frame %d of %d.',i,numOfFrames-1);
    title(caption,'FontSize',10);
    drawnow;
    
    figure(1);
    subplot(2,2,3);
    errorFrame = referenceImage - currentImage;
    imshow(uint8(round(errorFrame*255)));  
    caption = sprintf('Error frame %d of %d.',i,numOfFrames-1);
    title(caption,'FontSize',10)     
    drawnow;
    
    
end
toc



