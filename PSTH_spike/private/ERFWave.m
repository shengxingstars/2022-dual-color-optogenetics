function [ERF,mERF] = ERFWave(cStim,resp,preTime,postTime,sCtrl,eCtrl,offset,tag)
% 20150722 ERFWave if last trial end duration larger than total time, then discard it.
stimLevel = cStim.level;
if max(stimLevel) ~= min(stimLevel)
    stimTimes = cStim.times(logical(stimLevel));
else
    stimTimes = cStim.times;
end
values = resp.values - offset;
times = resp.times;
interval = resp.interval;
baseLen = floor((eCtrl - sCtrl)/interval);
trialLen = floor((preTime + postTime)/interval);
trialNum = length(stimTimes);
if stimTimes(end)+postTime > times(end)
    trialNum = length(stimTimes) - 1;
end
if tag == 1
    signal40 = smooth(resp.values,round(0.025*500));
    signal01 = smooth(resp.values,100*500);
    values = signal40 - signal01+ offset;
    mVal = median(values((round(stimTimes/resp.interval) - 2*500):end));%from 2 s before the first event
    dFF = (values - mVal)./(mVal)*100;
    ERF = zeros(trialNum,trialLen);
    for i=1:1:trialNum
       tmp = times >= stimTimes(i) - preTime;
       cTrialIdxS = find(tmp,1,'first');
       ERF(i,:) = dFF(cTrialIdxS:cTrialIdxS + trialLen -1);
    end
    disp('Median based calculation!')
else
    ERF = zeros(trialNum,trialLen);
    for i=1:1:trialNum        
       tmp = times >= stimTimes(i) + sCtrl;
       cBaseIdxS = find(tmp,1,'first');
       tmp = times >= stimTimes(i) - preTime;
       cTrialIdxS = find(tmp,1,'first');
       cBaseVal = values(cBaseIdxS:cBaseIdxS + baseLen -1);
       mCBaseVal = median(cBaseVal);
       cTrialVal = values(cTrialIdxS:cTrialIdxS + trialLen -1);
       ERF(i,:) = (cTrialVal - mCBaseVal)./(mCBaseVal)*100;
    end
%     disp('Baseline!')
end
mERF = mean(ERF);

