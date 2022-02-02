function [ output_args ] = spike_plot( data )
%SPIKE_PLOT 此处显示有关此函数的摘要
%   此处显示详细说明
figure
spike = [];
for i=1:size(data,1)
     min_spike = min(data(i,:));
     max_spike = max(data(i,:));
     if min_spike<-0.2 & max_spike<0.2 &min_spike>-0.5
%          plot(data(i,:),'k');hold on;
        
        spike = [spike;data(i,:)];
     end
end
assignin('base','stim_spike_example_c13',spike);


speed = spike;
speed_size = size(speed,1);
speed_mean = mean(speed);
speed_sem = std(speed)/sqrt(speed_size-1);
tn = 1:length(speed_mean);
drawErrorLine_light(tn,speed_mean,speed_sem,'k',4);hold on;

% plot(mean(spike),'r','LineWidth',4);
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
% set(gca,'yLim',[-10 80]);
box off;
xlabel('Time (total 2 ms)','FontName','Arial','FontSize',25,'FontWeight','Bold');
ylabel('Voltage (total 120uV)','FontName','Arial','FontSize',25,'FontWeight','Bold');
end

