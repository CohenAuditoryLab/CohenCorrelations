function comparisons = compareTrialPreTrial(outputCollector, baseOutputDirectory, sslash)
    a = [outputCollector.trial]; a = [a.graphMetrics]; 
    b = [outputCollector.preTrial]; b = [b.graphMetrics]; 

    metricNames = fieldnames(a);
    comparisons = [];
    for i=1:numel(metricNames)
        name = metricNames(i);
        newComparisons = [];
        try
           [x,y] = size([a.(name{1})]);
           if (x == 1)
               % disp('yay');
               newComparisons.metricName = name{1};
               newComparisons.trialMean = mean([a.(name{1})]);
               newComparisons.trialVariance = var([a.(name{1})]);
               newComparisons.preTrialMean = mean([b.(name{1})]);
               newComparisons.preTrialVariance = var([b.(name{1})]);
               [~,newComparisons.tTestP] = ttest([a.(name{1})], [b.(name{1})]);
               comparisons = [comparisons; newComparisons];
           end
        catch
        end
    end
    % compare spikes
    trialSpikeNum = zeros(size(outputCollector,1),1);
    preTrialSpikeNum = zeros(size(outputCollector,1),1);
    for i=1:size(outputCollector,1)
        trialSpikeNum(i) = size(outputCollector(i).spikesInTrial,1);
        preTrialSpikeNum(i) = size(outputCollector(i).spikesPreTrial,1);
    end
    newComparisons.metricName = 'spikeNumber';
    newComparisons.trialMean = mean(trialSpikeNum);
    newComparisons.trialVariance = var(trialSpikeNum);
    newComparisons.preTrialMean = mean(preTrialSpikeNum);
    newComparisons.preTrialVariance = var(preTrialSpikeNum);
    [~,newComparisons.tTestP] = ttest(trialSpikeNum, preTrialSpikeNum);
    comparisons = [comparisons; newComparisons];
    save([baseOutputDirectory sslash 'comparisons.mat'], 'comparisons');
end