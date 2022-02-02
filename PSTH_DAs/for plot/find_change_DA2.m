function [ output_args ] = find_change_DA2( psth )
%FIND_10SPEED_TIME 此处显示有关此函数的摘要
%%%%editted by LLH 20201023
xp = 6;
xp1 = 0;
xp2 = 6;
bin = 0.1;
pre_stim = 5;
post_stim = 30;
x = -pre_stim:bin:post_stim;
win = [xp1 xp2];
% file = dir('*analysis.mat');



psth_da = [];
psth_max=[];
psth_auc=[];
for i = 1:size(psth,1)
%     cName = file(i).name;
%     disp(file(i).name)
%     temp = importdata(cName);
    psth_da = psth(i,:);
    %%%%%%calculate max psth
    psth_max=[psth_max;max(psth_da(1,pre_stim/bin:(pre_stim+xp)/bin))];
        %%%%%%calculate area under curve (AUC)
    temp2 = aucCalculate2(x,win,psth_da);
    psth_auc = [psth_auc;temp2];
end
assignin('base','psth_max',psth_max);
assignin('base','psth_auc',psth_auc);

group_statistic.psth_da = psth_da;
group_statistic.psth_max = psth_max;
group_statistic.psth_auc = psth_auc;
save group_statistic group_statistic;

%%%calculate onset and ofset latency
%Zhang er al.2018. Neuron. For treadmill running test, the onset
%latency was determined as the first time point when the speed exceeded the baseline by three times standard deviation of the baseline
%speed. It should be noted that animals normally stayed still in the control state. Speed values were determined based on the
%encoder reading, using a scaling factor which is dependent on parameters such as cycles per revolution (CPR) and output rate of
%the encoder. Instantaneous speed was calculated from two sequential video frames.
%10-15s after locomotion offset is defined as baseline
% data = group_data.speed_mean(:,1:end-1);
% data = group_data.psth_mean;
% data = group_data.pupil_diam_mean(:,1:end-1);
% data = group_data.theta_band_mean;
% bin = 10;
% stop_time = [];
% tx = cell(1,10);
% for i = 1:size(data,1)
%     temp1 = data(i,:);
%     temp1=  resample(temp1,1,10);
%     temp1 = smooth(1:length(temp1),temp1,0.1)';%%%smooth data
% 
% %     baseline = mean(data(i,20*bin:end));
%     baseline = mean(temp1(1:4.5*bin));
%     SD = std(baseline);
%     jugement_va = (baseline+3*SD)
%     temp1(1:5*bin) = 0;
%         assignin('base','data_smooth',temp1);
%     t1 = find(temp1 >= jugement_va);
% %     assignin('base','t1',t1);
%     tx{1,i} = t1;
% %     tx{1,i} = data(i,:);
%     diff_t1 = diff(t1);
%     t2 = find(diff_t1>1);
% %     if ~isempty(t2)
% %         stop_time = [stop_time;t2(1)/bin];%%%%second
% %     else
%         stop_time = [stop_time;t1(1)/bin];%%%%second
% %     end
% end
% stop_time = stop_time-5;%%%latency 
% % tx = cell2mat(tx);
% assignin('base','tx',tx);
% assignin('base','diff_t1',diff_t1);
% assignin('base','t2',t2);
% assignin('base','stop_time',stop_time);
% save stop_time stop_time;

% % save ('GtACR1_speed_min','-struct','group_data');
% disp('finished!');
end
% theta_power = zeros(6,2);
% for i = 1:size(data,1)
%     theta_power(i,1) = mean(data(i,1:451));
%     theta_power(i,2) = mean(data(i,451:951));
% end
% assignin('base','theta_power',theta_power);

% group_data.speed_max5 = speed_max5;
% assignin('base','delta_speed',delta_speed);
% group_data = speed_min;

%%% calculating locomotion reliability
% locomotion =[];
% for i = 1:size(speed,1)
%     locomotion1 = ~isempty(find(speed(i,50:100)>1,1));
%     locomotion = [locomotion;locomotion1];
% end
% locomotion_reliability = sum(locomotion)/size(speed,1);
% locomotion_reliability 


%%%%for stimulation
% for i = 1:size(forward_mean,1)
%     speed_max = max(forward_mean(i,:));
%     t1 = find(forward_mean(i,:) >= speed_max*0.1);
%     t2 = find(forward_mean(i,:) >= speed_max*0.9);
%     stop_time(i,1) = t1(1)/10;
%     stop_time(i,2) = t2(1)/10;
% end

%%% for inhibition
% for i = 1:size(forward_mean,1)
%     speed_max = max(forward_mean(i,:));
%     t1 = find(forward_mean(i,:) <= speed_max*0.9);
%     t2 = find(forward_mean(i,:) <= speed_max*0.2);
%     stop_time(i,1) = t1(1)/10;
%     stop_time(i,2) = t2(1)/10;
% end
% assignin('base','stop_time',stop_time);
% save stop_time stop_time;

% speed_stop = speed(1,80)
% speed_light = speed(51:80);
% speed_latency = find(speed_light > 0.5);
% speed_latency = speed_latency(1)/10
% locomotion_onset = [];
% start_time = [];
% for i = 1:size(speed,1)
%     [locomotion_on,pval, t_orig, crit_t, est_alpha, seed_state] = mult_comp_perm_t1(speed,1000,1,0.05,0,1);
% % % % [pval, t_orig, crit_t, est_alpha, seed_state]=mult_comp_perm_t1(data,n_perm,tail,alpha_level,mu,reports,seed_state)
%      locomotion_onset = [locomotion_onset;locomotion_on];
% %     speed_max1 = max(speed(i,50:100));
% %     t1 = find(speed(i,50:100) >= speed_max1*0.1);
% %     start_time = [start_time;t1(1)/10];
% end
% % locomotion_on_mean = mean(locomotion_on)
% % start_time_mean = mean(start_time);
% assignin('base','locomotion_onset',locomotion_onset);
% save locomotion_onset locomotion_onset;
