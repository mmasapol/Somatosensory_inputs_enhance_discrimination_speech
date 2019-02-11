function vasDrawJNDResults(res, saveResultsDir)
% drawJNDResults() displays the results from a single subject's JND runs.
%
% This function calls the following helper functions
% -tight_subplot
% -export_fig

participant = res.studyID;
numRuns     = length(res.runs);

JNDScoreM = res.JNDScoreMean;

selectOpt = res.selectOpt;

plotpos = [50 150];
plotdim = [1600 750];
xyFS    = 12;
titleFS = 12;

tColors = [[0 0 1];      % Correct Different
           [1 0 0];      % Incorrect Different
           [0.5 0.5 1];  % Correct Same
           [1 0.5 0.5]]; % Incorrect Same

numRows = 2;
numCols = numRuns/numRows;
annoPos = [.095 .785;
           .340 .785;
           .585 .785;
           .830 .785;
           .095 .315;
           .340 .315;
           .585 .315;
           .830 .315]; 
       
aH = [0 0 0 0 0];

AllJND = figure('Color', [1 1 1]);
set(AllJND, 'Position',[plotpos plotdim],'PaperPositionMode','auto')

ha = tight_subplot(numRows, numCols, [0.15 0.04], [0.1 0.1], [0.04 0.02]);

for ii = 1:numRuns
    % Set up some specifics of this recording
    curRun    = res.runs{ii};
    trlsComp  = res.trialsCompleted(ii);
    JNDScore  = res.JNDScores(ii);
    catchAccu = res.LastSetAccuracies(ii);
    
    tokenType = res.tokenType{ii};
    sessType  = res.sessType{ii};
    pertType  = res.pertType{ii};
    
    distProg = res.distProgression{ii};
    revTrl   = res.trialsAtReversals{ii};
    revDst   = res.distAtReversals{ii};    
    opt1CTrl = res.trialsAtCorrectOpt1{ii};
    opt1CDst = res.distAtCorrectOpt1{ii};
    opt1ITrl = res.trialsAtIncorrectOpt1{ii};
    opt1IDst = res.distAtIncorrectOpt1{ii};
    opt2CTrl = res.trialsAtCorrectOpt2{ii};
    opt2CDst = res.distAtCorrectOpt2{ii};
    opt2ITrl = res.trialsAtIncorrectOpt2{ii};
    opt2IDst = res.distAtIncorrectOpt2{ii};
    
    scoreNote = ['JND Score: ' num2str(JNDScore) ' steps'];
    accurNote = ['Last Trials Accuracy: ' num2str(catchAccu) '%'];
    
    axes(ha(ii))
    rV = plot(revTrl, revDst,'o','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'MarkerSize',12);
    hold on;
    plot(distProg, 'Color', [0.7 0.7 0.7], 'LineWidth', 3);
    
    c1 = plot(opt1CTrl, opt1CDst,'o','MarkerFaceColor',tColors(1,:),'MarkerEdgeColor',tColors(1,:),'MarkerSize',10);
    i1 = plot(opt1ITrl, opt1IDst,'o','MarkerFaceColor',tColors(2,:),'MarkerEdgeColor',tColors(2,:),'MarkerSize',10);
    c2 = plot(opt2CTrl, opt2CDst,'o','MarkerFaceColor',tColors(3,:),'MarkerEdgeColor',tColors(3,:),'MarkerSize',10);
    i2 = plot(opt2ITrl, opt2IDst,'o','MarkerFaceColor',tColors(4,:),'MarkerEdgeColor',tColors(4,:),'MarkerSize',10);
       
    jS = line([0 trlsComp], [JNDScore JNDScore],'LineStyle', '-.', 'LineWidth',3,'color',[1 0 1]);
    fullTitle = [curRun ': ' tokenType ', ' sessType];
    title(fullTitle, 'FontSize', titleFS, 'FontName', 'Arial', 'FontWeight', 'bold')
    xlabel('Trials','FontSize', xyFS,'FontName','Arial', 'FontWeight', 'bold');
    ylabel('Formant Distance (steps)','FontSize', xyFS,'FontName','Arial', 'FontWeight', 'bold');
    axis([0 50 0 80])
    
    t = annotation('textbox',[annoPos(ii,1) annoPos(ii,2) 0.15 0.1],...
                   'string', {scoreNote; accurNote},...
                   'HorizontalAlignment', 'right',...
                   'EdgeColor', 'none',...
                    'FontWeight','bold',...
                    'FontSize',12,...
                    'FontName','Arial');
    
    set(gca, 'LineWidth', 2,...
             'FontSize', 12,...
             'FontName', 'Arial',...
             'FontWeight', 'bold')
    
    if ~isempty(c1)
       aH(1) = c1;
    end
    if ~isempty(i1)
       aH(2) = i1;
    end
    if ~isempty(rV)
       aH(3) = rV;
    end
    if ~isempty(c2)
       aH(4) = c2;
    end
    if ~isempty(i2)
       aH(5) = i2;
    end  
end

suptitle({participant, 'Formant Acuity JND'})

legend(aH,{['Correct ' selectOpt{1}],['Incorrect ' selectOpt{1}],'Reversals',['Correct ' selectOpt{2}],['Incorrect ' selectOpt{2}]},...
          'Orientation','Horizontal',...
          'FontSize', 9,...
          'Position', [0.51 0.455 0.02 0.05],...
          'EdgeColor', [0.5 0.5 0.5])

plTitle = [participant 'VASAcuityPooledResults.jpg'];
saveFileName = fullfile(saveResultsDir, plTitle);
export_fig(saveFileName) 
end