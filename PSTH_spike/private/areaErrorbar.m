function areaErrorbar(x,data,i)
%20151130 modified areaErrorBar
X = [x,fliplr(x)];
colorOrder = [1,0,0;0,0,0;0,0.447,0.741;0.850,0.325,0.098;0.929,0.694,0.125;0.494,0.184,0.556;0.466,0.674,0.188;0.301,0.745,0.933;0.635,0.078,0.184];
%colorOrder = [0,0,1;0,0.5,0;1,0,0;0,0.75,0.75;0.75,0,0.75;0.,0.75,0;0.25,0.25,0.25];
cColor = colorOrder(i,:);
hold on 
if ~isempty(data) 
    y = data;
    mY = mean(y,1);
    semY = std(y,0,1)/sqrt(size(y,1));
    mYu = mY + semY;
    mYd = mY - semY;
    Y = [mYu, fliplr(mYd)];
    cFaceColor = cColor*0.3 + [0.7 0.7 0.7];
    % Create patch
    patch('YData',Y,...
          'XData',X,...
          'LineStyle','none',...
          'FaceColor',cFaceColor);
    plot(x,mY,'Color',cColor,'LineWidth',3)
end