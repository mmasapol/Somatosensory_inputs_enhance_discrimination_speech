function dirs = vasDirs(project)
% function dirs = fsDirs(project)
%
% Setting the path to code, data in and out, and other toolboxes.
%
% INPUT:
% project:     string. Name of the project run.
%
% OUTPUT:
% dirs
% 
% Andres        :       v1      : init. 24 Jan 2017

if nargin == 0, project = 'Dissociating-Role-of-Feedback-in-Voice-Motor-Control'; end

%% Determine hostname of system 
[~,host] = system('hostname');
host     = deblank(host);

%% Set appropriate directories for code, data input and output, based on system hostname.
switch host
    case 'SAR-D-635-1528'
        % RecData must be moved to SavData for backup and local disk space consolidation
        dirs.RecData        = fullfile('C:\DATA', project);        % Dir to save raw Data to
        dirs.SavData        = fullfile('W:\Experiments', project); % Dir to open raw Data from
      
        dirs.Code           = fullfile('C:\Users\djsmith\Documents\MATLAB', project);             % The full code base
        dirs.Presentation   = fullfile(dirs.Code, 'Presentation');        % The scripts required for presentation
        dirs.Analysis       = fullfile(dirs.Code, 'Analysis');            % Dir w/ Code for data analysis
        dirs.tokenDir       = fullfile(dirs.Code, 'tokenFolder');
        
        dirs.Results        = fullfile('C:\Users\djsmith\Documents\Results', project); % Dir to output analyzed datafiles and figures to
        dirs.helpers        = fullfile(dirs.Code, 'helper');  % Dir to multiple function used for general analysis
        
        dirs.RecFileDir     = '';
        dirs.RecWaveDir     = '';
        dirs.SavFileDir     = '';
        dirs.SavResultsDir  = '';

        dirs.saveFileSuffix = '';
    case '677-GUE-WL-0002'
        % RecData must be moved to SavData for backup and local disk space consolidation
        dirs.RecData        = fullfile('C:\DATA', project);        % Dir to save raw Data to
        dirs.SavData        = fullfile('W:\Experiments', project); % Dir to open raw Data from
      
        dirs.Code           = fullfile('C:\Users\splab\Documents\MATLAB', project);             % The full code base
        dirs.Presentation   = fullfile(dirs.Code, 'Presentation');        % The scripts required for presentation
        dirs.Analysis       = fullfile(dirs.Code, 'Analysis');            % Dir w/ Code for data analysis
        dirs.tokenDir       = fullfile(dirs.Code, 'tokenFolder');
        
        dirs.Results        = fullfile('C:\Users\splab\Documents\Results', project); % Dir to output analyzed datafiles and figures to
        dirs.helpers        = fullfile(dirs.Code, 'helper');  % Dir to multiple function used for general analysis
        
        dirs.RecFileDir     = '';
        dirs.RecWaveDir     = '';
        dirs.SavFileDir     = '';
        dirs.SavResultsDir  = '';

        dirs.saveFileSuffix = '';
    case 'DanteRig'
        % RecData must be moved to SavData for backup and local disk space consolidation
        dirs.RecData        = fullfile('E:\Documents\DATA', project); % Dir to save raw Data to
        dirs.SavData        = fullfile('W:\Experiments\', project);   % Dir to open raw Data from
        
        dirs.Code           = fullfile('E:\Documents\MATLAB', project);
        dirs.Presentation   = fullfile(dirs.Code, 'Presentation');        % The scripts required for presentation
        dirs.Analysis       = fullfile(dirs.Code, 'Analysis');            % Dir w/ Code for data analysis
        dirs.tokenDir       = fullfile(dirs.Code, 'tokenFolder');
        
        dirs.Results        = 'E:\Documents\MATLAB\dfResults\Results'; % Dir to output analyzed datafiles and figures to
        dirs.helpers        = 'E:\Documents\MATLAB\MATLAB-Toolboxes';  % Dir to multiple function used for general analysis
        
        dirs.RecFileDir     = '';
        dirs.RecWaveDir     = '';
        dirs.SavFileDir     = '';
        dirs.SavResultsDir  = '';
       
        dirs.saveFileSuffix = '';
    otherwise
        fprintf('\nERROR: Please set directories for this host\n')
        return
end

%% Set up path so code is accessible to Matlab
addpath(genpath(dirs.Code));        % Add dir w/ your code path
addpath(genpath(dirs.Results));     % Where to find and save results
addpath(genpath(dirs.helpers));     % Add dir w/ helpers code path
end