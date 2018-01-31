function output = CohenCorr2(spikesData, taskData, startTime, endTime, sampleRate)
%CohenCorr2 Returns correlation structure for specified snippet of spikes
%   INPUTS:
    %   spikesData: path to spikes
    %   taskData: path to task data
    %   startTime: the start of the 
%   OUTPUTS:
    %   output.spikesInTrial
    %   output.uniqueNeurons
    %   output.spikeRaster
    %   output.spikesByBin
    
    % load libraries
        addpath(genpath('libraries'));
        addpath(genpath('services'));
    % initialize variables
        projectFolder = pwd;
        initializeVariables;
    % turn off figure generation
        set(0,'DefaultFigureVisible','off');
    % extract specified times
        output.spikesInTrial = spikesData(find(spikesData(:,2)>startTime & spikesData(:,2)< endTime),:);
    % get unique neurons, sort them
        output.uniqueNeurons = unique(output.spikesInTrial(:,1));
    % make a raster plot
        output.spikeRaster = makeSpikeRaster(output.spikesInTrial, output.uniqueNeurons, sampleRate, output_directory, sslash);   
    % bin spike trians
        output.spikesByBin = generateBinnedSpikeTrains(output.spikesInTrial, output.uniqueNeurons, startTime, endTime, sampleRate);
    % generate adjacency matrix for neurons
        [output.adjacencyMatrix, output.matrixFigure] = makeAdjacencyMatrix(output.spikesByBin, output.uniqueNeurons, output_directory, sslash);
    % run BCT on adjacency matrix
    save([output_directory sslash 'correlational_output.mat'], 'output');
    %wrap up
    set(0,'DefaultFigureVisible','on');
end