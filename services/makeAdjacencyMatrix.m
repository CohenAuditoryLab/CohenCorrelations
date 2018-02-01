function [adjacencyMatrix, matrixFigure] = makeAdjacencyMatrix(spikesByBin, uniqueNeurons, output_directory, sslash)
% makeAdjacencyMatrix generates an adjacency matrix given the spikes by bin
        disp('Generating & saving adjacency matrix.');
        N = numel(uniqueNeurons);
        C = zeros(N);
        upd = textprogressbar(N);
        for i=1:N
            upd(i);
            for j=1:N
                if(i~=j)
                    r = xcorr(spikesByBin(i,:),spikesByBin(j,:),500,'coeff');
                    if (r < 0)
                        r = 0;
                    end
                    C(i,j) = max(r);
                end
            end
        end
        h = heatmap(C);
        ylabel('Clusters'); xlabel('Pearson R value');    
        title('Pair-Wise Max-Cross Correlations; Jan 14 Block 3 Trial 12');
        saveas(h, [output_directory sslash 'adjacencyMatrix.fig']);
        saveas(h, [output_directory sslash 'adjacencyMatrix.jpg']);
        clf;
        matrixFigure = h;
        adjacencyMatrix = C;
end