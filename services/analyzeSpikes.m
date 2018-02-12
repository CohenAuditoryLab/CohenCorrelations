function output = analyzeSpikes(spikes, uniqueNeurons, sampleRate, startTime, endTime, outputDirectory, trial, sslash)
    % make a raster plot
        output.spikeRaster = makeSpikeRaster(spikes, uniqueNeurons, sampleRate, outputDirectory, sslash);   
    % bin spike trians
        output.spikesByBin = generateBinnedSpikeTrains(spikes, uniqueNeurons, startTime, endTime, sampleRate);
    % generate adjacency matrix for neurons
        [output.adjacencyMatrices, output.matrixFigure] = makeAdjacencyMatrix(output.spikesByBin, uniqueNeurons, outputDirectory, sslash, trial);
    % run BCT on adjacency matrix
        output.graphMetrics = graphMetrics(output.adjacencyMatrices);
    % reorder adjacency matrix by consensus partition
        [output.reorderedAdjacencyMatrices, output.reorderdMatrixFigure] = reorderAdjacencyMatrix(output, uniqueNeurons, outputDirectory, sslash, trial);
end