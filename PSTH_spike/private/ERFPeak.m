function [peaks,ERF,maxPks] = ERFPeak(resp,stim,preTime,postTime,sCtrl,eCtrl,offset,tag)
% 20150718 postTime pks average, max, increase and decrease time;
% 20150717 time points that exceed the thresh were treated as increase.
% 20150625 thresh exceeds 95% of the base population
% MAD based peaks detection method; ERF is also calculated. two methods are
% used with tag==0 and tag==1 respectively.
times = resp.times;
values = resp.values - offset;
interval = resp.interval;
cTimes = [];
cValues = [];
trialLen = floor((preTime + postTime)/interval);
if max(stim.level) ~= min(stim.level) & tag == 1 % all peaks at least two input resp and stimTimes
    signal40 = smooth(resp.values,round(0.025*500));
    signal01 = smooth(resp.values,100*500);
    values = signal40 - signal01+ offset;
    mVal = median(values((round(120/resp.interval)):end));%from 2 min 
    dFF = (values - mVal)./(mVal)*100;
    stimTimes1 = stim.times(logical(stim.level));
    stimTimes0 = stim.times(~logical(stim.level));
    boutNum = length(stimTimes1);
    ERF = zeros(boutNum,trialLen);
    maxPks = nan(boutNum,4);% [incDur boutDur Max MaxTime]
    for i=1:1:boutNum
        maxPks(i,2) = stimTimes0(i) - stimTimes1(i);
        boutOnIdx = find(times <= stimTimes1(i),1,'last');
        boutOffIdx = find(times <= stimTimes0(i),1,'last');
        cBoutdFF = dFF(boutOnIdx:boutOffIdx);
        [cPks,locs] = findpeaks(cBoutdFF);%,'minpeakheight',thresh);
        maxPks(i,1) = mean(cPks);
        cValues = [cValues;cPks];
        cTimes = [cTimes;(locs + boutOnIdx)*interval];
        [cMaxPks,cMaxIdx] = max(cPks,[],1);
        if ~ isempty(cMaxIdx)
            maxPks(i,3:4) = [cMaxPks,locs(cMaxIdx)*interval];
        end
        tmp = times >= stimTimes1(i) - preTime;
        cTrialIdxS = find(tmp,1,'first');
        ERF(i,:) = dFF(cTrialIdxS:cTrialIdxS + trialLen -1);
    end
end
if max(stim.level) ~= min(stim.level) & tag == 0
    stimTimes1 = stim.times(logical(stim.level));
    stimTimes0 = stim.times(~logical(stim.level));
    boutNum = length(stimTimes1);
    baseLen = floor((eCtrl - sCtrl)/interval);
    ERF = zeros(boutNum,trialLen);
    mBaseVal = zeros(boutNum,1) ;
    maxPks = nan(boutNum,6);% [incDur decDur boutDur Max MaxTime meanPks]
    mallBoutERF = nan(boutNum,1);
    for i=1:1:boutNum
        %calculate ERF
        tmp = times >= stimTimes1(i) + sCtrl;
        cBaseIdxS = find(tmp,1,'first');
        cBaseVal = values(cBaseIdxS:cBaseIdxS + baseLen -1); 
        tmp = times >= stimTimes1(i) - preTime;
        cBoutIdxS = find(tmp,1,'first');
        mCBaseVal = median(cBaseVal);
        cTrialVal =  values(cBoutIdxS:cBoutIdxS + trialLen -1);
        ERF(i,:) = (cTrialVal - mCBaseVal)./(mCBaseVal)*100;
        mBaseVal(i,1) = mCBaseVal;
    end
    baseS = (preTime + sCtrl)./(preTime + postTime)*trialLen + 1;
    baseERF = reshape(ERF(:,baseS:baseS + baseLen - 1),[],1);
    mbaseERF = median(ERF(:,baseS:baseS + baseLen - 1),2);
    %thresh = 2.91*mad(baseERF,1)
    thresh = prctile(baseERF,95);
    threshL = prctile(baseERF,5);
%     figure;hist(baseERF);
%     idx0 =  preTime./(preTime + postTime)*trialLen + 1;
    for i=1:1:boutNum
        % calculate peaks before stim onset
