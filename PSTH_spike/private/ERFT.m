function [relia lsi coeff p Indiff] = ERFT(stim,resp,stimBWin,wn,dt)
% last modified 16-Dec-2012
% Deal with the WaveMarker data expoted by Spike2
% ERFT   event related field test.
%   [relia lsi coeff p Indiff] = LEST(stim,resp,stimBWin,wn,dt)

%   of Jensen-Shannon divergence (see Endres and Schindelin, 2003) for
%   spike latency histograms.
%
%   Input arguments:
%       stim - event stimulus mat file exported from spike2
%       resp - WaveMarker mat file exported from spike2
%       stimBwin - bing window event stimulus mat file exported from spike2
%       dt - Time resolution of the discretized spike rasters in seconds.
%       wn - Window size for baseline and test windows in seconds
%           (optional; default, 0.001 s).
%
%   Output arguments:
%       relia - light evoked spike reliability
%       lsi - putative light evoked latency
%       coeff - coefficient of light evoked spike shape and baseline spike shape
%       p - Resulting P value for the light evoked spike latency test
%       Indiff - Test statistic, difference between within baseline and 
%           test-to-baseline information distance values. 
%
%   Briefly, the baseline binned spike rasters (SPT_BASELINE) is cut to 
%   non-overlapping epochs (window size determined by WN) and spike latency
%   histograms for first spikes is computed within each epoch. A similar
%   histogram is constructed for the test epoch (SPT_TEST). Pairwise
%   information distance measures are calculated for the baseline
%   histograms to form a null-hypothesis distribution of distances. The
%   distances of the test histogram and all baseline histograms is
%   calculated and the median of these values is tested against the
%   null-hypothesis distribution, resulting in a p value (P).
%
%   Reference:
%   Endres DM, Schindelin JE (2003) A new metric for probability
%   distributions. IEEE Transactions on Information Theory 49:1858-1860.
%
%   See also JSDIV.
%
%   Please cite:
%
%   D. Kvitsiani*, S. Ranade*, B. Hangya, H. Taniguchi, J. Z. Huang & A. Kepecs (2013)
%   Dstinct behavioural and network correlates of two interneuron types in prefrontal cortex
%   Nature (in press)
%
%   Balazs Hangya, Cold Spring Harbor Laboratory
%   1 Bungtown Road, Cold Spring Harbor
%   balazs.cshl@gmail.com
%   16-Dec-2012
% Input argument check
if nargin < 5
    wn = 0.008;   % window size in s
    dt = 0.0001;
    if nargin == 2
        stimBWin = stim;
    end
end
wn = wn * 1000;   % convert window size to ms
dt = dt * 1000;   % convert time resolution of bin raster to ms
stimTIdx = find(stim.level);
if isempty(stimTIdx)
    disp('No stimulus!')
    return
end
stimTime = stim.times(stimTIdx)*1000; % stimTime with unit ms
respTime = resp.times*1000;
stimNum = size(stimTIdx,1);
stimBWinIdx = find(stimBWin.level);
if isempty(stimBWinIdx)
    disp('No Stimulus Window!')
    return
end
stimBWinTime = stimBWin.times(stimBWinIdx)*1000;
stimBWinNum = size(stimBWinTime,1);
bt = wn*1000;% 1000 times baseline window to process
swnn = floor(bt/wn);
nmbn = round(wn/dt);   % number of bins for latency histograms
preStimInfo.latency = zeros(stimBWinNum,swnn);
postStimInfo.latency = zeros(stimNum,2);
preStimInfo.values = [];
postStimInfo.values = [];
preStimInfo.values2 = [];
postStimInfo.values2 = [];

