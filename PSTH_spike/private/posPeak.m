function [incOnsetLat,incOnsetAmp,posMaxALat,posMaxAAmp] = posPeak(denCTrial,nx,tmin,tmax)
incOnsetLat = NaN;
incOnsetAmp = NaN;
posMaxALat = NaN;
posMaxAAmp = NaN;
idx0 = find(nx == 0);
if isnan(tmin) & isnan(tmax)
    idxMin = 1;
    [pks,pLocs] = findpeaks(denCTrial,'minpeakdistance',5,'sortstr','descend');
else
    idxMin = find(nx == tmin);
    idxMax = find(nx == tmax);
    [pks,pLocs] = findpeaks(denCTrial(idxMin:idxMax),'minpeakdistance',5,'sortstr','descend'); 
    if isempty(pLocs)
        [pks,pLocs] =  max(denCTrial(idxMin:idxMax));
    end    
end
idx0sL = crossing(denCTrial(idxMin:pLocs(1) + idxMin));
if ~isempty(idx0sL)
    zeroIdxL = idx0sL(end);
    incOnsetLat = nx(zeroIdxL + idxMin) - nx(idx0);
    incOnsetAmp = denCTrial(zeroIdxL + idxMin);
end
posMaxALat = nx(pLocs(1) + idxMin) - nx(idx0);
posMaxAAmp = denCTrial(pLocs(1) + idxMin);