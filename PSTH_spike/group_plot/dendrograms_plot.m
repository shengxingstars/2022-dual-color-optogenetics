function [leafOrder,T,outperm] = dendrograms_plot(inputArg1);
%DENDROGRAMS_PLOT 此处显示有关此函数的摘要
%   此处显示详细说明
%%20210930 llh
% Hierarchical clustering was carried out in three steps. We first
% reduced the dimensionality of Z-scored firing activity via principle component
% analysis. The first three major principle components were then used to calculate
% Euclidean distance metric. The complete agglomeration method was finally applied
% to build the hierarchy of clusters and plot dendrograms in MATLAB.
%ref, Li et al. Nature communications 2021

[coeff,score,latent] = pca(inputArg1','NumComponents',3);
D = pdist(coeff);
tree = linkage(coeff,'complete');

leafOrder = optimalleaforder(tree,D);
Tc = cluster(tree,'maxclust',3);

figure
set(gcf,'Position',[150,50,500,600]);
% [H,T,outperm] = dendrogram(tree,'Orientation','right','ColorThreshold','default','Reorder',leafOrder);
[H,T,outperm] = dendrogram(tree,'Orientation','right','ColorThreshold','default');
% dendrogram(tree,'Reorder',leafOrder)
set(H,'LineWidth',2)

leafOrder = leafOrder';
leafOrder2 = [];
for i=1:length(outperm)
    leafOrder2 = [leafOrder2;find(T==outperm(i))];
end
leafOrder = leafOrder2;

figure
imagesc(coeff(leafOrder,:));hold on;

figure
score = coeff;
T1 = clusterdata(score,3);
scatter3(score(:,1),score(:,2),score(:,3),100,Tc,'filled')
axis equal
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
zlabel('3rd Principal Component')
title('Result of Clustering');

% figure;
% imagesc(inputArg1(leafOrder,:));hold on;

% figure
% scatter3(score(:,1),score(:,2),score(:,3))
% axis equal
% xlabel('1st Principal Component')
% ylabel('2nd Principal Component')
% zlabel('3rd Principal Component')
end