for cStimBWinNum = 1:1:stimBWinNum
    cBWinM = stimBWinTime(cStimBWinNum)-bt;
    cBWinP = stimBWinTime(cStimBWinNum);
    for k = 0:1:(swnn-1)
        cwnl = cBWinM + k*wn; % current negative limit
        base = respTime< cwnl+wn & respTime>cwnl;
        preStimIdx = find(base, 1, 'first');
        if ~isempty(preStimIdx)
            preStimInfo.latency(cStimBWinNum,k+1) =  respTime(preStimIdx)-cwnl;
            preStimInfo.values= [preStimInfo.values; resp.values(preStimIdx,:,:)];
        end      
    end      
end

for cStim = 1:1:stimNum
    cWnP = stimTime(cStim)+wn;
    post = respTime> stimTime(cStim) & respTime< cWnP;
    postStimIdx = find(post,2,'first');
    if ~isempty(postStimIdx)
        switch size(postStimIdx,1)
            case 1
                postLatency = respTime(postStimIdx)-stimTime(cStim);
                postStimInfo.latency(cStim,1) = postLatency;
                postStimInfo.values = [postStimInfo.values;resp.values(postStimIdx,:,:)];
            case 2
                postLatency = respTime(postStimIdx)-stimTime(cStim);
                postStimInfo.latency(cStim,:) = postLatency;
                postStimInfo.values = [postStimInfo.values;resp.values(postStimIdx(1),:,:)];
                postStimInfo.values2 = [postStimInfo.values2;resp.values(postStimIdx(2),:,:)];
        end
    end
end
edges = 0:nmbn+1;  % bin boundaries
sPreLsi = sort(preStimInfo.latency,1);
tmpPreLsiHst = hist(sPreLsi,edges);
preLsiHst = tmpPreLsiHst;%(1:end-1,:);
nPreLsiHst = zeros(size(preLsiHst,1),size(preLsiHst,2));
for next = 1:1:swnn
    nPreLsiHst(:,next) = preLsiHst(:,next)/sum(preLsiHst(:,next));
end
sPostLsi = sort(postStimInfo.latency,1);
tmpPostLsiHst = hist(sPostLsi,edges);
postLsiHst = tmpPostLsiHst;%(1:end-1,:);
nPostLsiHst = zeros(size(postLsiHst,1),size(postLsiHst,2));
for next = 1:1:2
    nPostLsiHst(:,next) = postLsiHst(:,next)/sum(postLsiHst(:,next));
end
nhlsi = [nPreLsiHst nPostLsiHst(:,1)];
% JS-divergence
kn = swnn + 1;   % number of all windows (nm baseline win. + 1 test win.)
jsd = nan(kn,kn);
for k1 = 1:kn
    D1 = nhlsi(:,k1);  % 1st latency histogram 
    for k2 = (k1+1):kn
        D2 = nhlsi(:,k2);   % 2nd latency histogram
        jsd(k1,k2) = sqrt(JSdiv(D1,D2)*2);  % pairwise modified JS-divergence (real metric!)
    end
end

% Calculate p-value and information difference
[p1 Indiff1] = makep(jsd,kn);
% 
nhlsi = [nPreLsiHst nPostLsiHst(:,2)];
% JS-divergence
kn = swnn + 1;   % number of all windows (nm baseline win. + 1 test win.)
jsd = nan(kn,kn);
for k1 = 1:kn
    D1 = nhlsi(:,k1);  % 1st latency histogram 
    for k2 = (k1+1):kn
        D2 = nhlsi(:,k2);   % 2nd latency histogram
        jsd(k1,k2) = sqrt(JSdiv(D1,D2)*2);  % pairwise modified JS-divergence (real metric!)
    end
end

% Calculate p-value and information difference
[p2 Indiff2] = makep(jsd,kn);
p = [p1 p2];
Indiff = [Indiff1 Indiff2];



