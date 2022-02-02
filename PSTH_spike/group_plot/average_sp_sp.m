function [ output_args ] = average_sp_sp()
%AVERAGE_ANA 此处显示有关此函数的摘要
%   此处显示详细说明
[filename, pathname] = uigetfile('group*.mat');
group_data = importdata([pathname,filename]);

pre_stim = 1;
post_stim = 2;
% control_from = -5;
% control_to = -0.5;
bin_speed = 0.1;
bin_spike = 0.05;
% tn = -1:bin:2-bin;
speed_clims = [-10 10];
spike_clims = [-2 3];
speed_ylim = [-10 5];
spike_ylim = [-2 3];

light = 1;
correlation_plot = 1;
z_score_plot = 1;
line_plot = 1;
psth_plot = 0;

%%%%%%%
optrode_r = group_data.optrode_r;
% temp =  optrode_r(:,1)>0.5 & optrode_r(:,2)<5 & optrode_r(:,3)>0.85 & optrode_r(:,4)<0.001;
temp =  optrode_r(:,1)>0.5 & optrode_r(:,2)<5 & optrode_r(:,3)>0.85;
% temp =  optrode_r(:,3)>0.85 & optrode_r(:,4)<0.001;
temp2 = ~temp;
if light
    speedb_mean = group_data.speedb_mean(temp,:);
    speedf_mean = group_data.speedf_mean(temp,:); %%
    tn = group_data.tn(1,:);%
    psth_mean = group_data.psth_mean(temp,:);
    psth2_mean = group_data.psth2_mean(temp,:); %%
    z_score_psth = group_data.z_score_b(temp,:);
    z_score_psth2 = group_data.z_score_f(temp,:);
    b_corr = group_data.b_corr(temp,:);
    f_corr = group_data.f_corr(temp,:);
else
    speedb_mean = group_data.speedb_mean(temp2,:);
    speedf_mean = group_data.speedf_mean(temp2,:); %%
    tn = group_data.tn(1,:);%
    psth_mean = group_data.psth_mean(temp2,:);
    psth2_mean = group_data.psth2_mean(temp2,:); %%
    z_score_psth = group_data.z_score_b(temp2,:);
    z_score_psth2 = group_data.z_score_f(temp2,:);
    b_corr = group_data.b_corr(temp2,:);
    f_corr = group_data.f_corr(temp2,:);
end

%%
if correlation_plot
    edges = -1:0.1:1;  % bin boundaries
    s_b_corr = sort(b_corr,1);
    s_b_corrHst = hist(s_b_corr,edges);
    ns_b_corrHst = zeros(size(s_b_corrHst,1),size(s_b_corrHst,2));
    for next = 1:1:size(s_b_corrHst,2)
        ns_b_corrHst(:,next) = s_b_corrHst(:,next)/sum(s_b_corrHst);
    end
    assignin('base','s_b_corrHst',s_b_corrHst);
    figure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bar(ns_b_corrHst,'c');
    hold on 
    set(gca,'xlim',[0 20],'xtick',0:5:20,'xticklabel',-1:0.5:1);
    xlabel('Back-speed vs z-score R','FontName','Arial','FontSize',10,'FontWeight','Bold');
    ylabel('Number of cells','FontName','Arial','FontSize',10,'FontWeight','Bold');
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');

    edges = -1:0.1:1;  % bin boundaries
    s_f_corr = sort(f_corr,1);
    s_f_corrHst = hist(s_f_corr,edges);
    ns_f_corrHst = zeros(size(s_f_corrHst,1),size(s_f_corrHst,2));
    for next = 1:1:size(s_f_corrHst,2)
        ns_f_corrHst(:,next) = s_f_corrHst(:,next)/sum(s_f_corrHst(:,:));
    end
    figure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bar(ns_f_corrHst,'g');
    hold on 
    set(gca,'xlim',[0 20],'xtick',0:5:20,'xticklabel',-1:0.5:1);
    xlabel('Fore-speed vs z-score R','FontName','Arial','FontSize',10,'FontWeight','Bold');
    ylabel('Number of cells','FontName','Arial','FontSize',10,'FontWeight','Bold');
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
end
%%
if z_score_plot
    %%%%sort cells
    base_firing = [];
    stim_firing = [];
    psth_max = [];
    for i = 1:size(z_score_psth,1)
        base_firing = [base_firing;mean(z_score_psth(i,1:pre_stim/bin_spike))];
        stim_firing = [stim_firing;mean(z_score_psth(i,pre_stim/bin_spike:(pre_stim+post_stim)/bin_spike))];
        psth_max = [psth_max;mean(psth_mean(i,:))];
    end
    [sort_stim_firing index] = sort(stim_firing,'descend');
    psth_max = find(psth_max>150);
    assignin('base','psth_max',psth_max);

    %%%cluster data with Hierarchical clustering
    % [leafOrder,coeff] = dendrograms_plot([z_score_psth z_score_psth2]);
