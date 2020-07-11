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
    [ref , colours] = imread('birdGif.gif',i);
    referenceImage = im2double(ref);
    [curr, coloursc] = imread('birdGif.gif',i+1);
    currentImage = im2double(curr);

    %with blkMatcher we divide the image in blocks and calculate the motion vectors. 
    motionVectors = blkMatcher(referenceImage,currentImage);
    
    %Create figure
    figure(1);
    subplot(2,2,1);
    imshow(ref, colours);
    caption = sprintf('Original video. Frame %d of %d.',i,numOfFrames);
    title(caption,'FontSize',10);
    drawnow;
    
    %Sinthesh twn 2 eikonwn 
    BlendedImage = halphablend(currentImage,referenceImage);
    [X,Y] = meshgrid(1:17:size(referenceImage,2),1:17:size(referenceImage,1)); 
    figure(1);
    subplot(2,2,2);
    image(BlendedImage);
    caption = sprintf('Motion Vectors (Arrows) for frame %d of %d.',i+1,numOfFrames);
    title(caption,'FontSize',10);
    drawnow;
    hold on
    quiver(X(:),Y(:),real(motionVectors(:)),imag(motionVectors(:)),0)
    hold off
    
    figure(1);
    subplot(2,2,3);
    imagesc(motionVectors);
    caption = sprintf('Motion Vectors (Colours) for frame %d of %d.',i+1,numOfFrames);
    title(caption,'FontSize',10);
    drawnow;
    
    figure(1);
    subplot(2,2,4);
    caption = sprintf('Motion Vectors (Numeric)');
    title(caption,'FontSize',10)
    uit = uitable('Data',motionVectors);
    uit.Position = [305 29 210 165];
    uit.ColumnEditable = false;
    drawnow;
end

figure(1);
subplot(2,2,1);
last = imread('birdGif.gif',51);
imshow(last);
caption = sprintf('Original video. Frame %d of %d.',51,numOfFrames);
title(caption,'FontSize',10);
drawnow;





