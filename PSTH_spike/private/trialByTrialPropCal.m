function trialByTrialPropCal(vData)
% change cArea to cAreaPks
stimNum = vData.stimNum;
deciR = 10;
step = vData.resp1.interval*deciR;
xMin = min(vData.mERF(1,:));
xMax = max(vData.mERF(1,:));
x = xMin:step:xMax;
% eval(['vData.nERF',int2str(cStimIdx),'= modData(vData.ERF',int2str(cStimIdx),');'])
nx = modData(x); % resample x
sc = 5;
vData.deciR = deciR;
vData.nx = nx;
% vData.xMin = xMin;
% vData.xMax = xMax;
vData.sc = sc;
vData.step = step;
for cStimIdx = 1:1:stimNum% for multiple stim
    denCDiff = [];
    cLatAmpDiff = [];
    cAreaPks = []; 
    eval(['totalTrials = size(vData.ERF',int2str(cStimIdx),');']);
    eval(['normC = max(mean(vData.ERF',int2str(cStimIdx),'(1:50,:)));']);%for SERT
    %eval(['normC = max([mean(vData.ERF',int2str(cStimIdx),'(1:50,1001:2500)),0]) + max(mean(vData.ERF',int2str(cStimIdx),'(1:50,2501:3500)));']);% for DAT
    for trialID = 1:1:floor(totalTrials/10)+1% 10 trials per time last is the mean
        if trialID*10 <= totalTrials
            eval(['cTrial = vData.ERF',int2str(cStimIdx),'((trialID*10 -9):trialID*10,:);']);
            cTrial = mean(cTrial,1);
        else
            cTrial = vData.mERF(cStimIdx+1,:);
        end
        cTrial = decimate(cTrial,deciR);
        cTrial = cTrial./normC;% normalized trial data
        cDiff = diff(cTrial,1,2);
        cDiff = cDiff./step;
        ncDiff = modData(cDiff);% resample data
        cTrial = modData(cTrial);% resample data
        [coeff,denCTrial,denCoeff,~] = Run_NZT(nx,ncDiff,sc);
        denCDiff = [denCDiff;denCTrial];
        % postive peak of diff between 0-2s
        tmin = 0;tmax = 2;
        [incOnsetLat02,incOnsetAmp02,posMaxALat02,posMaxAAmp02] = posPeak(denCTrial,nx,tmin,tmax);
        % postive peak of diff between 3-5s
        tmin = 3;tmax = 5;
        [incOnsetLat35,incOnsetAmp35,posMaxALat35,posMaxAAmp35] = posPeak(denCTrial,nx,tmin,tmax);
        % negative diff peak between 3-5s
        [decOnsetLat,decOnsetAmp,negMaxALat,negMaxAAmp] = negPeak(denCTrial,nx,tmin,tmax);
        cLatAmpDiff = [cLatAmpDiff;incOnsetLat02,incOnsetAmp02,posMaxALat02,posMaxAAmp02,incOnsetLat35,incOnsetAmp35,posMaxALat35,posMaxAAmp35,decOnsetLat,decOnsetAmp,negMaxALat,negMaxAAmp];
        % sum of normalized data between 0 and 4 s
        tmin = 0;tmax = 3;
        idxMin = find(nx == tmin);
        idxMax = find(nx == tmax);
        cArea03 = sum(cTrial(idxMin:idxMax))*step;
        [~,~,cPksLat03,cPksAmp03] = posPeak(cTrial,nx,tmin,tmax);
        tmin = 3;tmax = 5;
        idxMin = find(nx == tmin);
        idxMax = find(nx == tmax);
        cArea35 = sum(cTrial(idxMin:idxMax))*step;
        [~,~,cPksLat35,cPksAmp35] = posPeak(cTrial,nx,tmin,tmax);
        cArea5e = sum(cTrial(idxMax:end))*step;
        cAreaPks = [cAreaPks; cArea03 cArea35 cArea5e sum(cTrial)*step cPksLat03 cPksAmp03 cPksLat35 cPksAmp35];% sum(dF*dt)
    end    
    allDenDiff(:,:,cStimIdx) = denCDiff;
    allLatAmpDiff(:,:,cStimIdx) = cLatAmpDiff;
    allAreaPks(:,:,cStimIdx) = cAreaPks;
end
vData.allDenDiff = allDenDiff;
vData.allLatAmp = allLatAmpDiff;
vData.allAreaPks = allAreaPks;
assignin('base','Data',vData);
save('output.mat','-struct','vData')