relia(1) = length(find(postStimInfo.latency(:,1)))/stimNum;
relia(2) = length(find(postStimInfo.latency(:,2)))/stimNum;
lsi(1) = sum(postStimInfo.latency(:,1))/length(find(postStimInfo.latency(:,1)));
lsi(2) = sum(postStimInfo.latency(:,2))/length(find(postStimInfo.latency(:,2)));
figure
plot(mean(nPreLsiHst,2),'k','LineWidth',3);
hold on 
plot(nPostLsiHst(:,1),'b','LineWidth',3);
% plot(nPostLsiHst(:,2),'b');
set(gca,'xlim',[0 10]);
hold off
avPreSpike = mean(preStimInfo.values,1);
avPostSpike = mean(postStimInfo.values,1);
avPostSpike2 = mean(postStimInfo.values2,1);
coeff1 = [];coeff2 = [];
chNum = size(avPreSpike,3);
if ~isempty(avPostSpike)
    for i = 1:chNum
        coeff1(i) = xcorr(avPreSpike(1,:,i),avPostSpike(1,:,i),0,'coeff')
    end      
end
if ~isempty(avPostSpike2)
    for i = 1:chNum
        coeff2(i) = xcorr(avPreSpike(1,:,i),avPostSpike2(1,:,i),0,'coeff');
    end
end
coeff = [mean(coeff1) mean(coeff2)];
fprintf('R=%.4f,L=%.4f,C=%.4f,p=%.4f',relia(1), lsi(1),coeff(1),p(1));

figure
hold on
Frq = 1/25000*1000;
timepoints = size(avPreSpike(1,:,1),2);
for i = 1:1:chNum
    x = ((i-1)*timepoints:1:(timepoints*i -1))*Frq;
    plot(x,avPreSpike(1,:,i),'k','LineWidth',3)
    if ~isempty(avPostSpike)
        plot(x,avPostSpike(1,:,i),'b','LineWidth',3)
    end
end

% if ~isempty(avPostSpike2)
%    plot(x,avPostSpike2(1,:,1),'b')
% end
box on
xlabel('Time(ms)','FontSize',25,'FontWeight','Bold');
ylabel('Amp.(mV)','FontSize',25,'FontWeight','Bold');
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
hold off







    
function [p_value Idiff] = makep(kld,kn)
% Calculates p value from distance matrix.
pnhk = kld(1:kn-1,1:kn-1);
nullhypkld = pnhk(~isnan(pnhk));   % nullhypothesis
testkld = median(kld(1:kn-1,kn));  % value to test
sno = length(nullhypkld(:));   % sample size for nullhyp. distribution
p_value = double(length(find(nullhypkld>=testkld)) / sno);
Idiff = testkld - median(nullhypkld);   % information difference between baseline and test latencies

% -------------------------------------------------------------------------
function D = JSdiv(P,Q)
%JSDIV   Jensen-Shannon divergence.
%   D = JSDIV(P,Q) calculates the Jensen-Shannon divergence of the two 
%   input distributions.

% Input argument check
error(nargchk(2,2,nargin))
if abs(sum(P(:))-1) > 0.00001 || abs(sum(Q(:))-1) > 0.00001
    error('Input arguments must be probability distributions.')
end
if ~isequal(size(P),size(Q))
    error('Input distributions must be of the same size.')
end

% JS-divergence
M = (P + Q) / 2;
D1 = KLdist(P,M);
D2 = KLdist(Q,M);
D = (D1 + D2) / 2;

% -------------------------------------------------------------------------
function D = KLdist(P,Q)
%KLDIST   Kullbach-Leibler distance.
%   D = KLDIST(P,Q) calculates the Kullbach-Leibler distance (information
%   divergence) of the two input distributions.

% Input argument check
error(nargchk(2,2,nargin))
if abs(sum(P(:))-1) > 0.00001 || abs(sum(Q(:))-1) > 0.00001
    error('Input arguments must be probability distributions.')
end
if ~isequal(size(P),size(Q))
    error('Input distributions must be of the same size.')
end

% KL-distance
P2 = P(P.*Q>0);     % restrict to the common support
Q2 = Q(P.*Q>0);
P2 = P2 / sum(P2);  % renormalize
Q2 = Q2 / sum(Q2);

D = sum(P2.*log2(P2./Q2));
    