%     [leafOrder,T,outperm] = dendrograms_plot(z_score_psth);
%     index = leafOrder;
%     group1 = find(T==24 | T==28 | T==11);
%     group2 = find(T==12 | T==16);
%     group3 = T;
%     group3(group1)=[];
%     group3(group2)=[];
    
    figure;%%%%%%%%%%%%%%%%%%%%%%%%%%-------------------------------------
    set(gcf,'Position',[50,50,500,600]);
    imagesc(speedb_mean(index,:),speed_clims);hold on;
    % imagesc(change_p,[50 200]);hold on;
    c = colorbar('Position',[0.92 0.32 0.02 0.4],'FontSize',10,'yTick',speed_clims);
%             c.Label.String = 'speed (cm/s)';
    set(gca,'YDir','normal');%%%%reverse
    box off;
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
    set(gca,'xLim',[1 size(speedb_mean,2)]);
    set(gca,'xtick',(0:1:(pre_stim+post_stim))/bin_speed);
    set(gca,'xticklabel',-pre_stim:1:post_stim);
    xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold'); 
    ylabel('Cell #','FontName','Arial','FontSize',25,'FontWeight','Bold');
    title('Backward speed (cm/s)','FontName','Arial','FontSize',20,'FontWeight','Bold');

        figure;%%%%%%%%%%%%%%%%%%%%%%%%%%-------------------------------------
    set(gcf,'Position',[50,50,500,600]);
    imagesc(speedf_mean(index,:),speed_clims);hold on;
    % imagesc(change_p,[50 200]);hold on;
    c = colorbar('Position',[0.92 0.32 0.02 0.4],'FontSize',10,'yTick',speed_clims);
%         c.Label.String = 'speed (cm/s)';
    set(gca,'YDir','normal');
    box off;
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
    set(gca,'xLim',[1 size(speedb_mean,2)]);
    set(gca,'xtick',(0:1:(pre_stim+post_stim))/bin_speed);
    set(gca,'xticklabel',-pre_stim:1:post_stim);
    xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold'); 
    ylabel('Cell #','FontName','Arial','FontSize',25,'FontWeight','Bold');
        title('Forward speed (cm/s)','FontName','Arial','FontSize',20,'FontWeight','Bold');

        figure;%%%%%%%%%%%%%%%%%%%%%%%%%%-------------------------------------
    set(gcf,'Position',[150,50,500,600]);
    z_score_psth = z_score_psth(index,:);
    imagesc(z_score_psth,spike_clims);hold on;
    % imagesc(change_p,[50 200]);hold on;
    c = colorbar('Position',[0.92 0.32 0.02 0.4],'FontSize',10,'yTick',spike_clims);
%         c.Label.String = 'z-score';
    set(gca,'YDir','normal');
    box off;
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
    set(gca,'xLim',[1 size(z_score_psth,2)]);
    set(gca,'xtick',(0:1:(pre_stim+post_stim))/bin_spike);
    set(gca,'xticklabel',-pre_stim:1:post_stim);
    xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold'); 
    ylabel('Cell #','FontName','Arial','FontSize',25,'FontWeight','Bold');
        title('Backward z-score','FontName','Arial','FontSize',20,'FontWeight','Bold');


    z_score_psth2 = z_score_psth2(index,:);
        figure;%%%%%%%%%%%%%%%%%%%%%%%%%%-------------------------------------
    set(gcf,'Position',[150,50,500,600]);
    imagesc(z_score_psth2,spike_clims);hold on;
    % imagesc(change_p,[50 200]);hold on;
    c = colorbar('Position',[0.92 0.32 0.02 0.4],'FontSize',10,'yTick',spike_clims);
%     c.Label.String = 'z-score';
    set(gca,'YDir','normal');
    box off;
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
    set(gca,'xLim',[1 size(z_score_psth2,2)]);
    set(gca,'xtick',(0:1:(pre_stim+post_stim))/bin_spike);
    set(gca,'xticklabel',-pre_stim:1:post_stim);
    xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold'); 
    ylabel('Cell #','FontName','Arial','FontSize',25,'FontWeight','Bold');
    title('Forward z-score','FontName','Arial','FontSize',20,'FontWeight','Bold');
end

%%
if line_plot
    speed = speedb_mean;
    speed_size = size(speed,1);
    speed_mean = mean(speed);
    speed_sem = std(speed)/sqrt(speed_size-1);
    % 
    speedC = speedf_mean;
    speedC_size = size(speedC,1);
    speedC_mean = mean(speedC);
    speedC_sem = std(speedC)/sqrt(speedC_size-1);
    
    figure
