function [ output_args ] = average_ana3()
%AVERAGE_ANA 此处显示有关此函数的摘要
%   此处显示详细说明


pre_stim = 1;
post_stim = 2;
xP2 = 0.2;
% control_from = -5;
% control_to = -0.5;
bin = 0.05;
tn = -pre_stim:bin:post_stim-bin;
tn_len = length(tn);
clims = [0 30];
speed_ylim = [0 40]; %%%

file = dir('*ANA*cue*.mat');

mPETH=[];
name = cell(length(file),1);
for i = 1:length(file)
    cName = file(i).name;
    name{i,1} = cName;
    temp = importdata(cName);
%     data_filename = ['rb14',cName];
%     save(data_filename,'-struct','temp');
    mPETH = [mPETH;temp.mPETH(2,:)];

end
base_firing = [];
stim_firing = [];
for i = 1:size(mPETH,1)
    base_firing = [base_firing;mean(mPETH(i,1:pre_stim/bin))];
    stim_firing = [stim_firing;mean(mPETH(i,pre_stim/bin:(pre_stim+xP2)/bin))];
end
[sort_stim_firing index] = sort(stim_firing-base_firing,'descend');
% [sort_stim_firing index] = sort(stim_firing,'descend');
% index=[7;2;1;3;11;17;12;15;9;5;13;18;14;4;6;16;8;10];%%%%%%
% index= [7;8;2;4;3;5;12;9;13;11;6;10;1];%%%%%%
sort_mPETH = mPETH(index,:);
name = name(index,:);
assignin('base','mPETH', mPETH);
assignin('base','sort_mPETH', sort_mPETH);
vData.sort_mPETH = sort_mPETH;
vData.mPETH = mPETH;
vData.index = index;
vData.name = name;
vData.base_firing = base_firing;
vData.stim_firing = stim_firing;
save('group_data','-struct','vData');

speed = sort_mPETH;
speed_size = size(speed,1);
speed_mean = mean(speed);
speed_sem = std(speed)/sqrt(speed_size-1);

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure; 
plotHeatmap(tn,speed,clims);
colorbar;
% % set(gca,'xTick',-pre_stim:1:post_stim);
% colorbar([0.93 0.18 0.03 0.2],'FontSize',5,'yTick',clims);
set(gca,'xTickLabel',-pre_stim:1:post_stim,'FontSize',20,'FontWeight','Bold');
% set(gca,'xTickLabel',-5:1:8);
xlabel('Time(s)','FontSize',25,'FontWeight','Bold');
ylabel('Cell number','FontSize',25,'FontWeight','Bold');

figure
    drawErrorLine_light(tn,speed_mean,speed_sem,'k',4);hold on;
%     drawErrorLine_light(tn,speed_mean2,speed_sem2,'m',4);hold on;
%     drawErrorLine_light(tn,speed_mean3,speed_sem3,'b',4);hold on;
%     drawErrorLine_light(tn,speed_mean4,speed_sem4,'r',4);hold on;
%     for j = 1:size(data,1)
% %         plot(tn,data(j,:),'k','LineWidth',2);hold on;
%         data(j,:) = data(j,:)/mean(data(j,1:50));
%     end
%     plot(tn,smooth(data(1,:)),'k','LineWidth',4);hold on;
%     plot(tn,smooth(data(2,:)),'r','LineWidth',4);hold on;
%     plot(tn,smooth(data(3,:)),'b','LineWidth',4);hold on;
%     plot(tn,smooth(data(4,:)),'c','LineWidth',4);hold on;
%     plot(tn,smooth(data(5,:)),'m','LineWidth',4);hold on;
% plot(tn,speed_mean,'c','LineWidth',4);hold on;
% plot(tn,speed_mean2,'m','LineWidth',4);hold on;
% plot(tn,speed_mean3,'b','LineWidth',4);hold on;
% plot(tn,speed_mean4,'r','LineWidth',4);hold on;
% plot(tn,speedC_mean,'k','LineWidth',4);hold on;
%     legend('ctrl','NI-MS','NI-LH','NI-IPN','NI-IO');
%     legend('ctrl','Vglut2','Vgat','NMB');

%     drawErrorLine_light(tn,speedC_mean,speedC_sem,'k',4);hold on;
% % drawErrorLine_light(tn,speedmC_mean,speedmC_sem,'k',4);hold on;
% % legend('GtACR1');
% legend('mGFP');
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
% set(gca,'yLim',[-10 80]);
box off;
set(gca,'yLim',speed_ylim);%speed
% set(gca,'yLim',[80 160]);%pupil
% set(gca,'xLim',[1 1481],'xTick',[491 991],'xTicklabel',[0 5]);%%%lick signal
% set(gca,'xLim',[1 300],'xTick',0:50:300,'xTicklabel',-5:5:30);
% set(gca,'xLim',[1 1401],'xTick',[451 951],'xTicklabel',[5 10]);
set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     ylabel('Change in theta power (%)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     xlabel('Frequency (Hz)','FontName','Arial','FontSize',25,'FontWeight','Bold');
ylabel('Firing rate (spikes/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     ylabel('DeltaF/F (%)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     ylabel('Pupil size change (%)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%    xlabel('Frequencye (Hz)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     ylabel('LFP Power changer stim/control','FontName','Arial','FontSize',25,'FontWeight','Bold');
xP = 0;
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure; 
% plotHeatmap(tn,speed,clims);
% colorbar;
% % % set(gca,'xTick',-pre_stim:1:post_stim);
% % colorbar([0.93 0.18 0.03 0.2],'FontSize',5,'yTick',clims);
% set(gca,'xTickLabel',-pre_stim:1:post_stim,'FontSize',20,'FontWeight','Bold');
% % set(gca,'xTickLabel',-5:1:8);
% xlabel('Time(s)','FontSize',25,'FontWeight','Bold');
% ylabel('Mouse number','FontSize',25,'FontWeight','Bold');
% % title(strrep(filename, '\', '\\'));
% % set(gca,'FontSize',12,'FontWeight','Bold');
% subplot(2,1,2);
% plot(tn,backward);


% figure;%%%%%%%%%%%%%%%%%%
% % p_plot = [mean(delta_band_pro);mean(delta_band_stim);mean(delta_band_post)];
% % c = bar(p_plot,'k');hold on;
% % c(2).FaceColor = 'red';
% speed_mean=[speedC_mean,speed_mean];
% c=bar(speed_mean,'k');
% c(2).FaceColor = 'red';
% ylabel('Power (dB)','FontName','Arial','FontSize',10,'FontWeight','Bold');
% set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
% bar([0,5],[35,35],'FaceColor',[0.678,0.827,0.878]);
% x1 = 0:0.5:5;
% x2 = fliplr(x1);
% 
% y1 = 0:3.5:35;
% y2 = fliplr(y1);
% patch([x1 x2],[y1 y2],'FaceColor',[0.678,0.827,0.878],'EdgeColor','none');
