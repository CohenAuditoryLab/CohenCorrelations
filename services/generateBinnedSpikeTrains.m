function generateBinnedSpikeTrains = generateBinnedSpikeTrains(spikesInTrial, uniqueNeurons, startTime, endTime, sampleRate)
% generateBinnedSpikeTrains generates binned spike trains (1s and 0s) from
% spikesInTrial in ms bins

    disp('Generating binned spike trains.');
    % intialize variables
    bin_size = 1e-3*sampleRate; % in samples; each bin is a ms
    num_bins = round((endTime-startTime)/bin_size) + 1; % add a bin to be safe
    bins = startTime:bin_size:(startTime+bin_size*num_bins);
    num_bins = numel(bins);
    %loop
    N = numel(uniqueNeurons);
    spikesByBin = zeros(N, num_bins);
    for i = 1:N % 1 to num clusters
        % get spike times of the cell
        cluster_spikes = spikesInTrial(spikesInTrial(:,1) == uniqueNeurons(i),2); % now in seconds
        % collect by bin
        spikesByBin(i,:) = histc((cluster_spikes),bins);
    end
    generateBinnedSpikeTrains = spikesByBin;
end