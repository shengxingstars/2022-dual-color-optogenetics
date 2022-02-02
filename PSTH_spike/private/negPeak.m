function [decOnsetLat,decOnsetAmp,negMaxALat,negMaxAAmp] = negPeak(cTrial,nx,tmin,tmax)
decOnsetLat = NaN;
decOnsetAmp = NaN;
negMaxALat = NaN;
negMaxAAmp = NaN;
idx0 = find(nx == 0);
negCTrial = - cTrial;
if isnan(tmin) & isnan(tmax)
    idxMin = 1;
    [pks,nLocs] = findpeaks(negCTrial,'minpeakdistance',5,'sortstr','descend');
else
    idxMin = find(nx == tmin);
    idxMax = find(nx == tmax);
    [pks,nLocs] = findpeaks(negCTrial(idxMin:idxMax),'minpeakdistance',5,'sortstr','descend');
    if isempty(nLocs)
        [pks,nLocs] =  max(negCTrial(idxMin:idxMax));
    end    
end
idx0sL = crossing(negCTrial(idxMin:nLocs(1) + idxMin));
if ~isempty(idx0sL)
    zeroIdxL = idx0sL(end);
    decOnsetLat = nx(zeroIdxL + idxMin) - nx(idx0);
    decOnsetAmp = cTrial(zeroIdxL + idxMin);
end
negMaxALat = nx(nLocs(1) + idxMin) - nx(idx0);
negMaxAAmp = cTrial(nLocs(1) + idxMin);

