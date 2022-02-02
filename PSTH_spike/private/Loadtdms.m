function resp = Loadtdms(filename)
[ConvertedData,ConvertVer,ChanNames]=convertTDMS(0,filename); % load data from .tdms
switch length(ConvertedData.Data.MeasuredData)
    case 3
        % prepare resp
        resp.values = ConvertedData.Data.MeasuredData(3).Data; % GC6 data
        % time parameters 
        Fs = 500;
        interval = 1./Fs;
        times = (1:1:length(resp.values)).*interval;
        times = times';
        resp.title = 'GC6';
        resp.interval = interval;
        resp.times = times;
        save('GC6.mat','-struct','resp');
    case 6
        stimTag = zeros(3,1);% [cue cueOm pump]
        % prepare resp
        resp.values = ConvertedData.Data.MeasuredData(6).Data; % GC6 data
        % time parameters 
        Fs = 500;
        interval = 1./Fs;
        times = (1:1:length(resp.values)).*interval;
        times = times';
        resp.title = 'GC6';
        resp.interval = interval;
        resp.times = times;
        save('GC6.mat','-struct','resp');

        % prepare cue.mat
        rawCue = ConvertedData.Data.MeasuredData(3).Data; % cue channel
        dfRawCue = diff(rawCue);
        idx1 = find(dfRawCue==1) + 1;
        if ~isempty(idx1)
        idx0 = find(dfRawCue==-1);
        idx = sort([idx1;idx0]);
        cue.title = 'cue';
        cue.times = times(idx);
        cue.level = repmat([1;0],size(idx1));
        save('cue.mat','-struct','cue');
        stimTag(1) = 1;
        end

        % prepare cueOm.mat
        rawCueOm = ConvertedData.Data.MeasuredData(4).Data;% cueOm channel
        dfRawCueOm = diff(rawCueOm);
        idx1 = find(dfRawCueOm==1) + 1;
        if ~isempty(idx1)
        idx0 = find(dfRawCueOm==-1);
        idx = sort([idx1;idx0]);
        cueOm.title = 'cueOm';
        cueOm.times = times(idx);
        cueOm.level = repmat([1;0],size(idx1));
        save('cueOm.mat','-struct','cueOm');
        stimTag(2) = 1;
        end

        % prepare pump.mat
        rawPump = ConvertedData.Data.MeasuredData(5).Data;% pump channel
        dfRawPump = diff(rawPump);
        idx1 = find(dfRawPump==1) + 1;
        if ~isempty(idx1)
        idx0 = find(dfRawPump==-1);
        idx = sort([idx1;idx0]);
        pump.tittle = 'pump';
        pump.times = times(idx);
        pump.level = repmat([1;0],size(idx1));
        save('pump.mat','-struct','pump');
        stimTag(3) = 1;
        end
        if all(stimTag)
        rewardOmTag = length(cue.times) + length(cueOm.times) > length(pump.times);
        if rewardOmTag
            probRandStimMod(cue,cueOm,pump);
        end
        end
end