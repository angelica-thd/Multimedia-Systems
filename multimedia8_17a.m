v = VideoReader('catvideo.mp4')
current = read(v,1);
for i = 1:v.NumFrames
    f = read(v,i);
    figure(1)
    subplot(2,2,1);
    image(f);
    caption = sprintf('Frame %d of %d.',i,v.NumFrames);
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
        %calculating the entropy of the reconstructed frames
        reconEnt(i) = entropy(current);
        figure(1)
        subplot(2,2,4)
        plot(reconEnt,'LineWidth',2);
        xlim([0 111]);
        title('Entropy of reconstructed frames.','FontSize',10);
    end 
    %calculating the entropy of the original frames   
    originalEnt(i) = entropy(read(v,i));
    figure(1)
    subplot(2,2,3);
    plot(originalEnt,'LineWidth', 2);
    xlim([0 111]);
    title('Entropy of original frames.','FontSize',10);
    
    %error frames
    error = read(v,i) - current;
    figure(2)
    image(error)
    caption = sprintf('Error of frame %d.',i);
    title(caption,'FontSize',14);
    drawnow; 
end