function [reD1,reD2,reD5,reD0,sDCue,reS0,reS05,reS1,reS2,reS5,sSCue,oPump,oPumpPre,oPumpPost] = probRandStimMod(varargin)
% 20150524 modified and tested
% cue pump cueom signal as input
% to calculate reDelay1 redelay2 redelay5 and reOmission 
% to calculate reSize05 reSize1 reSize2 reSize5 and reSize0
% tested 20150412 on DAT random delay and random reward size
if nargin == 0
cue1 = [];pump = [];cue2 = [];
file = dir('*.mat');
for i = 1:length(file)
    cName = file(i).name;
    cue1Tag = 0;cue2Tag = 0; pumpTag = 0; % modified 20150524
    if ~isempty(strfind(lower(cName),'cue1'))
            cue1Tag = 1;
    end
    if ~isempty(strfind(lower(cName),'cue2'))
            cue2Tag = 1;
    end
    if ~isempty(strfind(lower(cName),'pump'))
        pumpTag = 1;
    end
    tmp = [cue1Tag pumpTag cue2Tag];
    idx = find(tmp);
    if ~isempty(idx)
        switch idx
            case 1
                cue1 = importdata(cName);
            case 2
                pump = importdata(cName);
            case 3
                cue2 = importdata(cName);
        end
    end
end
end

if nargin == 3
    cue1 = varargin{1};
    cue2 = varargin{2};
    pump = varargin{3};
else
    disp('Please input 3 varables!')
end
    
%% sort cue based on delay and reward size
if ~isempty(cue1)
stim1 = cue1;
stim1TIdx = find(stim1.level);
if isempty(stim1TIdx)
    disp('No stimulus!')
    return
end
tmp = (stim1.times(stim1TIdx+1) - stim1.times(stim1TIdx));
tmpIdx = tmp < 0.1; % exclude some nosie levels
if ~isempty(find(tmpIdx,1,'first'))
    stim1TIdx(tmpIdx) = []; 
    nCue1 = stim1;
    nCue1.times = stim1.times(stim1TIdx);
    nCue1.level = stim1.level(stim1TIdx);
    nCue1.length = length(nCue1.times);
    save('nCue1.mat','-struct','nCue1')
    disp('Noise excluded!')
end
stim1Time = stim1.times(stim1TIdx); % stimTime with unit s
stim1Num = length(stim1Time);
% isolate different rewward delay
resp = pump;
respTime1 = resp.times(logical(resp.level));
respTime0 = resp.times(~logical(resp.level));
tmp = respTime0 - respTime1;
tmpIdx = find(tmp<0.4);
if ~isempty(tmpIdx)
    respTime1(tmpIdx) = [];
    respTime0(tmpIdx) = [];
end
stimTimeD1 = [];
stimTimeD2 = [];
stimTimeD5 = [];
stimTimeD0 = [];

stimTimeS1 = [];
stimTimeS2 = [];
stimTimeS5 = [];
stimTimeS05 = [];
stimTimeS0 = [];

for i = 1:1:stim1Num
    cResp = respTime1 > stim1Time(i) + 2 & respTime1 <= stim1Time(i) + 8; % 1 2 5 s delay should be 3 4 7 s from cue onset
    cRespIdx = find(cResp,1,'first');
    if ~isempty(cRespIdx)
        switch round(respTime1(cRespIdx) - stim1Time(i))
            case 3
                stimTimeD1 = [stimTimeD1;stim1Time(i)];                
            case 4
                stimTimeD2 = [stimTimeD2;stim1Time(i)]; 
            case 7
                stimTimeD5 = [stimTimeD5;stim1Time(i)]; 
        end
        switch floor(respTime0(cRespIdx) - respTime1(cRespIdx))
            case 0
                stimTimeS05 = [stimTimeS05;stim1Time(i)];                               
            case 1
                stimTimeS1 = [stimTimeS1;stim1Time(i)]; 
            case 2
                stimTimeS2 = [stimTimeS2;stim1Time(i)]; 
            case 5
                stimTimeS5 = [stimTimeS5;stim1Time(i)];  
        end
    else
       stimTimeD0 = [stimTimeD0;stim1Time(i)];
       stimTimeS0 = [stimTimeS0;stim1Time(i)]; 
    end
end
reD1 = []; reD2 = []; reD5 = []; reD0 = [];
if ~isempty(stimTimeD1)
    reD1 = stim1;
    reD1.times = stimTimeD1;
    reD1.level = ones(size(stimTimeD1));
    reD1.length = length(stimTimeD1);
    save('reD11.mat','-struct','reD1')
