function [ output_args ] = find_sp_sp_correlation()
%FIND_SPEED_DELTAF 此处显示有关此函数的摘要
%   此处显示详细说明
%%%edit by LLH 20210926 
%%%open file
file = dir('*analysis*.mat');
bin = 0.05;
%%%%extract parameters
optrode_r = [];
speedb_mean = [];
speedf_mean = [];
tn = [];
psth_mean = [];
psth2_mean = [];
z_score_psth  = [];
z_score_psth2 = [];
b_corr = [];
f_corr = [];
z_score_b  = [];
z_score_f = [];
for i = 1:length(file)
    cName = file(i).name;
    temp = importdata(cName);

    optrode_r = [optrode_r;temp.optrode_r];%%%%%%%%%%
    speedb_mean = [speedb_mean;temp.speedb_mean];%%%%%%%%%%%
    speedf_mean = [speedf_mean;temp.speedf_mean]; 
    tn = [tn;temp.tn];
    psth_mean = [psth_mean;temp.psth_mean];
    psth2_mean  = [psth2_mean;temp.psth2_mean];
    z_score_psth = [z_score_psth;temp.z_score_psth];
    z_score_psth2 = [z_score_psth2;temp.z_score_psth2];%%%%%%%%%%%%%

    
    %%%calculate z-score based on baseline
        temp1 = temp.psth_mean;
        temp2 = temp.psth2_mean;
       cBaseVal = temp1(1:0.8/bin);
        cBaseVal2 = temp2(1:0.8/bin);
       z1 = (temp1 - mean(cBaseVal))./std(cBaseVal);
       z2 = (temp2 - mean(cBaseVal2))./std(cBaseVal2);
        z_score_b  = [z_score_b;z1];
        z_score_f = [z_score_f;z2];
    
    speedb_meanR = resample(temp.speedb_mean(1:30),2,1);
    speedf_meanR = resample(temp.speedf_mean(1:30),2,1);
    assignin('base','speedb_meanR',speedb_meanR);
    assignin('base','speedf_meanR',speedf_meanR);
    [R,P] = corrcoef(speedb_meanR,temp.z_score_psth);
    [R2,P2] = corrcoef(speedf_meanR,temp.z_score_psth2);
    b_corr = [b_corr;R(2)];
    f_corr = [f_corr;R2(2)];

end

% assignin('base','theta_p',theta_p);
% assignin('base','speed_total',speed);

group_data.optrode_r = optrode_r;
group_data.speedb_mean = speedb_mean;
group_data.speedf_mean = speedf_mean; %%
group_data.tn = tn;%
group_data.psth_mean = psth_mean;
group_data.psth2_mean = psth2_mean; %%
group_data.z_score_psth = z_score_psth;
group_data.z_score_psth2 = z_score_psth2;
group_data.b_corr = b_corr;
group_data.f_corr = f_corr;
group_data.z_score_b = z_score_b;
group_data.z_score_f  =z_score_f;
% save group_data group_data -v7.3;
save group_data group_data -v7.3;
disp('group data have been found');
end

