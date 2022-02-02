function trigger_times = trigger_times_pretreatment(Triggers,trial_from,...
    trial_number,basal_time,odor_time,handles)

%trigger times pretreatment

trigger_times = Triggers.times;
trigger_levels = Triggers.level;
% trigger_times(1:4) = [];
% trigger_levels(1:4) = [];
% assignin('base','trigger_times_test',trigger_times);

% if trigger_levels(1) == 0
%     trigger_times(1) = [];
%     trigger_levels(1) = [];
% end
if max(trigger_levels) ~= min(trigger_levels)
    trigger_times = trigger_times(logical(trigger_levels));
end
if size(trigger_times,1) == 1 && size(trigger_times,2) > 1
    trigger_times = trigger_times';
end
assignin('base','trigger_times_test1',trigger_times);
% tf = diff(trigger_times);
% tf = tf < 20;%basal_time + odor_time;
% trigger_times([false;tf]) = []; 
tf = diff(trigger_times);
tf = find(tf < 5)+1;
trigger_times(tf) = []; 
% trigger_times_temp = [];
% for i = 1:length(trigger_times)-1
%     diff_shock = diff(trigger_times);
%     if diff_shock(i) > 20
%        trigger_times_temp = [trigger_times_temp;trigger_times(i+1)];
%     end
% end
% trigger_times_temp = [trigger_times(1);trigger_times_temp];
% assignin('base','trigger_times_temp',trigger_times_temp);
assignin('base','trigger_times_test2',trigger_times);

total_trial_number_in_file = length(trigger_times);
if trial_number > total_trial_number_in_file - trial_from + 1
    trial_number = total_trial_number_in_file - trial_from + 1;
    set(handles.edit_trial_number,'String',num2str(trial_number));
%     set(handles.edit_trial_number,'String',50);
end
trigger_times = trigger_times((trial_from:(trial_from + trial_number - 1))');