end
if ~isempty(stimTimeD2)
    reD2 = stim1;
    reD2.times = stimTimeD2;
    reD2.level = ones(size(stimTimeD2));
    reD2.length = length(stimTimeD2);
    save('reD12.mat','-struct','reD2')
end
if ~isempty(stimTimeD5)
    reD5 = stim1;
    reD5.times = stimTimeD5;
    reD5.level = ones(size(stimTimeD5));
    reD5.length = length(stimTimeD5);
    save('reD15.mat','-struct','reD5')
end
if ~isempty(stimTimeD0)
    reD0 = stim1;
    reD0.times = stimTimeD0;
    reD0.level = ones(size(stimTimeD0));
    reD0.length = length(stimTimeD0);
    save('reD10.mat','-struct','reD0')
end
if ~isempty(stimTimeD2)
    sDStimTime = [stimTimeD1;stimTimeD2;stimTimeD5;stimTimeD0];
    sDCue = stim1;
    sDCue.times = sDStimTime;
    sDCue.level = ones(size(sDStimTime));
    sDCue.length = length(sDStimTime);
    save('sDCue1.mat','-struct','sDCue')
end
% isolate different reward size
reS1 = []; reS2 = []; reS5 = []; reS0 = [];reS05 = [];
if ~isempty(stimTimeS0)
    reS0 = stim1;
    reS0.times = stimTimeS0;
    reS0.level = ones(size(stimTimeS0));
    reS0.length = length(stimTimeS0);
    save('reS10.mat','-struct','reS0')
end
if ~isempty(stimTimeS05)
    reS05 = stim1;
    reS05.times = stimTimeS05;
    reS05.level = ones(size(stimTimeS05));
    reS05.length = length(stimTimeS05);
    save('reS105.mat','-struct','reS05')
end
if ~isempty(stimTimeS1)
    reS1 = stim1;
    reS1.times = stimTimeS1;
    reS1.level = ones(size(stimTimeS1));
    reS1.length = length(stimTimeS1);
    save('reS11.mat','-struct','reS1')
end
if ~isempty(stimTimeS2)
    reS2 = stim1;
    reS2.times = stimTimeS2;
    reS2.level = ones(size(stimTimeS2));
    reS2.length = length(stimTimeS2);
    save('reS12.mat','-struct','reS2')
end
if ~isempty(stimTimeS5)
    reS5 = stim1;
    reS5.times = stimTimeS5;
    reS5.level = ones(size(stimTimeS5));
    reS5.length = length(stimTimeS5);
    save('reS15.mat','-struct','reS5')
end
if ~isempty(stimTimeS1)
    sSStimTime = [stimTimeS0;stimTimeS05;stimTimeS1;stimTimeS2;stimTimeS5];
    sSCue = stim1;
    sSCue.times = sSStimTime;
    sSCue.level = ones(size(sSStimTime));
    sSCue.length = length(sSStimTime);
    save('sSCue1.mat','-struct','sSCue')
end
end
%% get pump signal before and in cue omission trials
if ~isempty(cue2)
stim2 = cue2;
stimT2Idx = find(stim2.level);
if isempty(stimT2Idx)
    disp('No stimulus!')
    return
end
tmp = (stim2.times(stimT2Idx+1) - stim2.times(stimT2Idx));
tmpIdx = tmp < 0.1; % exclude some nosie levels
if ~isempty(find(tmpIdx,1,'first'))
    stimT2Idx(tmpIdx) = []; 
    nCue2 = stim2;
    nCue2.times = stim2.times(stimT2Idx);
    nCue2.level = stim2.level(stimT2Idx);
    nCue2.length = length(nCue2.times);
    save('nCue2.mat','-struct','nCue2')
    disp('Noise excluded!')
end
stim2Time = stim2.times(stimT2Idx); % stimTime with unit s
stim2Num = length(stim2Time);
% isolate different rewward delay
resp = pump;
respTime1 = resp.times(logical(resp.level));
respTime0 = resp.times(~logical(resp.level));
tmp = respTime0 - respTime1;
tmpIdx = find(tmp<0.4);
if ~isempty(tmpIdx)
    respTime1(tmpIdx) = [];
    respTime0(tmpIdx) = [];
end
stimTimeD1 = [];
stimTimeD2 = [];
stimTimeD5 = [];
stimTimeD0 = [];

stimTimeS1 = [];
stimTimeS2 = [];
stimTimeS5 = [];
stimTimeS05 = [];
stimTimeS0 = [];

