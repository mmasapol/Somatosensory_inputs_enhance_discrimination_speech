function vasAnalysisJND()
% vasAnalysisJND() loads a formant JND data set (FA#VAS.mat) and analyzed the raw
% data into interpretable results. Multiple JND results can be
% analyzed and plotted at the same time. By following the saved file
% structure of FA1, FA2,... etc, you can select the run numbers to
% analyze and view the run results next to each other in the plots.
%
% This function calls the following external functions
% -vasDirs
% -vasAnalyzeThresholdJND
%
% This script has the following subfunctions:
% -initJNDAnalysis()
% -AnalyzeRawJNDData()
tic
close all

% Initalize the analysis structure
JNDa.project      = 'BU-SPLab-VAS';
JNDa.participants = {'VSP103'}; % List of multiple participants.
JNDa.numPart      = length(JNDa.participants);
JNDa.runs         = {'FA1','FA2','FA3','FA4','FA5','FA6','FA7','FA8'}; %List of multiple runs.
JNDa.numRuns      = length(JNDa.runs);

dirs = vasDirs(JNDa.project);

for jj = 1:JNDa.numPart
    curPart = JNDa.participants{jj}; % Current Participant
    dirs.SavResultsDir = fullfile(dirs.Results, curPart, 'JND'); %Where to save results

    if exist(dirs.SavResultsDir, 'dir') == 0
        mkdir(dirs.SavResultsDir) %If the folder we are saving does not exist, let's make it
    end

    for ii = 1:JNDa.numRuns
        curRun     = JNDa.runs{ii}; % Current Run
        dirs.SavFileDir = fullfile(dirs.RecData, curPart, curRun, [curPart curRun 'VAS.mat']); %Where to find raw data

        fprintf('****%s  %s****\n', curPart, curRun)
        fprintf('Loading Raw JND Data\n')
        load(dirs.SavFileDir) % Returns UD

        % Organize the raw data into a result structure named 'resJND'
        resJND = AnalyzeRawJNDData(UD);
        dirs.SavResultsFile = fullfile(dirs.SavResultsDir, [curPart curRun 'ResultsVAS.mat']); %What to name the organized results
        fprintf('Saving Individual JND Results\n\n')
        save(dirs.SavResultsFile, 'resJND') %
    end
end
fprintf('Elapsed time was %f min\n', toc/60)
end

function resJND = initJNDAnalysis()

resJND.participant = [];
resJND.gender      = [];
resJND.run         = [];

resJND.tokenType = [];
resJND.sessType  = [];
resJND.pertType  = [];

resJND.instructions     = {};
resJND.selectOpt        = {};

resJND.reversalsReached = [];
resJND.trialsCompleted  = [];
resJND.timeElapsed      = [];

resJND.distProgression = [];

resJND.trialsAtReversals = [];
resJND.distAtReversals   = [];

resJND.trialsAtCorrectOpt1   = [];
resJND.distAtCorrectOpt1     = [];
resJND.trialsAtIncorrectOpt1 = [];
resJND.distAtIncorrectOpt1   = [];
resJND.trialsAtCorrectOpt2   = [];
resJND.distAtCorrectOpt2     = [];
resJND.trialsAtIncorrectOpt2 = [];
resJND.distAtIncorrectOpt2   = [];

resJND.JNDScore        = [];
resJND.LastSetAccuracy = [];
resJND.catchAccuracy   = [];
end

function resJND = AnalyzeRawJNDData(UD)
% This calls the following subfunctions
% -initJNDAnalysis()
% -vasAnalyseThresholdJND()

fprintf('Starting Individual JND Analysis\n')

resJND = initJNDAnalysis();

resJND.participant = UD.subject;
resJND.gender      = UD.gender;
resJND.run         = UD.run;

resJND.tokenType   = UD.tokenFile;
resJND.sessType    = UD.sessType;
resJND.pertType    = UD.pertType;

resJND.instructions = UD.inst;    
resJND.selectOpt    = UD.selectOpt;

resJND.reversalsReached = UD.reversals;
resJND.trialsCompleted  = UD.performedTrials;
resJND.timeElapsed      = UD.elapsedTime;

resJND.distProgression = UD.x;

resJND.trialsAtReversals = find(UD.reversal~=0);
resJND.distAtReversals   = UD.x(resJND.trialsAtReversals);

resJND.trialsAtCorrectOpt1   = find(UD.allTrialTypes == 1);
resJND.trialsAtIncorrectOpt1 = find(UD.allTrialTypes == 2);
resJND.trialsAtCorrectOpt2   = find(UD.allTrialTypes == 3);
resJND.trialsAtIncorrectOpt2 = find(UD.allTrialTypes == 4);

resJND.distAtCorrectOpt1   = UD.x(resJND.trialsAtCorrectOpt1)';
resJND.distAtIncorrectOpt1 = UD.x(resJND.trialsAtIncorrectOpt1)';
resJND.distAtCorrectOpt2   = UD.x(resJND.trialsAtCorrectOpt2)';
resJND.distAtIncorrectOpt2 = UD.x(resJND.trialsAtIncorrectOpt2)';

% Determine the JND Score and Accuracy of the last set of trials
[JNDScore, LastSetAccuracy] = vasAnalyzeThresholdJND(UD, 'reversals', 4);
resJND.JNDScore        = JNDScore;
resJND.LastSetAccuracy = round(LastSetAccuracy, 1);
resJND.catchAccuracy   = round(0); %Currently N/A, but maybe used again later
end