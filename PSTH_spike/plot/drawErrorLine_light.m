function drawErrorLine_light(x,y,error,facecolor,errorcolor)
if ischar(facecolor)
    facecolor = rem(floor((strfind('kbgcrmyw', facecolor) - 1) * [0.25 0.5 1]), 2);
end
errorcolor = facecolor*0.3 + [0.7 0.7 0.7];
% errorcolor = facecolor*0.2;
x = x(:)';
y = y(:)';
error = error(:)';

x1 = x;
x2 = fliplr(x);

y1 = y - error;
y2 = fliplr(y + error);

patch([x1 x2],[y1 y2],errorcolor,'FaceAlpha',0.6,'EdgeColor','none');
hold on;
plot(x,y,'color',facecolor,'LineWidth',3);
% plot(x,y,'color',facecolor,'EraseMode','xor','LineWidth',3);