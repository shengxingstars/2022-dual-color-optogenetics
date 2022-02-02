function [ output_args ] = average_ana_spt2(data)
%AVERAGE_ANA 此处显示有关此函数的摘要
%   此处显示详细说明
% [filename, pathname] = uigetfile('*.mat');
% data = load([pathname,filename]);
% speed = data.vglut5Hz;
pre_stim = 3;
post_stim = 6;
xP2 = 3;
bin = 0.05;
tn = -pre_stim:bin:post_stim;
tn_len = length(tn)

speed_ylim = [-100 60]; %%%%%

    speed = data;
    speed_size = size(speed);
    speed_mean = mean(speed);
    speed_sem = std(speed)/sqrt(speed_size(1)-1);

    figure
    for j = 1:size(speed,1)  %%%%total trial number plot
        plot(tn,data(j,:),'color',[0.65 0.65 0.65],'LineWidth',1);hold on;
    end
    %%%%plot average data
%     drawErrorLine_light(tn,speed_mean,speed_sem,'r',4);hold on;
     plot(tn,speed_mean,'color',[1 0 0],'LineWidth',3);hold on; %%%%%if you need errobar, use the above line
    
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
    ylabel('Speed (cm/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     ylabel('DeltaF/F (%)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     ylabel('Pupil size change (%)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%    xlabel('Frequencye (Hz)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     ylabel('LFP Power changer stim/control','FontName','Arial','FontSize',25,'FontWeight','Bold');
    xP = 0;
    line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
    line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);




end


