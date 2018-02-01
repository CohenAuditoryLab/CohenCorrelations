function saveCorrOutput = saveCorrOutput(output, output_directory, sslash)
% saveCorrOutput saves output as .mat and graph metrics as .csv files
    graphOutputToSave = output.graphMetrics;
    graphOutputToSave = rmfield(graphOutputToSave, 'community');
    struct2csv(graphOutputToSave,[output_directory sslash 'graphMetrics.csv'])
    save([output_directory sslash 'correlational_output.mat'], 'output');
end