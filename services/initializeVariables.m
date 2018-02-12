% handle slashes
if(ispc)
    sslash = '\';
else
    sslash = '/';
end
% load spikesData
if exist('spikesData', 'var') == 0
    spikesData = load([projectFolder sslash 'sampleData' sslash 'spikes' sslash 'jan14_18_AL.mat']);
    spikesData = spikesData.standard_output;
else 
    spikesData = load(spikesData);
end
% load taskData
if exist('taskData', 'var') == 0
    taskData = load([projectFolder sslash 'sampleData' sslash 'tasks' sslash 'jan14_18.mat']);
    taskData = taskData.meta;
else 
    taskData = load(taskData);
end
% get sounds
sounds = taskData.sound;
% set sampleRate
if exist('sampleRate', 'var') == 0
    sampleRate = 24410;
end
% set startTime
if exist('startTime', 'var') == 0
    startTime = 3849918;
end
% set endTime
if exist('endTime', 'var') == 0
    endTime = 4099117;
end
% output directory
baseOutputDirectory = [projectFolder sslash 'output' sslash datestr(now,'yyyy_mm_dd__HH_MM_SS')];
mkdir(baseOutputDirectory);
% unique neurons
uniqueNeurons = unique(spikesData(:,1));
%get avg sound time
avgSoundTime = mean((sounds(:,2) - sounds(:,1)));