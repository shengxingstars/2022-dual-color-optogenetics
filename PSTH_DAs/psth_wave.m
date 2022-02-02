function [psth,psth_mean, sem] = psth_wave(trigger_times,interval,values, ...
    basal_time,odor_time,control_from,control_to,offset)
    N = length(values);
    times = (0:N-1)*interval;
    val1 = cell(1,length(trigger_times));
    val2 = cell(1,length(trigger_times));
    
for i=1:length(trigger_times)
       k1= times >= trigger_times(i) + control_from & times < trigger_times(i) + control_to;
       k = times >= trigger_times(i) - basal_time & times < trigger_times(i) + odor_time;
       if sum(k) > (basal_time+odor_time)/interval
            m = find(k == 1,1,'first');
            k(m) = [];
        end
        if sum(k) < (basal_time+odor_time)/interval
            m = find(k == 1,1,'first');
            k(m-1)=1;
        end
       val1{1,i} = values(k1)-offset;
       val2{1,i} = values(k)-offset;
end

val1 = cell2mat(val1);
val2 = cell2mat(val2);

val1 = repmat(mean(val1,1),size(val2,1),1)';
val2 = val2';

psth = (val2 - val1)./val1*100;
sem = std(psth)/(length(trigger_times)-1)^0.5;
psth_mean = mean(psth);
assignin('base','psth',psth);