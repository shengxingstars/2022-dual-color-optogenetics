function [ onset_back, onset_for ] = start_pretreat2( speed_all,times_all,pre_stim_time,post_stim_time,bin )
%START_PRETREAT 此处显示有关此函数的摘要
%   此处显示详细说明
% find trigger-times that runing at least 1 second,and almost immobility 1 second before runing
a = abs(pre_stim_time/bin);
b = abs(post_stim_time/bin);
% b = 1/bin;

% up_speed = b*0.85;
% up_rest = a*0.1;
% up_max_speed = 3;
% down_rest = a*0.2;
% down_speed = b*0.6;
% down_max_speed = 4;

up_speed = b*0.8;
up_rest = a*0.1;
up_max_speed = 1;

times_all = (1:length(speed_all));
k = 1;
cTrigger_times = [];
cTrigger_times3 = [];
for i = a:length(speed_all)-b+1
    B = speed_all(i:i+b-1);
    C = speed_all(i-a+1:i);
    %%%%find forward trigger times
    if (length(find(B > 1))>=up_speed) && (length(find(abs(C) > 1))<=up_rest && max(B) > up_max_speed)
        cTrigger_times = [cTrigger_times;times_all(i)];
%         k = k+1;  
    end
    %%%%find backward trigger times
    if (length(find(B < -1))>=up_speed) && (length(find(abs(C) > 1))<=up_rest && min(B) < -up_max_speed)
        cTrigger_times3 = [cTrigger_times3;times_all(i)];
 
    end
     k = k+1;  
%     if (length(find(B ~= 0))<=down_rest) && (length(find(C > 4))>=down_speed && max(C) > down_max_speed)
%         cTrigger_times2(k) = times_all(i);
%         k = k+1;   
%     end
end
assignin('base','times_all',times_all); 
% cTrigger_times = cTrigger_times';
% cTrigger_times3 = cTrigger_times3';
assignin('base','cTrigger_times',cTrigger_times); 
assignin('base','cTrigger_times3',cTrigger_times3); 

k2 = 1;
for j = 1:(length(cTrigger_times)-1)
    df = cTrigger_times(j+1)-cTrigger_times(j);
    if df > 40
        trigger_times(k2) = cTrigger_times(j+1);
    end
    k2 = k2+1;
end
% h1 = trigger_times < GC6_start;
% if max(h1) > 0
%     trigger_times(logical(h1)) = [];
% end
trigger_times = (trigger_times(logical(trigger_times)));
trigger_times = ([cTrigger_times(1),trigger_times])';
assignin('base','trigger_times',trigger_times); 


% k3 = 1;
% for j = 1:(length(cTrigger_times2)-1)
%     df = cTrigger_times2(j+1)-cTrigger_times2(j);
%     if df > 4
%         trigger_times2(k3) = cTrigger_times2(j+1);
%     end
%     k3 = k3+1;
% end
% trigger_times2 = trigger_times2(logical(trigger_times2));
% assignin('base','trigger_times2',trigger_times2');

k4 = 1;
for j = 1:(length(cTrigger_times3)-1)
    df = cTrigger_times3(j+1)-cTrigger_times3(j);
    if df > 40
        trigger_times3(k4) = cTrigger_times3(j+1);
    end
    k4 = k4+1;
end
trigger_times3 = trigger_times3(logical(trigger_times3));
trigger_times3 = ([cTrigger_times3(1),trigger_times3])';
assignin('base','trigger_times3',trigger_times3);

onset_back = trigger_times3;
onset_for = trigger_times;

% toc;
end

