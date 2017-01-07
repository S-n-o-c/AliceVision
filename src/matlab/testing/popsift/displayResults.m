function [res_rep, res_corr, res_m_score, res_match] = displayResult( datasetName, doSave)

if (nargin == 1)
    doSave = 0;
end

displayAll = 1;

datasetPath = '/home/lilian/data/Features_Repeatability/vgg_oxford_feat_eval/root/';

load(sprintf('%s/infos.mat', datasetPath));

allAlgos= { 'openmvg-vlfeat', 'opencv', 'popsift','siftgpu','celebrandil' };
algoNames= { 'VLFeat', 'OpenCV', 'popSIFT', 'SiftGPU', 'Celebrandil' };

% datasetNames = {'bark','bikes','boat','graf','leuven','trees','ubc','wall'};

fig = loadFigureSettings(datasetName, doSave);

indA = listImages(1);

res_rep = zeros(length(allAlgos), length(listImages)-1);
res_corr = zeros(length(allAlgos), length(listImages)-1);

folderName = [ datasetPath datasetName ];

for iAlgo = 1:length(allAlgos)
    algoName = allAlgos{iAlgo};
    for iImage = 1:length(listImages)-1
        indB = iImage+1;
        
        load(sprintf('%s/%s/res-%d-%d.mat',folderName, algoName, indA, indB ));
        
        %v_overlap
        %v_repeatability
        %v_nb_corespondences
        %matching_score
        %nb_matches
        
        res_rep(iAlgo, iImage) = v_repeatability(5);
        res_corr(iAlgo, iImage) = v_nb_corespondences(5);
        res_m_score(iAlgo, iImage) = matching_score;
        res_match(iAlgo, iImage) = nb_matches;
    end
end

h = figure; hold on;
for iAlgo = 1:length(allAlgos)
    
    if displayAll
        subplot(2,2,1); hold on;
        plot(fig.xValues, res_rep(iAlgo,:), fig.style{iAlgo}, ...
            'LineWidth',fig.lWidth, 'MarkerEdgeColor','k','MarkerSize',fig.mSize);
        L = legend(algoNames);
        xlabel(fig.xLabel);
        ylabel(fig.yLabel1);
        set(L,'Interpreter','Latex');
        set(L,'FontSize',fig.lSize);
        ylim([0 100]);
        
        subplot(2,2,2); hold on;
        plot(fig.xValues, res_corr(iAlgo,:), fig.style{iAlgo}, ...
            'LineWidth',fig.lWidth, 'MarkerEdgeColor','k','MarkerSize',fig.mSize);
        L = legend(algoNames);
        xlabel(fig.xLabel);
        ylabel(fig.yLabel2);
        set(L,'Interpreter','Latex');
        set(L,'FontSize',fig.lSize);
        ylim([0 Inf]);
        
        subplot(2,2,3); hold on;
        plot(fig.xValues, res_m_score(iAlgo,:), fig.style{iAlgo}, ...
            'LineWidth',fig.lWidth, 'MarkerEdgeColor','k','MarkerSize',fig.mSize);
        L = legend(algoNames);
        xlabel(fig.xLabel);
        ylabel(fig.yLabel3);
        set(L,'Interpreter','Latex');
        set(L,'FontSize',fig.lSize);
        ylim([0 100]);
        
        subplot(2,2,4); hold on;
    end
    % otherwise display only the number of correct matches
    
    plot(fig.xValues, res_match(iAlgo,:), fig.style{iAlgo}, ...
        'LineWidth',fig.lWidth, 'MarkerEdgeColor','k','MarkerSize',fig.mSize);
    L = legend(algoNames);
    set(gca,'FontSize',fig.tSize);
    xlabel(fig.xLabel);
    ylabel(fig.yLabel4);
    set(L,'Interpreter','Latex');
    set(L,'FontSize',fig.lSize);
    ylim([0 Inf]);
end

if doSave
    saveas(h,sprintf('figure/%s.pdf', datasetName),'pdf');
end