%         tmp = times >= stimTimes1(i) - preTime;
%         cBoutIdxS = find(tmp,1,'first');
%         if ~isempty(find(ERF(i,1:idx0)'>=thresh,1))
%             [cPks,locs] = findpeaks(ERF(i,1:idx0)','minpeakheight',thresh);
%             cValues = [cValues;cPks];
%             cTimes = [cTimes;(locs + cBoutIdxS -1)*interval];
%         end
%         [cPreMaxPks,cPreMaxIdx] = max(cPks,[],1);
%         if ~ isempty(cPreMaxIdx)
%             maxPks(i,1:2) = [cPreMaxPks(1),(locs(cPreMaxIdx(1)) - idx0)*interval];
%         end 
        % calculate peaks during the bout
        mCBaseVal = mBaseVal(i,1);
        maxPks(i,3) = stimTimes0(i) - stimTimes1(i);
        boutOnIdx = find(times <= stimTimes1(i),1,'last');
        boutOffIdx = find(times <= stimTimes0(i),1,'last');       
        cBoutVal = values(boutOnIdx:boutOffIdx);
        cBoutdFF = (cBoutVal - mCBaseVal)./(mCBaseVal)*100;
        mallBoutERF(i,1) = median(cBoutdFF);
        incDur = cBoutdFF>=thresh;
        maxPks(i,1) = sum(incDur)*interval;
        decDur = cBoutdFF<=threshL;
        maxPks(i,2) = sum(decDur)*interval;
        if ~isempty(find(incDur,1))
            [cPks,locs] = findpeaks(cBoutdFF,'minpeakheight',thresh);
            maxPks(i,6) = nanmean(cPks);
            cValues = [cValues;cPks];
            cTimes = [cTimes;(locs + boutOnIdx)*interval];        
            [cMaxPks,cMaxIdx] = max(cPks,[],1);
            if ~ isempty(cMaxIdx)
                maxPks(i,4:5) = [cMaxPks(1),locs(cMaxIdx(1))*interval];
            end
        end
    end
    [p,h] = signrank(mbaseERF,mallBoutERF)
    mbase = mean(mbaseERF)
    mBout = mean(mallBoutERF)
end
if max(stim.level) == min(stim.level)
    stimTimes = stim.times(logical(stim.level));
    maxPks = nan(size(stimTimes,1),5);% [incDur decDur postTime Max MaxTime meanPks]
    baseLen = floor((eCtrl - sCtrl)/interval);
    ERF = zeros(length(stimTimes),trialLen);
    trialNum = length(stimTimes);
    if stimTimes(end)+postTime > length(values)*interval
        trialNum = length(stimTimes) - 1;
    end
    for i=1:1:trialNum
        %calculate ERF
        tmp = times >= stimTimes(i) + sCtrl;
        cBaseIdxS = find(tmp,1,'first');
        cBaseVal = values(cBaseIdxS:cBaseIdxS + baseLen -1); 
        tmp = times >= stimTimes(i) - preTime;
        cTrialIdxS = find(tmp,1,'first');
        mCBaseVal = median(cBaseVal);
        cTrialVal =  values(cTrialIdxS:cTrialIdxS + trialLen -1);
        ERF(i,:) = (cTrialVal - mCBaseVal)./(mCBaseVal)*100;
    end
    baseS = (preTime + sCtrl)./(preTime + postTime)*trialLen + 1;
    baseERF = reshape(ERF(:,baseS:baseS + baseLen - 1),[],1);
   % thresh = 2.91*mad(baseERF,1)
    thresh = prctile(baseERF,95);
    threshL = prctile(baseERF,5);
    idx0 =  abs(preTime)./(preTime + postTime)*trialLen + 1;
    for i = 1:1:length(stimTimes)
        incDur = ERF(i,idx0:end)'>=thresh;
        maxPks(i,1) = sum(incDur)*interval;
        decDur = ERF(i,idx0:end)'<=threshL;
        maxPks(i,2) = sum(decDur)*interval;
        tmp = times >= stimTimes(i) - preTime;
        cTrialIdxS = find(tmp,1,'first');
        % calculate peaks before stim onset
%         if ~isempty(find(ERF(i,1:idx0)'>=thresh,1))
%             [cPks,locs] = findpeaks(ERF(i,1:idx0)','minpeakheight',thresh);         
%             cValues = [cValues;cPks];
%             cTimes = [cTimes;(locs + cTrialIdxS -1)*interval];
%         end
%         [cPreMaxPks,cPreMaxIdx] = max(cPks,[],1);
%         if ~ isempty(cMaxIdx)
%             maxPks(i,1:2) = [cPreMaxPks(1),(locs(cPreMaxIdx(1)) - idx0)*interval];
%         end 
        % calculate peaks during the bout
        maxPks(i,3) = postTime;
        if ~isempty(find(incDur,1))
            [cPks,locs] = findpeaks(ERF(i,idx0:end)','minpeakheight',thresh); 
            maxPks(i,6) = nanmean(cPks);
            cValues = [cValues;cPks];
            cTimes = [cTimes;(locs + cTrialIdxS + idx0-1)*interval];
            [cMaxPks,cMaxIdx] = max(cPks,[],1);
             if ~ isempty(cMaxIdx)
                maxPks(i,4:5) = [cMaxPks(1),locs(cMaxIdx(1))*interval];
            end 
        end        
    end
end
peaks.times = cTimes;
peaks.values = cValues;
peaks.title = 'peaks';

% for test
% figure;
% plot(times,dFF,'-b');
% hold on
% plot(peaks.times,peaks.values,'*r')
% hold off