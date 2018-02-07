function [adjacencyMatrices, matrixFigure] = reorderAdjacencyMatrix(output, output_directory, sslash)
% makeAdjacencyMatrix generates an adjacency matrix given the spikes by bin
        disp('Reordering adjacency matrix according to modules.');
        N = numel(output.uniqueNeurons);
        C = output.adjacencyMatrices.raw;
        C_sig = output.adjacencyMatrices.thresholded;
        newC = zeros(N);
        newC_sig = zeros(N);
        modules = output.graphMetrics.modules;
        moduleNum = numel(modules);
        % concatenate the module numbers
        reorderedNeurons = modules(1);
        if (moduleNum > 1)
            for i=2:moduleNum
                reorderedNeurons = cellfun(@horzcat, reorderedNeurons, modules(i), 'UniformOutput',false);
            end
        end
        reorderedNeurons = cell2mat(reorderedNeurons);
        % loop through them
        upd = textprogressbar(N+1);
        for i=1:N
            upd(i);
            x = reorderedNeurons(i);
            for j=1:N
                if(i~=j)
                    % get the appropriate values from C and C_sig
                    y = reorderedNeurons(j);
                    newC(i,j) = C(x,y);
                    newC_sig(i,j) = C_sig(x,y);
                end
            end
        end
        h = heatmap(newC_sig);
        ylabel('Clusters'); xlabel('Pearson R value');    
        title('Pair-Wise Max-Cross Correlations; Jan 14 Block 3 Trial 12');
        saveas(h, [output_directory sslash 'reorderedAdjacencyMatrix.fig']);
        saveas(h, [output_directory sslash 'reorderedAdjacencyMatrix.jpg']);
        clf;
        matrixFigure = h;
        adjacencyMatrices.raw = newC;
        adjacencyMatrices.thresholded = newC_sig;
        upd(N+1);
end