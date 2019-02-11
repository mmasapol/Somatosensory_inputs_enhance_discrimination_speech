function vasPoolJNDResults()
% vasPoolJNDResults compiles all of the individually analyzed subject run
% results and organizes them in a format that can be easily plotted, and
% saved to spreadsheets. If further stats are to be applied, this is also a
% good function to consider applying them too.
%
% This requires that you have setup and created a PooledConfig File. See
% the folder 'Analysis\PooledAnalysisConfigs' for the available config
% files. 
%
% This function is dependent on the following functions located in the repo
% -vasDirs
% -vasDrawJNDResults

close all
pA.project       = 'BU-SPLab-VAS'; 
pA.pAnalysis     = 'VAS_JND'; % Change this name to load different pooled data sets Ex: SfN2017, LarynxPos

dirs               = vasDirs(pA.project);
dirs.SavResultsDir = fullfile(dirs.Results, 'Pooled Analyses', pA.pAnalysis);        % The directory to save Files/Figures
dirs.PooledConfigF = fullfile(dirs.SavResultsDir, [pA.pAnalysis 'PooledConfig.mat']);% The Pooled Config File for this Pooled Analysis

% Can we find the Pooled Config File?
if exist(dirs.PooledConfigF, 'file') == 0
    fprintf('\nERROR: Pooled Config File %s does not exist! Please create it with a GenConfig Function\n', dirs.PooledConfigF)
    return
else
    % Load the configuration file. Should return a data structure 'cF'
    load(dirs.PooledConfigF)
end 

pA.participants  = cF.participants; % List of multiple participants.
pA.numPart       = length(pA.participants);
pA.runs          = cF.runs;         % All runs to consider 
pA.numRuns       = length(pA.runs);
pA.cond          = cF.cond;         % Conditions to test against
pA.numCond       = length(pA.cond); 
pA.condVar       = cF.condVar;      % Variable to test the condition
pA.testExt       = cF.testExt;

pA.pltNameMVi    = cell(pA.numPart, 1);
pA.pltNameMVm    = [pA.pAnalysis 'MeanSubj' pA.testExt];

% Load all saved results and order into a large data structure
allDataStr = []; % (numPart x numRuns)
for ii = 1:pA.numPart
    participant = pA.participants{ii};
    fprintf('Loading Runs for %s\n', participant)
    
    pA.pltNameMVi{ii} = [pA.pAnalysis participant pA.testExt];
    subjRes  = [];
    for jj = 1:pA.numRuns
        run              = pA.runs{jj};
        dirs.SavFileDir  = fullfile(dirs.Results, participant, 'JND');                      % Where results are saved
        dirs.SavFile     = fullfile(dirs.SavFileDir, [participant run 'ResultsVAS.mat']); % Run Results file to load

        if exist(dirs.SavFile, 'file') == 0
            error('ERROR: The Results file for Run %s does not exist yet\n', run)
        else   
            load(dirs.SavFile)
            % Returns a results struture of 'res'
        end
        
        subjRes = cat(2, subjRes, resJND);
    end
    allDataStr = cat(1, allDataStr, subjRes);
end

allSubjRes = initSortedStruct(pA.numCond, pA.numRuns);
allSubjRes.subject = 'Mean Participant Response';
allSubjRes.curSess = allSubjRes.subject;
allSubjRes.cond    = pA.cond;

for ii = 1:pA.numPart
    participant = pA.participants{ii};
    fprintf('Sorting task conditions for %s\n', participant)
    
    sortStruc         = initSortedStruct(pA.numCond, pA.numRuns);
    sortStruc.subject = ['Participant ' num2str(ii)]; % Pooled Analysis Name
    
    sortStruc.curSess = sortStruc.subject;
 
    for jj = 1:pA.numRuns
        curRes = allDataStr(ii, jj);

        sortStruc.studyID = curRes.participant; % Study ID
        sortStruc.gender  = curRes.gender;

        sortStruc  = combineCondTrials(pA, curRes, sortStruc);       
        allSubjRes = combineCondTrials(pA, curRes, allSubjRes);
        
        sortStruc.distProgression{jj}   = curRes.distProgression;
        sortStruc.trialsAtReversals{jj} = curRes.trialsAtReversals;
        sortStruc.distAtReversals{jj}   = curRes.distAtReversals;
        
        sortStruc.trialsAtCorrectOpt1{jj}   = curRes.trialsAtCorrectOpt1;
        sortStruc.distAtCorrectOpt1{jj}     = curRes.distAtCorrectOpt1;
        sortStruc.trialsAtIncorrectOpt1{jj} = curRes.trialsAtIncorrectOpt1;
        sortStruc.distAtIncorrectOpt1{jj}   = curRes.distAtIncorrectOpt1;
        sortStruc.trialsAtCorrectOpt2{jj}   = curRes.trialsAtCorrectOpt2;
        sortStruc.distAtCorrectOpt2{jj}     = curRes.distAtCorrectOpt2;
        sortStruc.trialsAtIncorrectOpt2{jj} = curRes.trialsAtIncorrectOpt2;
        sortStruc.distAtIncorrectOpt2{jj}   = curRes.distAtIncorrectOpt2;
    end
        
    sortStruc = meanCondTrials(sortStruc);
    sortStruc.pltName = pA.pltNameMVi{ii};
    
    pooledRunStr(ii)   = sortStruc;
    
    allSubjRes.expType    = sortStruc.expType;
    allSubjRes.gender{ii} = sortStruc.gender;
    
    % Save the structure for future grouped analysis
    dirs.SavResultsDirParti = fullfile(dirs.Results, participant, 'JND');
    dirs.SavResultsFile     = fullfile(dirs.SavResultsDirParti, [participant 'VASAcuityPooledResults.mat']);
    fprintf('\nSaving Pooled JND Results for %s\n', participant)
    save(dirs.SavResultsFile, 'sortStruc')

    % Draw 
    vasDrawJNDResults(sortStruc, dirs.SavResultsDirParti)
