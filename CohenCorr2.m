function result = CohenCorr2(spikes_data, tasks_data, sample_rate)
%CohenCorr2 Returns correlation structure for specified snippet of spikes
%   INPUTS:
%   spikes_data: path to spikes
%   tasks_data: path to task data
%   
%   OUTPUTS:
%   result: 

    % initialize variables
    if exist('spikes_data', 'var') == 0
        spikes_data = load('data/spikes/jan14_18_AL.mat');
        spikes_data = spikes_data.standard_output;
    end
    if exist('tasks_data', 'var') == 0
        tasks_data = load('data/tasks/jan14_18.mat');
    end
    if exist('sample_rate', 'var') == 0
        sample_rate = 24410;
    end
    % extract specified times
    %start_time = 1661372;
    %end_time = 1756870;
    start_time = 3849918; % starting w/ Trial 12
    end_time = 4099117;
    spikes_in_trial = spikes_data(find(spikes_data(:,2)>start_time & spikes_data(:,2)< end_time),:);
    % make a raster plot
        % get unique neurons, sort them
        unique_neurons = unique(spikes_in_trial(:,1));
        % loop through unique neurons & print each one to plot
        figure;
        hold on;
        for i=1:numel(unique_neurons)
            spks = double(spikes_in_trial(find(spikes_in_trial(:,1) == unique_neurons(i)),2))/sample_rate;
            if(~isempty(spks))
                plot(spks,i,'b.');
            end
        end
        yticks(unique_neurons);
        ylabel('Proposed Neurons');
        xlabel('Time (s)');
        title('Jan 14 Block 4 - Textures - Trial 12');
        xmin = min(double(spikes_in_trial(:,2)))/sample_rate;
        xmax = max(double(spikes_in_trial(:,2)))/sample_rate;
        xlim([(xmin - 2.5e-3*xmin) (xmax+2.5e-3*xmax)]);
    % convert spikes to spike trains
        spike_trains = zeros([numel(unique_neurons),numel([start_time:end_time])]);
        spikes = spikes_in_trial;
        spikes(:,2) = spikes_in_trial(:,2) - start_time;
        for i=1:numel(unique_neurons)
            spike_trains(i,[spikes(spikes(:,1) == unique_neurons(i),2)]) = 1;
        end
            
    % generate adjacency matrix for neurons
        N = numel(unique_neurons);
        C = zeros(N);
        upd = textprogressbar(N);
        for i=1:N
            upd(i);
            for j=1:N
                if(i~=j)
                    r = xcorr(spike_trains(i,:),spike_trains(j,:),500,'coeff');
                    if (r < 0)
                        r = 0;
                    end
                    C(i,j) = max(r);
                end
            end
        end
        heatmap(C);
        ylabel('Clusters'); xlabel('Pearson R value');    
        title('Pair-Wise Max-Cross Correlations; Jan 14 Block 3 Trial 12');
    % run BCT on adjacency matrix
end