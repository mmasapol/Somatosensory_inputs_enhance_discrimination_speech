function vasCreateJNDTokens()
% vasCreateJNDTokens() generates both a baseline token and
% pitch-shifted tokens for JND type pitch perception tasks. This loads a
% baseline voice recording made earlier, and saves both .wav files and a
% single MATLAB data structure containing the sound tokens needed for a JND
% task.
%
% This script is dependent on the following external functions:
% -dfDirs.m
% -dfGenerateBT.m
% -dfcalcf0PraatSingle.m
% -dfGeneratePT.m
%
% This script has the following subfunctions:
% -calcShiftedf0

close all;

GT.gender   = 'male'; % Of the representative speaker
GT.tokenSet = 'GT1';

dirs.Code          = 'C:\Users\djsmith\Documents\MATLAB\BU-SPLab-VAS\';
dirs.helper        = fullfile(dirs.Code, 'helper');
dirs.tokenDir      = fullfile(dirs.Code, 'tokenFolder', GT.tokenSet);
dirs.baseTokenDir  = fullfile(dirs.Code, 'speechSamples');
dirs.baseTokenFile = fullfile(dirs.tokenDir, [GT.tokenSet 'BaseToken.wav']);

if ~exist(dirs.tokenDir, 'dir')
    mkdir(dirs.tokenDir);
end

% Where to find the baseline recordings
dirs.aeVowelFile = fullfile(dirs.baseTokenDir, 'Dante_AE.wav');
dirs.eVowelFile  = fullfile(dirs.baseTokenDir, 'Dante_E.wav');

[GT.F1ae, GT.F2ae] = vasCalcFormantsPraat(dirs, dirs.aeVowelFile);
[GT.F1e, GT.F2e]   = vasCalcFormantsPraat(dirs, dirs.eVowelFile);

GT.LBk = (GT.F2ae - GT.F2e)/(GT.F1ae - GT.F1e);
GT.LBb = GT.F2ae - GT.LBk*GT.F1ae;

GT.tokenSpread = -50:50;
GT.numTokens   = length(GT.tokenSpread);
GT.F1Steps     = linspace(GT.F1ae, GT.F1e, GT.numTokens);
GT.F2Steps     = GT.LBk*GT.F1Steps + GT.LBb;

% figure
% plot([GT.F1e GT.F1ae], [GT.F2e GT.F2ae])

[aeVowelRec, ~] = audioread(dirs.aeVowelFile);
[eVowelRec, fs] = audioread(dirs.eVowelFile);

GT.vowel1 = aeVowelRec;
GT.vowel2 = eVowelRec;

GT.fs            = fs;                % sampling rate to play tokens at
GT.tokenLen      = 0.5;               % seconds
GT.tokenLenP     = GT.fs*GT.tokenLen+1;

% Generate audio tokens
GT.BaseToken  = vasGenerateBT(dirs, GT, 1); % Extract a Speech Token.
GT.PertTokens = vasGeneratePT(dirs, GT); % Generate Pert Tokens using praat. 

fprintf('Completed creating tokens\n')
GTFile = fullfile(dirs.tokenDir, [GT.tokenSet 'vas.mat']);
save(GTFile, 'GT');
end

function BT = vasGenerateBT(dirs, GT, flag)
% dfGenerateBT loads a baseline voice recording and creates a baseline 
% voice token to be used by a JND experiment.
%
% INPUTS:
% dirs:      Struc containing where the baseline voice is located and where
%            we should save the baseline token.
% GT:        Structure of variables related to generating speech tokens.
% varargin:  Flag to turn on/off automated baseline voice file sectioning.
%            1(default) is automated. 0 is manual.
%
% OUTPUTS:
% BT:        Baseline token signal

if flag == 1
    baseRec = GT.vowel1; 
else
    baseRec = GT.vowel2;
end

auto      = 1;
fs        = GT.fs;         % The sampling rate we want the tokens played at.
tokenLenP = GT.tokenLenP;

recLen  = length(baseRec);     % points
recDur  = recLen/fs;           % seconds
time    = linspace(0, recDur, recLen); % used for manual plotting

riseTime    = .05;            % seconds
fallTime    = .05;            % seconds
riseTimeP   = riseTime*fs;    % points
fallTimeP   = fallTime*fs;    % points
riseQperiod = (4*riseTime)^-1;
fallQperiod = (4*fallTime)^-1;

window = ones(1, tokenLenP);
window(1:riseTimeP) = sin(2*pi*riseQperiod*linspace(0, riseTime, riseTimeP)).^2;
window(tokenLenP-fallTimeP + 1:tokenLenP) = cos(2*pi*fallQperiod*linspace(0, fallTime, fallTimeP)).^2;

if auto == 1 % Automatic sectioning
    ix1 = 1;
    ix2 = ix1 + tokenLenP - 1;
else         % Manual sectioning
    figure
    plot(time, baseRec, 'b'); ylim([-1 1])
    
    [x, ~] = ginput(1);
    ix1 = round(x(1)*fs); % Choose a single point with roughly .5s following it
    ix2 = ix1 + tokenLenP - 1;
    close all
end

BTraw = baseRec(ix1:ix2);         % raw baseline token (BT)
BT    = BTraw.*window';           % windowed 

audiowrite(dirs.baseTokenFile, BT, fs) % saved to tokens folder 
end