function [ output_args ] = find_spt2_gtacr()
%FIND_SPEED_DELTAF 此处显示有关此函数的摘要
%   此处显示详细说明
file = dir('*analysis.mat');
pre_stim = 5;
post_stim = 10;
xp = 5;
control_from = 4;
control_to = -0.5;
bin = 0.1;

speed_mean = []; %%% locomotion
pupil_diam_mean = []; %%%arousal
delta_band_pro = [];  %%%%CA1 LFP analysis
delta_band_stim = [];
delta_band_post = [];
P1_mean  = [];
ps_stim_pre_mean = [];
ps_stim_pre_mean2 = [];
theta_band_mean = [];
theta_band = []; %%%%CA1 LFP analysis
speed = []; %%% locomotion
pupil_diam = []; %%%arousal
p_ctrl = [];
p_stim = [];
p_post = [];
mean_power = [];
sparseness_peakf = zeros(length(file),9);
normalized_p = zeros(length(file),9);
for i = 1:length(file)
    cName = file(i).name
    temp = importdata(cName);
    
    %%%calculating average power spectrum
    power_size = length(temp.theta_band_mean);
%     str769 = strfind(cName,'xyz');
%     if ~isempty(str769)
%         temp.p_lowf(:,1+power_size:power_size*3) = [];
%         temp_mean_p = temp.p_lowf;
%         assignin('base','temp_mean_p',temp_mean_p);
%         mean_power = [mean_power,temp_mean_p(1:200,:)];
%     else
        mean_p = [];
        for j=1:200
            temp_p = [];
            for h = 1:size(temp.p_lowf,2)/power_size
                temp_p = [temp_p;temp.p_lowf(j,1+(h-1)*power_size:power_size*h)];
            end
            mean_p = [mean_p;mean(temp_p)];
        end
        mean_power = [mean_power,mean_p];
%     end
    assignin('base','mean_power',mean_power);
    
    %%%analyze sparseness and peak frequency
    P0 = [];
    P1 = [];
    P2 = [];
    for h = 1:size(temp.p_lowf,2)/power_size
        temp_data = temp.p_lowf(1:200,1+(h-1)*power_size:power_size*h);
        p_pro = temp_data(:,200:(pre_stim*100-100))'; %%%%%-2.5 to -0.5s
        p_running = temp_data(:,(pre_stim*100-50):(pre_stim*100-50+xp*100))';
        p_post = temp_data(:,(pre_stim*100-50+xp*100):(pre_stim*100-50+xp*100+1*100))';
        P0 = [P0;mean(p_pro)];
        P1 = [P1;mean(p_running)];
        P2 = [P2;mean(p_post)];
    end
    assignin('base','P0',P0);
    assignin('base','P1',P1);
    assignin('base','P2',P2);
    if size(P0,1)>1
        p_ctrl = [p_ctrl;mean(P0)];
        p_stim = [p_stim;mean(P1)];
        p_post = [p_post;mean(P2)];
        ps_stim_pre_mean2 = [ps_stim_pre_mean2;mean(P1)./mean(P0)];
    end
    
    [sparseness,peakFreq,peakAmplitude] = sparseness_peak(P0(:,61:100));
    sparseness_peakf(i,1) = sparseness;
    sparseness_peakf(i,4) = peakFreq+4;
    sparseness_peakf(i,7) = peakAmplitude;
    [sparseness,peakFreq,peakAmplitude] = sparseness_peak(P1(:,61:100));
    sparseness_peakf(i,2) = sparseness;
    sparseness_peakf(i,5) = peakFreq+4;
    sparseness_peakf(i,8) = peakAmplitude;
    [sparseness,peakFreq,peakAmplitude] = sparseness_peak(P2(:,61:100));
    sparseness_peakf(i,3) = sparseness;
    sparseness_peakf(i,6) = peakFreq+4;
    sparseness_peakf(i,9) = peakAmplitude;
    
    %%%%calculate normalized power
    normalized_p(i,1) = sum(sum(P0(:,41:100)))/sum(sum(P0(:,1:100)));
    normalized_p(i,2) = sum(sum(P1(:,41:100)))/sum(sum(P1(:,1:100)));
    normalized_p(i,3) = sum(sum(P0(:,61:100)))/sum(sum(P0(:,1:100)));
    normalized_p(i,4) = sum(sum(P1(:,61:100)))/sum(sum(P1(:,1:100)));
%     normalized_p(i,5) = sum(sum(P0(:,101:200)))/sum(sum(P0(:,1:100)));
%     normalized_p(i,6) = sum(sum(P1(:,101:200)))/sum(sum(P1(:,1:100)));
    
    if size(temp.delta_band_pro,1)>1
        delta_band_pro = [delta_band_pro;mean(temp.delta_band_pro)]; 
        delta_band_stim = [delta_band_stim;mean(temp.delta_band_stim)];
        delta_band_post = [delta_band_post;mean(temp.delta_band_post)];
    else
        delta_band_pro = [delta_band_pro;temp.delta_band_pro]; 
        delta_band_stim = [delta_band_stim;temp.delta_band_stim];
        delta_band_post = [delta_band_post;temp.delta_band_post];
    end
    P1_mean  = [P1_mean;temp.P1_mean];
    ps_stim_pre_mean = [ps_stim_pre_mean;temp.ps_stim_pre_mean];
    
%     if length(temp.speed_mean) == 301
        speed_mean = [speed_mean;temp.speed_mean];%%% locomotion
        pupil_diam_mean = [pupil_diam_mean;temp.pupil_diam_mean];%%%arousal
        theta_band_mean = [theta_band_mean;temp.theta_band_mean];%%%%CA1 LFP analysis
        speed = [speed;temp.speed]; %%% locomotion
        pupil_diam = [pupil_diam;temp.pupil_diam]; %%%arousal
        theta_band = [theta_band;temp.theta_band]; %%%%CA1 LFP analysis
%     else
%         speed_mean = [speed_mean;temp.speed_mean(1:151)];
%         pupil_diam_mean = [pupil_diam_mean;temp.pupil_diam_mean(1:151)];
%         theta_band_mean = [theta_band_mean;temp.theta_band_mean(1:1401)];
%         speed = [speed;temp.speed(:,1:151)]; %%% locomotion
%         pupil_diam = [pupil_diam;temp.pupil_diam(1:151)]; %%%arousal
%         theta_band = [theta_band;temp.theta_band(1:1401)]; %%%%CA1 LFP analysis
%     end
end
% assignin('base','speed_total',speed);
% assignin('base','speed_total',speed);
data.speed_mean = speed_mean;
data.pupil_diam_mean = pupil_diam_mean;
data.delta_band_pro = delta_band_pro;  %%%%CA1 LFP analysis
data.delta_band_stim = delta_band_stim;
data.delta_band_post = delta_band_post;
data.P1_mean  = P1_mean;
data.ps_stim_pre_mean = ps_stim_pre_mean;
data.ps_stim_pre_mean2 = ps_stim_pre_mean2;
data.theta_band_mean = theta_band_mean;
data.sparseness_peakf = sparseness_peakf;
data.p_ctrl = p_ctrl;
data.p_stim = p_stim;
data.mean_power = mean_power;
data.normalized_p = normalized_p;
data.p_post = p_post;
data.theta_band = theta_band; %%%%CA1 LFP analysis
data.speed = speed; %%% locomotion
data.pupil_diam = pupil_diam; %%%arousal

group_data = data;
save group_data group_data;
% save([file(1).name(12:18),' groupData'],'group_data');
disp('grouping end!');
end

