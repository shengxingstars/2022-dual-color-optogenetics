function trigger_times = trigger_times_pretreatment2(Triggers,trial_from,...
    trial_number,t_from,t_to,handles)

%trigger times pretreatment

trigger_times0 = Triggers.times;
trigger_levels = Triggers.level;
% trigger_times(1:4) = [];
% trigger_levels(1:4) = [];
assignin('base','Triggers',Triggers);

if trigger_levels(1) == 0
    trigger_times(1) = [];
    trigger_levels(1) = [];
end
trigger_times_up = trigger_times0(logical(trigger_levels));
trigger_times_down = trigger_times0(find(trigger_levels==0));

tf = diff(trigger_times_up);
min(tf)
if min(tf)<1
% if length(max(trigger_levels)) ~= length(min(trigger_levels))


% if size(trigger_times_up,1) == 1 && size(trigger_times_up,2) > 1
%     trigger_times_up = trigger_times_up';
% end
% assignin('base','trigger_times_test1',trigger_times_up);
%%%%%%%find up level
tf = diff(trigger_times_up);
tf = find(tf < 15)+1;
trigger_times_up(tf) = []; 

%%%%%%%find down level
tf_down = diff(trigger_times_down);
tf_down = find(tf_down > 15);
last_down = trigger_times_down(end);
trigger_times_down = [trigger_times_down(tf_down);last_down];
% tf_down = find(tf_down < 15)+1;
% trigger_times_down(tf_down) = []; 
assignin('base','trigger_times_up',trigger_times_up);
assignin('base','trigger_times_down',trigger_times_down);

temp = min(length(trigger_times_up),length(trigger_times_down));
trigger_times = [trigger_times_up(1:temp),trigger_times_down(1:temp)];

a = trigger_times(:,1) > t_from & trigger_times(:,1) < t_to;
trigger_times = trigger_times(a,:);

else
    trigger_times = [trigger_times_up,trigger_times_down];
   a = trigger_times(:,1) > t_from & trigger_times(:,1) < t_to;
    trigger_times = trigger_times(a,:); 
end
% total_trial_number_in_file = length(trigger_times);
% if trial_number > total_trial_number_in_file - trial_from + 1
%     trial_number = total_trial_number_in_file - trial_from + 1;
%     set(handles.edit_trial_number,'String',num2str(trial_number));
% %     set(handles.edit_trial_number,'String',50);
% end
% trigger_times = trigger_times((trial_from:(trial_from + trial_number - 1))');