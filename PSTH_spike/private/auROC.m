function [FPR, TPR, AUC] = auROC(cluster1, cluster2)
if size(cluster1,2) == size(cluster2,2)
    if size(cluster1,2) ==1
        [FPR, TPR, AUC] = auROC_one(cluster1, cluster2);
    else
        points = size(cluster1,2);
        FPR = cell(1,points);
        TPR = cell(1,points);
        AUC = cell(1,points);
        for i=1:1:points
            [FPR{i},TPR{i},AUC{i}] = auROC_one(cluster1(:,i),cluster2(:,i));
        end
    end
end


function [FPR, TPR, AUC] = auROC_one(cluster1, cluster2)
x = min([min(cluster1), min(cluster2)])-1:0.1:max([max(cluster1), max(cluster2)])+1;
c1d = hist(cluster1,x);
c2d = hist(cluster2,x);
c1Num = size(cluster1,1);
c2Num = size(cluster2,1);
normCumC1d = cumsum(c1d)/c1Num;
normCumC2d = cumsum(c2d)/c2Num;
FPR = 1 - normCumC1d;
TPR = 1- normCumC2d;
AUC = abs(trapz(FPR,TPR));
% plot(FPR,TPR,'LineWidth',3);
% xlabel('False Positive Rate','FontName','Arial','FontSize',25,'FontWeight','Bold');
% ylabel('True Positive Rate','FontName','Arial','FontSize',25,'FontWeight','Bold');
% set(gca,'xlim',[0 1],'ylim',[0 1],'LineWidth',3,'FontName','Arial','FontSize',20,'TickDir','out');