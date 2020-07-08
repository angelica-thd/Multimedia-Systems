[frames, map]=imread('birdGif.gif', 'gif','Frames','all');
s=size(frames);
numOfFrames=s(4);

blkMatcher = vision.BlockMatcher;
blkMatcher.BlockSize = [17 17];
blkMatcher.MaximumDisplacement = [10 10];
blkMatcher.MatchCriteria = 'Mean absolute difference (MAD)';
blkMatcher.ReferenceFrameSource = 'Input port';
halphablend = vision.AlphaBlender;


for i = 1:numOfFrames-1
    %take 2 continious frames and convert them to matrices.
    [ref, colours] = imread('birdGif.gif',i);
    referenceImage = im2double(ref);
    [curr,coloursC] = imread('birdGif.gif',i+1);
    currentImage = im2double(curr);
    %with blkMatcher we divide the image in blocks and calculate the motion vectors. 
    motionVectors = blkMatcher(referenceImage,currentImage);
    currentBlocks = mat2cell(currentImage,16*ones(1,s(1)/16),16*ones(1,s(2)/16));
    for r = 1:31
        for c = 1:31
            if motionVectors(r,c) ~= 0
                currentBlocks{r,c} = currentBlocks{4,5};               
            end
       end
    end
    currentImage = cell2mat(currentBlocks);
    %original image
    figure(1);
    subplot(2,2,1);
    imshow(ref, colours);
    caption = sprintf('Original video. Frame %d of %d.',i,numOfFrames-1);
    title(caption,'FontSize',10);
    drawnow;
    
    %reconstructed image
    figure(1);
    subplot(2,2,2);
    imshow(currentImage,[]);
    caption = sprintf('Reconstructed video. Frame %d of %d.',i,numOfFrames-1);
    title(caption,'FontSize',10);
    drawnow;
    
    figure(1);
    subplot(2,2,4);
    imagesc(motionVectors);
    caption = sprintf('Motion Vectors (Colours) for frame %d of %d.',i+1,numOfFrames-1);
    title(caption,'FontSize',10);
    drawnow;
    
    figure(1);
    subplot(2,2,3);
    errorFrame = referenceImage - currentImage;
    imshow(errorFrame,[]);  
    caption = sprintf('Error frame %d of %d.',i+1,numOfFrames-1);
    title(caption,'FontSize',10)     
    drawnow;
    
    
end




