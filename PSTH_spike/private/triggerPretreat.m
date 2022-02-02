function stimMod = triggerPretreat(stim,sTrial,trialTo,handles)
%trigger times pretreatment
stimTimes = stim.times;
stimLevel = stim.level;

if max(stimLevel) ~= min(stimLevel)
    if stimLevel(1) == 0
        stimLevel(1) = [];
        stimLevel(1) = [];
    end
    stimTimes1 = stimTimes(logical(stimLevel));
    stimTimes0 = stimTimes(~logical(stimLevel));
    df = stimTimes0 - stimTimes1(1:length(stimTimes0));
    tmp = df;
    tmp(tmp<0.01) = [];% exclude 0 noise
    uniqLen = length(unique(round(10*tmp)));  
    if uniqLen == 1
        stimTimes = stimTimes1;
        stimLevel = stimLevel(logical(stimLevel));
        df = df < 0.01; % 5 ms
        stimTimes(df) = [];
        stimLevel(df) = []; 
        if size(stimTimes,1) == 1 & size(stimTimes,2) > 1
            stimTimes = stimTimes';
            stimLevel = stimLevel';
        end

        tf = diff(stimTimes);
        tf = tf < 0;
        stimTimes([false;tf]) = []; 
        stimLevel([false;tf]) = []; 
        totalTrial = length(stimTimes);
        if trialTo > totalTrial
            trialTo= totalTrial;
            cString =['[' num2str(sTrial) ' ' num2str(trialTo) ']'];
            set(handles.trials_edt,'String',cString);
            disp('Error trialTo!')
        end
        disp('Level triggers!')
        stimMod.times = stimTimes(sTrial:trialTo);
        stimMod.level = stimLevel(sTrial:trialTo);
    else
        totalTrial = length(stimTimes)/2;
        if trialTo > totalTrial
            trialTo= totalTrial;
            cString =['[' num2str(sTrial) ' ' num2str(trialTo) ']'];
            set(handles.trials_edt,'String',cString);
        end
        disp('Bout triggers!')
        stimMod.times = stim.times((2*sTrial - 1):2*trialTo);
        stimMod.level = stim.level((2*sTrial - 1):2*trialTo);
    end
else    
    totalTrial = length(stimTimes);
    if trialTo > totalTrial
        trialTo= totalTrial;
        cString =['[' num2str(sTrial) ' ' num2str(trialTo) ']'];
        set(handles.trials_edt,'String',cString);
    end
    stimMod.times = stim.times(sTrial:trialTo);
    stimMod.level = stim.level(sTrial:trialTo);
    disp('Event triggers2!')
end

