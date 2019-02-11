function [F1, F2] = vasCalcFormantsPraat(dirs, file)
%Calculation of pitch using Praat for a single saved wav file.

helperFolder  = dirs.helper;
tokenDir      = dirs.tokenDir;
wavFileLoc    = file;
txtFileLoc    = [tokenDir, '\formantCalc.txt'];

pbDir         = fullfile(helperFolder, 'praatBatching'); % Praat batching

p_fn = fullfile(pbDir, 'praat.exe');
if ~exist(p_fn, 'file')
    error('file ''praat.exe'' not found')
end

sp_fn = fullfile(pbDir, 'sendpraat.exe');
if ~exist(sp_fn, 'file')
    error('file ''sendpraat.exe'' not found')
end

gt_fn = fullfile(pbDir, 'batchcalcFormants.praat');
if ~exist(gt_fn, 'file')
    error('file ''batchcalcf0.praat'' not found')
end
 
call2 = sprintf('%s praat "execute %s %s %s', ...
                    sp_fn, ... %sendpraat.exe
                    gt_fn, ... %saved praat script ('generatef0JNDTokens)
                    wavFileLoc, ... %file location for saved wav files
                    txtFileLoc);
                
[s, r] = dos(call2);
if s ~= 0
    dos([p_fn ' &']);
    [s, r] = dos(call2);
    if s ~= 0
        disp(r)
        error('ERROR: something went wrong')
    end
end

praatResult = fopen(txtFileLoc);
praatScan   = textscan(praatResult, '%f %s %s');
fclose(praatResult);
delete(txtFileLoc);

[F1, F2] = averagePraatFormant(praatScan);
end

function [meanF1, meanF2] = averagePraatFormant(praatScan)
%Expects the table is 2 columns, and the f0 values are in column 2

praatf0idx = ~strncmp('--undefined--', praatScan{1,2},3);
praatF1freq = str2double(praatScan{1,2}(praatf0idx));
praatF2freq = str2double(praatScan{1,3}(praatf0idx));
meanF1 = mean(praatF1freq);
meanF2 = mean(praatF2freq);
end