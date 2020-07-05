tic;
v = VideoReader('catvideo.mp4');

for i = 1:v.NumFrames
    target = read(v,i);
    %show original-framed video
    figure(1)
    subplot(3,2,1);
    image(target);
    caption = sprintf('Original frame %d of %d.',i,v.NumFrames);
    title(caption,'FontSize',10);
    drawnow;
        if i>1 && i<v.NumFrames
        reference = read(v,i-1);
        frames{i} = predictNextFrameSAD(target,reference);
        
        %show predicted-framed video
        figure(1)
        subplot(3,2,2);
        image(cell2mat(frames{i}));
        caption = sprintf('Reconctructed frame %d of %d.',i+1,v.NumFrames);
        title(caption,'FontSize',10);
        drawnow;
        
        %show error frames
        figure(1)
        subplot(2,2,3);
        error = curr - cell2mat(frames{i});
        image(error);
        caption = sprintf('Error frame %d of %d.',i+1,v.NumFrames);
        title(caption,'FontSize',10);
        drawnow;
        
        %calculating the entropy of the error frames
        reconEnt(i) = entropy(error);
        figure(1)
        subplot(2,2,4)
        plot(reconEnt,'LineWidth',2);
        xlim([0 111]);
        title('Entropy of error frames.','FontSize',10);
    end
end       
toc