for i = 1:1:stim2Num
    cResp = respTime1 > stim2Time(i) + 2 & respTime1 <= stim2Time(i) + 8; % 1 2 5 s delay should be 3 4 7 s from cue onset
    cRespIdx = find(cResp,1,'first');
    if ~isempty(cRespIdx)
        switch round(respTime1(cRespIdx) - stim2Time(i))
            case 3
                stimTimeD1 = [stimTimeD1;stim2Time(i)];                
            case 4
                stimTimeD2 = [stimTimeD2;stim2Time(i)]; 
            case 7
                stimTimeD5 = [stimTimeD5;stim2Time(i)]; 
        end
        switch floor(respTime0(cRespIdx) - respTime1(cRespIdx))
            case 0
                stimTimeS05 = [stimTimeS05;stim2Time(i)];                               
            case 1
                stimTimeS1 = [stimTimeS1;stim2Time(i)]; 
            case 2
                stimTimeS2 = [stimTimeS2;stim2Time(i)]; 
            case 5
                stimTimeS5 = [stimTimeS5;stim2Time(i)];  
        end
    else
       stimTimeD0 = [stimTimeD0;stim2Time(i)];
       stimTimeS0 = [stimTimeS0;stim2Time(i)]; 
    end
end
reD1 = []; reD2 = []; reD5 = []; reD0 = [];
if ~isempty(stimTimeD1)
    reD1 = stim2;
    reD1.times = stimTimeD1;
    reD1.level = ones(size(stimTimeD1));
    reD1.length = length(stimTimeD1);
    save('reD21.mat','-struct','reD1')
end
if ~isempty(stimTimeD2)
    reD2 = stim2;
    reD2.times = stimTimeD2;
    reD2.level = ones(size(stimTimeD2));
    reD2.length = length(stimTimeD2);
    save('reD22.mat','-struct','reD2')
end
if ~isempty(stimTimeD5)
    reD5 = stim2;
    reD5.times = stimTimeD5;
    reD5.level = ones(size(stimTimeD5));
    reD5.length = length(stimTimeD5);
    save('reD25.mat','-struct','reD5')
end
if ~isempty(stimTimeD0)
    reD0 = stim2;
    reD0.times = stimTimeD0;
    reD0.level = ones(size(stimTimeD0));
    reD0.length = length(stimTimeD0);
    save('reD20.mat','-struct','reD0')
end
if ~isempty(stimTimeD2)
    sDStimTime = [stimTimeD1;stimTimeD2;stimTimeD5;stimTimeD0];
    sDCue = stim2;
    sDCue.times = sDStimTime;
    sDCue.level = ones(size(sDStimTime));
    sDCue.length = length(sDStimTime);
    save('sDCue2.mat','-struct','sDCue')
end
% isolate different reward size
reS1 = []; reS2 = []; reS5 = []; reS0 = [];reS05 = [];
if ~isempty(stimTimeS0)
    reS0 = stim2;
    reS0.times = stimTimeS0;
    reS0.level = ones(size(stimTimeS0));
    reS0.length = length(stimTimeS0);
    save('reS20.mat','-struct','reS0')
end
if ~isempty(stimTimeS05)
    reS05 = stim2;
    reS05.times = stimTimeS05;
    reS05.level = ones(size(stimTimeS05));
    reS05.length = length(stimTimeS05);
    save('reS205.mat','-struct','reS05')
end
if ~isempty(stimTimeS1)
    reS1 = stim2;
    reS1.times = stimTimeS1;
    reS1.level = ones(size(stimTimeS1));
    reS1.length = length(stimTimeS1);
    save('reS21.mat','-struct','reS1')
end
if ~isempty(stimTimeS2)
    reS2 = stim2;
    reS2.times = stimTimeS2;
    reS2.level = ones(size(stimTimeS2));
    reS2.length = length(stimTimeS2);
    save('reS22.mat','-struct','reS2')
end
if ~isempty(stimTimeS5)
    reS5 = stim2;
    reS5.times = stimTimeS5;
    reS5.level = ones(size(stimTimeS5));
    reS5.length = length(stimTimeS5);
    save('reS25.mat','-struct','reS5')
end
if ~isempty(stimTimeS1)
    sSStimTime = [stimTimeS0;stimTimeS05;stimTimeS1;stimTimeS2;stimTimeS5];
    sSCue = stim2;
    sSCue.times = sSStimTime;
    sSCue.level = ones(size(sSStimTime));
    sSCue.length = length(sSStimTime);
    save('sSCue2.mat','-struct','sSCue')
end
end
