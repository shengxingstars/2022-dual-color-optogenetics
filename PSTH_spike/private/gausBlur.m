function sData = gausBlur(data,win)    
sData = [];
windowWidth = int16(win);
halfWidth = windowWidth / 2;
gaussFilter = gausswin(win);
gaussFilter = gaussFilter / sum(gaussFilter); % Normalize.
for i = 1:1:size(data,1)
    % Do the blur.
    csData = conv(data(i,:), gaussFilter);
    sData = [sData;csData];
end
%sData = sData(halfWidth:end-halfWidth);