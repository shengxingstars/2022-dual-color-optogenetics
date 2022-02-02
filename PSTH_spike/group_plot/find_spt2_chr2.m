function [ output_args ] = find_spt2_chr2()
%FIND_SPEED_DELTAF 此处显示有关此函数的摘要
%   此处显示详细说明
file = dir('*hz*analysis.mat');

pre_stim = 5;
post_stim = 25;
xp = 5;
control_from = 4;
control_to = -0.5;
bin = 0.1;

speed_mean = []; %%% locomotion
pupil_diam_mean = []; %%%arousal
theta_band_mean = [];%%%theta
speed = [];
pupil = [];
theta = [];
speed_delay = [];
pupil_delay = [];
theta_delay = [];
speed_stim = [];
pupil_stim = [];
theta_stim = [];

delta_band_pro = [];  %%%%CA1 LFP analysis
delta_band_stim = [];
delta_band_post = [];
P1_mean  = [];
ps_stim_pre_mean = [];
ps_stim_pre_mean2 = [];
p_ctrl = [];
p_stim = [];
mean_power = [];
sparseness_peakf = zeros(length(file),6);
normalized_p = zeros(length(file),9);
normalized_p2 = [];
length(file)
for i = 1:length(file)
    cName = file(i).name
    temp = importdata(cName);
    power_size = length(temp.theta_band_mean)
    
    %%%calculating average power spectrum
    mean_p = [];
    for j=1:200
        temp_p = [];
        for h = 1:size(temp.p_lowf,2)/power_size
            temp_p = [temp_p;temp.p_lowf(j,1+(h-1)*power_size:power_size*h)];
        end
        mean_p = [mean_p;mean(temp_p)];
    end
    mean_power = [mean_power,mean_p];
    assignin('base','mean_power',mean_power);
    
    %%%analyze sparseness and peak frequency
    P0 = [];
    P1 = [];
    P2 = [];
    for h = 1:size(temp.p_lowf,2)/power_size
        temp_data = temp.p_lowf(1:200,1+(h-1)*power_size:power_size*h);
        p_pro = temp_data(:,200:(pre_stim*100-100))';%%%%%-2.5 to -0.5s
        p_running = temp_data(:,(pre_stim*100-50):(pre_stim*100-50+xp*100))';
        post_running = temp_data(:,(pre_stim*100-50+xp*100):(pre_stim*100-50+xp*100+1*100))';
        P0 = [P0;mean(p_pro)];
        P1 = [P1;mean(p_running)];
        P2 = [P2;mean(post_running)];
    end
    assignin('base','P0',P0);
    assignin('base','P1',P1);
%     assignin('base','P2',P2);
    p_ctrl = [p_ctrl;mean(P0)];
    p_stim = [p_stim;mean(P1)];
    ps_stim_pre_mean2 = [ps_stim_pre_mean2;mean(P1)./mean(P0)];
    
    [sparseness,peakFreq,peakAmplitude] = sparseness_peak(P0(:,61:100));
    sparseness_peakf(i,1) = sparseness;
    sparseness_peakf(i,3) = peakFreq+4;
    sparseness_peakf(i,5) = peakAmplitude;
    [sparseness,peakFreq,peakAmplitude] = sparseness_peak(P1(:,61:100));
    sparseness_peakf(i,2) = sparseness;
    sparseness_peakf(i,4) = peakFreq+4;
    sparseness_peakf(i,6) = peakAmplitude;
    
    %%%%calculate normalized power
    normalized_p(i,1) = sum(sum(P0(:,41:100)))/sum(sum(P0(:,1:100)));
    normalized_p(i,2) = sum(sum(P1(:,41:100)))/sum(sum(P1(:,1:100)));
    normalized_p(i,3) = sum(sum(P2(:,41:100)))/sum(sum(P2(:,1:100)));
    normalized_p(i,4) = sum(sum(P0(:,61:100)))/sum(sum(P0(:,1:100)));
    normalized_p(i,5) = sum(sum(P1(:,61:100)))/sum(sum(P1(:,1:100)));
    normalized_p(i,6) = sum(sum(P2(:,61:100)))/sum(sum(P2(:,1:100)));
%     normalized_p(i,7) = sum(sum(P0(:,61:100)))/sum(sum(P0(:,1:100)));
%     normalized_p(i,8) = sum(sum(P1(:,61:100)))/sum(sum(P1(:,1:100)));
%     normalized_p(i,9) = sum(sum(P2(:,61:100)))/sum(sum(P2(:,1:100)));
    
    normalized_p2t = [];
    for j = 1:size(mean_power,1)
        normalized_p2t = [normalized_p2t;sum(mean_power(40:100,j))/sum(mean_power(1:120,j))]; 
    end
    normalized_p2 = [normalized_p2;mean(normalized_p2t)];
    %%%calculate onset time
