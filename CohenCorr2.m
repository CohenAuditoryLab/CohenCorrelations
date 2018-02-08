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
        for trial=1:2
            disp(['Analyzing Trial #' num2str(trial)]);
            outputDirectory = [baseOutputDirectory sslash 'trials' sslash 'trial_' num2str(trial)];
            mkdir(outputDirectory);
            startTime = sounds(trial,1); endTime = sounds(trial,2);
            output = [];
        % extract specified times
            output.spikesInTrial = spikesData(find(spikesData(:,2)>startTime & spikesData(:,2)< endTime),:);
        % get unique neurons, sort them
            output.uniqueNeurons = unique(output.spikesInTrial(:,1));
        % make a raster plot
            output.spikeRaster = makeSpikeRaster(output.spikesInTrial, output.uniqueNeurons, sampleRate, outputDirectory, sslash);   
        % bin spike trians
            output.spikesByBin = generateBinnedSpikeTrains(output.spikesInTrial, output.uniqueNeurons, startTime, endTime, sampleRate);
        % generate adjacency matrix for neurons
            [output.adjacencyMatrices, output.matrixFigure] = makeAdjacencyMatrix(output.spikesByBin, output.uniqueNeurons, outputDirectory, sslash, trial);
        % run BCT on adjacency matrix
            output.graphMetrics = graphMetrics(output.adjacencyMatrices);
        % reorder adjacency matrix by consensus partition
            [output.reorderedAdjacencyMatrices, output.reorderdMatrixFigure] = reorderAdjacencyMatrix(output, outputDirectory, sslash, trial);
        % save output
            saveCorrOutput(output, outputDirectory, sslash);
            outputCollector = [outputCollector; output];
        end
        save([baseOutputDirectory sslash 'collectedCorrelationalOutput.mat'], 'outputCollector');
        disp('Correlational analysis complete.');
    % turn on figure generation
        set(0,'DefaultFigureVisible','on');
end