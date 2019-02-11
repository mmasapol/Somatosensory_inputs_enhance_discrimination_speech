function pertTokens = vasGeneratePT(dirs, GT)

helperFolder = dirs.helper;
tokenDir     = dirs.tokenDir;
numTokens    = GT.numTokens;
tokenSpread  = GT.tokenSpread;
tokenLenP    = GT.tokenLenP;

gender       = GT.gender;
if strcmp(gender, 'male')
    MaxFormant = 5000;
else
    MaxFormant = 5500;
end

F1Steps = GT.F1Steps;
F2Steps = GT.F2Steps;

pbDir         = fullfile(helperFolder, 'praatBatching'); % Praat batching

tokenDir = [tokenDir, '\']; % add a slash to the mic folder
ext      = '.wav';          % File extension

p_fn = fullfile(pbDir, 'praat.exe');
if ~exist(p_fn, 'file')
    error('file ''praat.exe'' not found')
end

sp_fn = fullfile(pbDir, 'sendpraat.exe');
if ~exist(sp_fn, 'file')
    error('file ''sendpraat.exe'' not found')
end

gt_fn = fullfile(pbDir, 'batchshiftFormants.praat');
if ~exist(gt_fn, 'file')
    error('file ''batchshiftFormants.praat'' not found')
end

pertTokens = zeros(numTokens, tokenLenP);
for ii = 1:numTokens    

    targetPertName = ['token' num2str(tokenSpread(ii))];
    targetF1Pert   = round(F1Steps(ii),1);
    targetF2Pert   = round(F2Steps(ii),1);
    
    call2 = sprintf('%s praat "execute %s %s %s %s %d %d %d %f %f"', ...
                    sp_fn, ... %sendpraat.exe
                    gt_fn, ... %saved praat script ('generatef0JNDTokens)
                    tokenDir, ...   % file location for saved wav files
                    ext, ...        % file extension
                    targetPertName, ...
                    targetF1Pert, ... % Target Frequency Shift
                    targetF2Pert, ...
                    MaxFormant, ... 
                    ii, ...         % Current token being created
                    numTokens ...   % Total number of tokens
                    );
                
    [s, r] = dos(call2);
    if s ~= 0
        dos([p_fn ' &']);
        [s, r] = dos(call2);
        if s ~= 0
            disp(r)
            error('ERROR: something went wrong')
        end
    end
    
    thisTokenfile     = fullfile(tokenDir, [targetPertName '.wav']);
    [thisToken, ~]    = audioread(thisTokenfile);
    pertTokens(ii, :) = thisToken;
end
end