function [adjacencyMatrices, matrixFigure] = makeAdjacencyMatrix(spikesByBin, uniqueNeurons, output_directory, sslash, trial)
% makeAdjacencyMatrix generates an adjacency matrix given the spikes by bin
        disp('Generating & saving adjacency matrix.');
        N = numel(uniqueNeurons);
        C = zeros(N);
        C_sig = zeros(N);
        upd = textprogressbar(N);
        for i=1:N
            upd(i);
            for j=1:N
                if(i~=j)
                    [r,lags] = xcorr(spikesByBin(i,:),spikesByBin(j,:),500,'coeff');
                    if (r < 0)
                        r = 0;
                    end
                    [max_r, index] = max(r);
                    lag = lags(index);
                    C(i,j) = max_r;
                    % now get the significance of that max R
                    if (lag > 0)
                        [~,P] = corrcoef(spikesByBin(i,(lag+1):end),spikesByBin(j,1:(end-lag)));
                    elseif (lag < 0)
                        [~,P] = corrcoef(spikesByBin(i,1:(end+lag)),spikesByBin(j,(-lag+1):end));
                    elseif (lag == 0)
                        [~,P] = corrcoef(spikesByBin(i,:),spikesByBin(j,:));
                    end
                    if (P(1,2) < 0.05) % 95% confidence interval 
                        C_sig(i,j) = max_r;
                    end
                end
            end
        end
        h = heatmap(C_sig);
        ylabel('Clusters'); xlabel('Pearson R value');    
        title(['Pair-Wise Max-Cross Correlations; Trial #' trial]);
        saveas(h, [output_directory sslash 'adjacencyMatrix.fig']);
        saveas(h, [output_directory sslash 'adjacencyMatrix.jpg']);
        clf;
        matrixFigure = h;
        adjacencyMatrices.raw = C;
        adjacencyMatrices.thresholded = C_sig;
end