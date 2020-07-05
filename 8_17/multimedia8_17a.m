tic;
v = VideoReader('catvideo.mp4');
current = read(v,1);
for i = 1:v.NumFrames
    f = read(v,i);
    figure(1)
    subplot(2,2,1);
    image(f);
    caption = sprintf('Original frame %d of %d.',i,v.NumFrames);
    title(caption,'FontSize',10);
    drawnow;
    if i < v.NumFrames
        diff = read(v,i) - read(v,i+1);
        current = current+diff;
        figure(1)
        subplot(2,2,2);
        image(current);
        caption = sprintf('Reconctructed frame %d of %d.',i+1,v.NumFrames);
        title(caption,'FontSize',10);
        drawnow;
    end 
 
    %error frames
    error = read(v,i) - current;
    figure(1)
    subplot(2,2,3)
    image(error)
    caption = sprintf('Error frame %d of %d.',i,v.NumFrames);
    title(caption,'FontSize',10);
    drawnow; 
    
     %calculating the entropy of the error frames   
    originalEnt(i) = entropy(read(v,i));
    figure(1)
    subplot(2,2,4);
    plot(originalEnt,'LineWidth', 2);
    xlim([0 111]);
    title('Entropy of error frames.','FontSize',10);
end
toc