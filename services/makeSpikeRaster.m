function makeSpikeRaster = makeSpikeRaster(spikesInTrial, uniqueNeurons, sampleRate, output_directory, sslash)
% makeSpikeRaster generates a raster for the specified spikes per time
    % loop through unique neurons & print each one to plot
        disp('Generating & saving spike raster.');
        upd = textprogressbar(numel(uniqueNeurons) + 1);
        h = figure;
        hold on;
        for i=1:numel(uniqueNeurons)
            spks = double(spikesInTrial(find(spikesInTrial(:,1) == uniqueNeurons(i)),2))/sampleRate;
            if(~isempty(spks))
                plot(spks,i,'b.');
            end
            upd(i);
        end
        hold off;
        ylim([0 numel(uniqueNeurons)+1])
        yticks(uniqueNeurons);
        ylabel('Proposed Neurons');
        xlabel('Time (s)');
        title('Jan 14 Block 3 - Textures - Trial 12');
        xmin = min(double(spikesInTrial(:,2)))/sampleRate;
        xmax = max(double(spikesInTrial(:,2)))/sampleRate;
        xlim([(xmin - 2.5e-3*xmin) (xmax+2.5e-3*xmax)]);
        hold off;
        %saveas(h, [output_directory sslash 'spikeRaster.fig']);
        %saveas(h, [output_directory sslash 'spikeRaster.png']); % this
        %takes too long for some reason
        upd(numel(uniqueNeurons) + 1);
        clf; close(h);
        makeSpikeRaster = h;
end