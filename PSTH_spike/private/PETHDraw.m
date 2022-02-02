function [spikeCount,mPETH,base_spike,stim_spike] = PETHDraw(stim,resp,preTime,postTime,bin,i,delTrial,denoise,xp2)
figure;
hold on
colorOrder = [0,0,0;0.850,0.325,0.098;0,0.447,0.741;0.929,0.694,0.125;0.494,0.184,0.556;0.466,0.674,0.188;0.301,0.745,0.933;0.635,0.078,0.184];
cColor = colorOrder(i,:);
spikeTimes = resp.times;
% resp.values(1,:);
stimTimes = stim.times(logical(stim.level));
stimTimes0 = stim.times(~logical(stim.level));%%%%%%%%%%%%%%llh
% binranges = (-preTime ):bin:(postTime + 5*bin);
binranges = (-preTime):bin:(postTime);

if ~isnan(delTrial)
    stimTimes(delTrial) = [];
end

spikeCount = zeros(length(stimTimes),length(binranges));
relaSpikeTime0 = [];
base_spike=[];
stim_spike=[];
for i=1:length(stimTimes)
       cSpikes = spikeTimes >= stimTimes(i) - preTime & spikeTimes <= stimTimes(i) + postTime;
       %%%%20210819 added by llh 
       baseSpikes = spikeTimes >= stimTimes(i) - preTime & spikeTimes <= stimTimes(i);
        stimSpikes = spikeTimes >= stimTimes(i) & spikeTimes <= stimTimes(i) + xp2;
        temp1 = resp.values(baseSpikes,:);
        temp2 = resp.values(stimSpikes,:);
        temp3 = resp.values(cSpikes,:);
        base_spike=[base_spike;temp1];
        stim_spike=[stim_spike;temp2];
       
       relaSpikeTime = spikeTimes(cSpikes)-stimTimes(i);
       %%%%20210819 added by llh       
       relaSpikeTime0 = [relaSpikeTime0;relaSpikeTime];
       if denoise    
%            disp('delete capacitance noise');
            [M noise1] = min(abs(relaSpikeTime-0)); 
            if max(temp3(noise1,:)) > mean(max(temp3))
                i;
                relaSpikeTime(noise1) = [];
            end
            [M noise2] = min(abs(relaSpikeTime-0.2)); 
            if min(temp3(noise2,:)) < mean(min(temp3))
                relaSpikeTime(noise2) = [];
            end
            assignin('base','temp3',temp3);
%             assignin('base','noise2',noise2);
        end
        
       stem_handle = stem(relaSpikeTime,i+ones(length(relaSpikeTime),1)*0.8,...
               'BaseValue',i,'color',cColor,'marker','none','linewidth',2);
       spikeCount(i,:) = histc(relaSpikeTime,binranges)';
end
spikeCount = spikeCount(:,1:end - 1);
mPETH = mean(spikeCount)/bin;%for PSTH bar plot
assignin('base','spikeCount',spikeCount);
assignin('base','relaSpikeTime0',relaSpikeTime0);
assignin('base','base_spike',base_spike);
assignin('base','stim_spike',stim_spike);


baseline_handle = get(stem_handle,'BaseLine');
set(baseline_handle,'LineStyle','none')
%set(gca,'visible', 'off');

box on
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out','xlim',[-preTime postTime])%'xcolor',[0.8 0.8 0.8],'ycolor',[0.8 0.8 0.8])
% set('ylim',[0 length(stimTimes) + 0.8 + 1],'xtick',[],'ytick',[1 length(stimTimes)])
% set(gca,'ylim',[0 size(spikeCount,1) + 0.8 + 1],'xtick',[],'ytick',[1 size(spikeCount,1)])
set(gca,'ylim',[0 size(spikeCount,1) + 0.8 + 1],'ytick',[1 size(spikeCount,1)])
xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
ylabel('Trial #','FontName','Arial','FontSize',25,'FontWeight','Bold');
hold off



