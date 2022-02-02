function  nY = modData(Y)
%  Fills the nr. of data points in each sweep to be a factor of 2.
%  You should set samples, prefill and postfill.
%  Samples + prefill + postfill should be a factor of 2.
pow=nextpow2(length(Y));
fSamples = 2^pow;
% fSamples = 512;
if mod(size(Y,2),2) == 0
    el = floor((fSamples - size(Y,2))/2);
    nY = [];
    for i = 1:size(Y,1)
        tmp = wextend('1','sp1',Y(i,:),el);
        nY = [nY;tmp];
    end
else
    el = floor((fSamples - size(Y,2))/2);
    prefill = zeros(size(Y,1),el + 1);
    postfill = zeros(size(Y,1),el);
    nY = [prefill Y postfill];
end
