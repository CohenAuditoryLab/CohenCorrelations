function saveCorrOutput = saveCorrOutput(output, output_directory, sslash)
% saveCorrOutput saves output as .mat and graph metrics as .csv files
    % trial
    graphOutputToSave = output.trial.graphMetrics;
    graphOutputToSave = rmfield(graphOutputToSave, 'community');
    struct2csv(graphOutputToSave,[output_directory sslash 'graphMetrics_trial.csv'])
    % pretrial
    graphOutputToSave = output.preTrial.graphMetrics;
    graphOutputToSave = rmfield(graphOutputToSave, 'community');
    struct2csv(graphOutputToSave,[output_directory sslash 'graphMetrics_preTrial.csv'])
    save([output_directory sslash 'correlational_output.mat'], 'output');
end