end

% Save the all participant variables that we care about in one big table
saveStatTable(dirs, pooledRunStr)
end

function sortStr = initSortedStruct(numCond, numRun)
% sortStr = initSortedStruct(numCond) initializes the structure that will
% store the pooled results for each subject, or group of subjects. It is
% created to have different sizes, based on the number of conditions that
% are being tested against. I think this should generalize to subconditions
% of conditions, or two condition crossing, but I have not tested that, and
% currently the above scripts only consider one condition to test against. 

% Basic info about the session, the recordings, the subjects
sortStr.expType = [];
sortStr.subject = [];
sortStr.gender  = [];
sortStr.curSess = [];
sortStr.studyID = [];
sortStr.runs    = [];

sortStr.tokenType = {};
sortStr.sessType  = {};
sortStr.pertType  = {};

sortStr.instructions = [];
sortStr.selectOpt    = [];

sortStr.reversalsReached = [];
sortStr.trialsCompleted  = [];
sortStr.timeElapsed      = [];

sortStr.distProgression = cell(numRun, 1);

sortStr.trialsAtReversals = cell(numRun, 1);
sortStr.distAtReversals   = cell(numRun, 1);

sortStr.trialsAtCorrectOpt1   = cell(numRun, 1);
sortStr.distAtCorrectOpt1     = cell(numRun, 1);
sortStr.trialsAtIncorrectOpt1 = cell(numRun, 1);
sortStr.distAtIncorrectOpt1   = cell(numRun, 1);
sortStr.trialsAtCorrectOpt2   = cell(numRun, 1);
sortStr.distAtCorrectOpt2     = cell(numRun, 1);
sortStr.trialsAtIncorrectOpt2 = cell(numRun, 1);
sortStr.distAtIncorrectOpt2   = cell(numRun, 1);

sortStr.JNDScores         = [];
sortStr.LastSetAccuracies = [];
sortStr.catchAccuracies   = [];

sortStr.obvSubj          = {};
sortStr.obvGender        = {};
end

function polRes = combineCondTrials(pA, curRes, polRes)

whichCondAr = strcmp(pA.cond, eval(pA.condVar));
wC          = find(whichCondAr == 1);            % Which Condition?

polRes.runs         = cat(1, polRes.runs, {curRes.run});

polRes.tokenType = cat(1, polRes.tokenType, curRes.tokenType);
polRes.sessType  = cat(1, polRes.sessType, curRes.sessType);
polRes.pertType  = cat(1, polRes.pertType, curRes.pertType);

polRes.instructions = curRes.instructions;
polRes.selectOpt    = curRes.selectOpt;

polRes.reversalsReached = cat(1, polRes.reversalsReached, curRes.reversalsReached);
polRes.trialsCompleted  = cat(1, polRes.trialsCompleted, curRes.trialsCompleted);
polRes.timeElapsed      = cat(1, polRes.timeElapsed, curRes.timeElapsed);

polRes.JNDScores         = cat(1, polRes.JNDScores, curRes.JNDScore);
polRes.LastSetAccuracies = cat(1, polRes.LastSetAccuracies, curRes.LastSetAccuracy);
polRes.catchAccuracies   = cat(1, polRes.catchAccuracies, curRes.catchAccuracy);

polRes.obvSubj         = cat(1, polRes.obvSubj, curRes.participant);
polRes.obvGender       = cat(1, polRes.obvGender, curRes.gender);
end

function sortStruc = meanCondTrials(sortStruc)
JNDScores  = sortStruc.JNDScores;
Accuracies = sortStruc.LastSetAccuracies;

numJNDScores   = length(JNDScores);

sortStruc.JNDScoreMean        = round(mean(JNDScores), 2);
sortStruc.JNDScoreSE          = std(JNDScores)/sqrt(numJNDScores);
sortStruc.lastSetAccuracyMean = round(mean(Accuracies), 1);
sortStruc.lastSetAccuracySE   = std(Accuracies)/sqrt(numJNDScores);
end

function saveStatTable(dirs, pooledRunStr)

stat.participants = {pooledRunStr.subject}';
stat.genders      = {pooledRunStr.gender}';
stat.JNDScoreMean = {pooledRunStr.JNDScoreMean}';
stat.JNDScoreSE   = {pooledRunStr.JNDScoreSE}';


% stat.lastSetAccuracyMean = {pooledRunStr.lastSetAccuracyMean}';
% stat.lastSetAccuracySE   = {pooledRunStr.lastSetAccuracySE}';

JNDStatTable = table(stat.participants,...
                     stat.genders,...
                     stat.JNDScoreMean,...
                     stat.JNDScoreSE,...
                     'VariableNames',...
                     {'Participant', 'gender', 'JNDScoreMean', 'JNDScoreSE'});

JNDTableCSV = fullfile(dirs.SavResultsDir, 'VAS_JNDStatTable.csv');
writetable(JNDStatTable, JNDTableCSV);
end