%     data = temp.speed;
%     baseLen =abs((control_to-control_from)/bin);
%     baseS = (pre_stim + control_from)./(pre_stim+post_stim)*size(data,2)+ 1;
%     cCtrl = data(:,baseS:baseS + baseLen - 1);
%     baseMean = nanmean(nanmean(cCtrl));
%     mCtrl = nanmean(cCtrl,2);
%     dataCtrl =  repmat(mCtrl,1,size(data,2));
%     dif = data-dataCtrl; %difference between conditions  
%     alpha_level = 0.05;
%     [pval, t_orig, crit_t, est_alpha, seed_state] = mc_perm_gc(dif,1000,0,alpha_level,0,1);
%     speed_mean1 = mean(data);
%     posSigIdx = speed_mean1 > baseMean & pval<alpha_level;
%     posSigIdx(:,1:20) = 0;
%     assignin('base','posSigIdx_onset',posSigIdx);
%     % negSigIdx = psth_mean < baseMean & pval<alpha_level;
%     speed_onset = find(posSigIdx(:,:)==1,1,'first')*bin-pre_stim;
%     if isnan(speed_onset)
%         speed_onset = 5;
%     end
%     speed_delay = [speed_delay;speed_onset];
%     
%     data = temp.theta_band;
%     baseLen =abs((control_to-control_from)/bin);
%     baseS = (pre_stim + control_from)./(pre_stim+post_stim)*size(data,2)+ 1;
%     cCtrl = data(:,baseS:baseS + baseLen - 1);
%     baseMean = nanmean(nanmean(cCtrl));
%     mCtrl = nanmean(cCtrl,2);
%     dataCtrl =  repmat(mCtrl,1,size(data,2));
%     dif = data-dataCtrl; %difference between conditions  
%     alpha_level = 0.05;
%     [pval, t_orig, crit_t, est_alpha, seed_state] = mc_perm_gc(dif,1000,0,alpha_level,0,1);
%     speed_mean1 = mean(data);
%     posSigIdx = speed_mean1 > baseMean & pval<alpha_level;
%     posSigIdx(:,1:20) = 0;
%     assignin('base','posSigIdx_onset',posSigIdx);
%     % negSigIdx = psth_mean < baseMean & pval<alpha_level;
%     speed_onset = find(posSigIdx(:,:)==1,1,'first')*bin-pre_stim;
%     if isnan(speed_onset)
%         speed_onset = 5;
%     end
%     theta_delay = [theta_delay;speed_onset];
%     
%         data = temp.pupil_diam;
%     baseLen =abs((control_to-control_from)/bin);
%     baseS = (pre_stim + control_from)./(pre_stim+post_stim)*size(data,2)+ 1;
%     cCtrl = data(:,baseS:baseS + baseLen - 1);
%     baseMean = nanmean(nanmean(cCtrl));
%     mCtrl = nanmean(cCtrl,2);
%     dataCtrl =  repmat(mCtrl,1,size(data,2));
%     dif = data-dataCtrl; %difference between conditions  
%     alpha_level = 0.05;
%     [pval, t_orig, crit_t, est_alpha, seed_state] = mc_perm_gc(dif,1000,0,alpha_level,0,1);
%     speed_mean1 = mean(data);
%     posSigIdx = speed_mean1 > baseMean & pval<alpha_level;
%     posSigIdx(:,1:20) = 0;
%     assignin('base','posSigIdx_onset',posSigIdx);
%     % negSigIdx = psth_mean < baseMean & pval<alpha_level;
%     speed_onset = find(posSigIdx(:,:)==1,1,'first')*bin-pre_stim;
%     if isnan(speed_onset)
%         speed_onset = 5;
%     end
%     pupil_delay = [pupil_delay;speed_onset];
    
    speed_stim = [speed_stim;temp.speed_mean(1,100)];
    pupil_stim = [pupil_stim;temp.pupil_diam(1,100)];
    theta_stim = [theta_stim;temp.theta_band(1,100)];
    
    speed_mean = [speed_mean;temp.speed_mean];
    pupil_diam_mean = [pupil_diam_mean;temp.pupil_diam_mean];
    theta_band_mean = [theta_band_mean;temp.theta_band_mean];
    speed = [speed;temp.speed];
    pupil = [pupil;temp.pupil_diam];
    theta = [theta;temp.theta_band];
    delta_band_pro = [delta_band_pro;mean(temp.delta_band_pro)]; 
    delta_band_stim = [delta_band_stim;mean(temp.delta_band_stim)];
    delta_band_post = [delta_band_post;mean(temp.delta_band_post)];
    P1_mean  = [P1_mean;temp.P1_mean(:,1:200)];
    ps_stim_pre_mean = [ps_stim_pre_mean;temp.ps_stim_pre_mean(:,1:200)];
end
assignin('base','speed_mean',speed_mean);
% assignin('base','speed_total',speed);
group_data.speed_mean = speed_mean;
group_data.pupil_diam_mean = pupil_diam_mean;
group_data.delta_band_pro = delta_band_pro;  %%%%CA1 LFP analysis
group_data.delta_band_stim = delta_band_stim;
group_data.delta_band_post = delta_band_post;
group_data.P1_mean  = P1_mean;
group_data.ps_stim_pre_mean = ps_stim_pre_mean;
group_data.ps_stim_pre_mean2 = ps_stim_pre_mean2;
group_data.theta_band_mean = theta_band_mean;
group_data.sparseness_peakf = sparseness_peakf;
group_data.p_ctrl = p_ctrl;
group_data.p_stim = p_stim;
group_data.mean_power = mean_power;
group_data.normalized_p = normalized_p;
group_data.normalized_p2 = normalized_p2;
group_data.speed = speed;
group_data.pupil = pupil;
group_data.theta = theta;
% group_data.pupil_delay = pupil_delay;
% group_data.theta_delay = theta_delay;
% group_data.speed_delay = speed_delay;
group_data.speed_stim = speed_stim;
group_data.pupil_stim = pupil_stim;
group_data.theta_stim = theta_stim;

group_data = group_data;
% save group_data group_data;
save([file(1).name(10:24),' groupData'],'group_data');
disp('grouping end!');
end

