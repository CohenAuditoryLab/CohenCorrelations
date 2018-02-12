function output = CohenCorr2(spikesData, taskData, startTime, endTime, sampleRate)
%CohenCorr2 Returns correlation structure for specified snippet of spikes
%   INPUTS:
    %   spikesData: path to spikes
    %   taskData: path to task data
    %   startTime: the start of the desired time range
    %   endTime: the end of the desired time range
    %   sampleRate: rate of sampling during electrophysiology recording
%   OUTPUTS:
    %   output.spikesInTrial: spike sample #s within designated time range
    %   output.uniqueNeurons: 1-d array of unique neuron IDs
    %   output.spikeRaster: MATLAB figure object of spike raster plot 
    %   output.spikesByBin: spike trains by neuron across ms bins
    %   output.adjacencyMatrix: adjacency matrix based on maxCrossCorr
    %   output.matrixFigure: MATLAB figure object of adjacency matrix 
    %   output.graphMetrics: struct of BCT graph metrics for dataset
    
    % load libraries
        addpath(genpath('libraries'));
        addpath(genpath('services'));
    % initialize variables
        projectFolder = pwd;
        initializeVariables;
    % turn off figure generation
        set(0,'DefaultFigureVisible','off');
        outputCollector = [];
        for trial=1:size(sounds,1)
            disp(['Analyzing Trial #' num2str(trial)]);
            trialDirectory = [baseOutputDirectory sslash 'trials' sslash 'trial_' num2str(trial)];
            trialOutputDirectory = [trialDirectory sslash 'trialOutput'];
            preTrialOutputDirectory = [trialDirectory sslash 'preTrialOutput'];
            mkdir(trialOutputDirectory); mkdir(preTrialOutputDirectory);
            output = [];
            output.uniqueNeurons = uniqueNeurons;
        % do trial analysis
            startTime = sounds(trial,1); endTime = sounds(trial,2);
            output.spikesInTrial = spikesData(spikesData(:,2)>startTime & spikesData(:,2)< endTime,:);
            output.trial = analyzeSpikes(output.spikesInTrial, uniqueNeurons, sampleRate, startTime, endTime, trialOutputDirectory, trial, sslash);
        % do pretrial analysis
            disp(['Analyzing Spikes before Trial #' num2str(trial)]);
            output.spikesPreTrial = spikesData(spikesData(:,2)<startTime & spikesData(:,2)> (startTime-avgSoundTime),:);
            output.preTrial = analyzeSpikes(output.spikesPreTrial, uniqueNeurons, sampleRate, (startTime-avgSoundTime), startTime, preTrialOutputDirectory, trial, sslash);
        % save output
            saveCorrOutput(output, trialDirectory, sslash);
            outputCollector = [outputCollector; output];
        end
        save([baseOutputDirectory sslash 'collectedCorrelationalOutput.mat'], 'outputCollector');
        disp('Correlational analysis complete.');
    % turn on figure generation
        set(0,'DefaultFigureVisible','on');
end