%     drawErrorLine_light(tn,speedC_mean,speedC_sem,'k',4);hold on;
    drawErrorLine_light(tn,speed_mean,speed_sem,'k',4);hold on;
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
    box off;
    set(gca,'yLim',speed_ylim);%speed
    set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
    xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
    ylabel('Backward speed (cm/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
    xP = 0;
    line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
    
        figure
    drawErrorLine_light(tn,speedC_mean,speedC_sem,'k',4);hold on;
%     drawErrorLine_light(tn,speed_mean,speed_sem,'k',4);hold on;
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
    box off;
    set(gca,'yLim',sort(-speed_ylim));%speed
    set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
    xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
    ylabel('Forward speed (cm/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
    xP = 0;
    line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
    
%     tn = -pre_stim:bin_spike:post_stim-bin_spike;
%     speed_ylim = [-1 2];
%         speed = z_score_psth(group1,:);
%     speed_size = size(speed,1);
%     speed_mean = mean(speed);
%     speed_sem = std(speed)/sqrt(speed_size-1);
%     % 
%     speedC = z_score_psth(group2,:);
%     speedC_size = size(speedC,1);
%     speedC_mean = mean(speedC);
%     speedC_sem = std(speedC)/sqrt(speedC_size-1);
%     
%     figure
% %     drawErrorLine_light(tn,speedC_mean,speedC_sem,'k',4);hold on;
%     drawErrorLine_light(tn,speed_mean,speed_sem,'k',4);hold on;
%     set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
%     box off;
%     set(gca,'yLim',speed_ylim);%speed
%     set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
%     xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     ylabel('z score','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     xP = 0;
%     line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
%     
%         figure
%     drawErrorLine_light(tn,speedC_mean,speedC_sem,'k',4);hold on;
% %     drawErrorLine_light(tn,speed_mean,speed_sem,'k',4);hold on;
%     set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
%     box off;
%     set(gca,'yLim',speed_ylim);%speed
%     set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
%     xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     ylabel('z score','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     xP = 0;
%     line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
%     
% 
%         speed = z_score_psth(group3,:);
%     speed_size = size(speed,1);
%     speed_mean = mean(speed);
%     speed_sem = std(speed)/sqrt(speed_size-1);
%     
%     figure
% %     drawErrorLine_light(tn,speedC_mean,speedC_sem,'k',4);hold on;
%     drawErrorLine_light(tn,speed_mean,speed_sem,'k',4);hold on;
%     set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
%     box off;
%     set(gca,'yLim',speed_ylim);%speed
%     set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
%     xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     ylabel('z score','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     xP = 0;
%     line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
end
%%
if psth_plot    
    spike_clims = [0 200];
        figure;%%%%%%%%%%%%%%%%%%%%%%%%%%-------------------------------------
    set(gcf,'Position',[150,50,500,600]);
    imagesc(psth_mean,spike_clims);hold on;
    % imagesc(change_p,[50 200]);hold on;
    c = colorbar('Position',[0.92 0.32 0.02 0.4],'FontSize',10,'yTick',spike_clims);
%         c.Label.String = 'z-score';
    set(gca,'YDir','normal');
    box off;
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
    set(gca,'xLim',[1 size(z_score_psth,2)]);
    set(gca,'xtick',(0:1:(pre_stim+post_stim))/bin_spike);
    set(gca,'xticklabel',-pre_stim:1:post_stim);
    xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold'); 
    ylabel('Cell #','FontName','Arial','FontSize',25,'FontWeight','Bold');
        title('Backward psth','FontName','Arial','FontSize',20,'FontWeight','Bold');
    
        figure;%%%%%%%%%%%%%%%%%%%%%%%%%%-------------------------------------
    set(gcf,'Position',[150,50,500,600]);
    imagesc(psth2_mean,spike_clims);hold on;
    % imagesc(change_p,[50 200]);hold on;
    c = colorbar('Position',[0.92 0.32 0.02 0.4],'FontSize',10,'yTick',spike_clims);
%     c.Label.String = 'z-score';
    set(gca,'YDir','normal');
    box off;
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
    set(gca,'xLim',[1 size(z_score_psth2,2)]);
    set(gca,'xtick',(0:1:(pre_stim+post_stim))/bin_spike);
    set(gca,'xticklabel',-pre_stim:1:post_stim);
    xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold'); 
    ylabel('Cell #','FontName','Arial','FontSize',25,'FontWeight','Bold');
    title('Forward psth','FontName','Arial','FontSize',20,'FontWeight','Bold'); 
end

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
