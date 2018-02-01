function graphMetrics = graphMetrics(adjacencyMatrix)
% out generates connectivity metrics from BCT based on an
%   adjacency matrix
    disp('Running graph metrics from Brain Connectivity Toolbox.');
    % density
        [out.density,out.vertices,out.edges] = density_und(adjacencyMatrix);
    % degree & strength
        out.degree_distribution = (degrees_und(adjacencyMatrix))';
        out.degree_avg = mean(out.degree_distribution); 
        out.strength_distribution = (strengths_und(adjacencyMatrix))';
        out.strength_avg = mean(out.strength_distribution);
    %clustering coefficient
        out.clustering_coeff_distribution = clustering_coef_wu(adjacencyMatrix);
        out.clustering_coeff_avg = mean(out.clustering_coeff_distribution);
    %char path, efficiency
        length_mat = weight_conversion(adjacencyMatrix,'lengths');
        dist_mat = distance_wei(length_mat);
        [out.characteristic_path,out.global_efficiency,out.eccentricities,out.radius,out.diameter] = charpath(dist_mat, true, false);
    % modularity
        out.community = [];
        for j=1:100
            % modularity
            [out.community(j).Ci, out.community(j).Q] = community_louvain(adjacencyMatrix);
            % community number
            out.community(j).comm_number = numel(unique(out.community(j).Ci));
            % participation coefficient
            out.community(j).part_coeff_avg = participation_coef(adjacencyMatrix, out.community(j).Ci);
            % within-module degree z score
            out.community(j).win_mod_degree_z = module_degree_zscore(adjacencyMatrix, out.community(j).Ci);
        end
        out.community_Q_avg = mean([out.community(j).Q]);
        out.comm_num_avg = mean([out.community(j).comm_number]);
        out.comm_consensus_partition = consensus_und(agreement(horzcat(out.community.Ci))/100,.5,10);
        out.part_coeff_avg = mean(vertcat(out.community.part_coeff_avg));
        out.win_mod_degree_z_avg = mean(vertcat(out.community.win_mod_degree_z));
        graphMetrics = out;
end