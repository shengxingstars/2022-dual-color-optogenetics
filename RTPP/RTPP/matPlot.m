function matPlot(vData)
centroids = vData.centroids;
elipMouse = vData.elipMouse;
% caculate speed & update centroids
tmpCentroids = centroids(2:length(centroids),:);
tmpCentroids = [tmpCentroids;centroids(length(centroids),:)];
diff = tmpCentroids-centroids;% the last one is 0
dist = diff(:,1).*diff(:,1)+diff(:,2).*diff(:,2);
speedT = sqrt(dist(:));
%meanspeed = mean(speedF);

% caculate total distance
totalDist = sum(speedT);
avgSpeed = totalDist/vData.testTime;


%Total time in ROI

centroids = uint16(centroids);
% wBox = vData.boxPos(3);
% hBox = vData.boxPos(4);
% bwMousePos = false(hBox,wBox);
bwMousePos = false(vData.vidHeight,vData.vidWidth);
stimRangeInTime=0;stimRangeOutSpeed=[];
stimRangeInNum=0;stimRangeInSpeed=[];
stimRangeState = zeros(length(centroids),1);
k = 1;    
while (k <= length(centroids))
    % stimRange ROI analysis
    bwMousePos(centroids(k,2),centroids(k,1))=1;
    if vData.bwStimRange(centroids(k,2),centroids(k,1)) 
       stimRangeState(k) = 1;
       %if ~bwRefROI(centroids(k-1,2),centroids(k-1,1))
       stimRangeInNum = stimRangeInNum+1;
       stimRangeInTime = stimRangeInTime+1;
       if k == 1
            stimRangeInSpeed=[];
       else
            stimRangeInSpeed = [stimRangeInSpeed; speedT(k-1)];
       end
                
       while ((k+1)<=length(centroids) & vData.bwStimRange(centroids(k+1,2),centroids(k+1,1)))
            k=k+1; 
            stimRangeInTime = stimRangeInTime+1;
            stimRangeState(k) = 1;
       end
                
       if (k+1)<=length(centroids)
            stimRangeOutSpeed = [stimRangeOutSpeed;speedT(k)];
       end
                %end;end        
    end
    
    k=k+1;
end

stimRangeInTime = stimRangeInTime/vData.perSecondReadFrames;
ppm = vData.ppm;% pixels per mm
avgCerterInSpeed=mean(stimRangeInSpeed)*vData.perSecondReadFrames/ppm;
avgstimRangeOutSpeed=mean(stimRangeOutSpeed)*vData.perSecondReadFrames/ppm;
% avgCornerInSpeed=mean(cornerInSpeed);
% avgCornerOutSpeed=mean(cornerOutSpeed);

% body state
streNum=0; streTime = 0;
% groNum=0; groTime = 0;
%timePerPoint = 1;
% bLength = modData(vData,elipMouse(:,2),timePerPoint,1);
bLength = elipMouse(:,2);
%speed = modData(vData,speedT,timePerPoint,0)/ppm;
speed = speedT*vData.perSecondReadFrames/ppm;
%bLength = elipMouse(:,1);
streState = zeros(length(bLength),1);
% groState = zeros(length(bLength),1);
bthreH = mean(bLength)*1.30;% 30% more than mean body length is considered stretch-attended behavior
% bthreL = mean(bLength)*0.75;% 25% less than mean body length & immobile is considered grooming or roarming
k = 1;    
while (k <= length(bLength))
    
    % stretch analysis
    if bLength(k) > bthreH & bLength(k+1) > bthreH
       streState(k) = 1;
       streNum = streNum+1;
       streTime = streTime+1;
                
       while ((k+1)<=length(bLength) & (bLength(k+1) > bthreH))
            k=k+1; 
            streTime = streTime+1;
            streState(k) = 1;
       end
%     else if bLength(k) < bthreL
%             if speed(k)> threL
%                 groState(k) = 1;
%                 groNum = groNum+1;
%                 groTime = groTime+1;
%             end
%             while ((k+1)<=length(bLength) & (bLength(k+1) < bthreL))
%                     k=k+1;
%                     if speed(k)> threL
%                         groTime = groTime+1;
%                         groState(k) = 1;
%                     end
%             end
%           end       

    end
    
    k=k+1;
end
streTime = streTime/vData.perSecondReadFrames;


% mobile state
immobNum=0; immobTime = 0;
hmobNum=0; hmobTime = 0;
immobState = zeros(length(speed),1);
hmobState = zeros(length(speed),1);
threL = 1; % less than 5mm/s  is considered immobility
threH = 200; %  more than 100mm/s is considered high mobile
k = 1;    
while (k <= (length(speed)-1))
    
    if speed(k) < threL & speed(k+1) < threL
       immobState(k) = 1;
       immobNum = immobNum+1;
       immobTime = immobTime+1;
                
       while ((k+1)<=(length(speed)-1) & (speed(k+1) < threL))  
            k=k+1;
            immobState(k) = 1;
            immobTime = immobTime+1;
       end
    end
    
    if speed(k) > threH & speed(k+1) > threH
        hmobState(k) = 1;
        hmobNum = hmobNum+1;
        hmobTime = hmobTime+1;
                
         while ((k+1)<=(length(speed)-1) & (speed(k+1) > threH))
             k=k+1;
             hmobState(k) = 1;
             hmobTime = hmobTime+1;
         end  
    end
    
    k=k+1;
end
immobTime = immobTime/vData.perSecondReadFrames;
hmobTime = hmobTime/vData.perSecondReadFrames;
% groTime = groTime/vData.perSecondReadFrames;

%%
figure;
subplot(2,2,1);
plot(centroids(:,1),centroids(:,2),'b-');
%hold on 
%pos = [vData.boxPos(1),vData.boxPos(3), 288, 216];
%rectangle('Position',pos,'EdgeColor','r');
%hold off
ylim(gca,[0 vData.vidHeight]);
xlim(gca,[0 vData.vidWidth]);
axis ij
set(gca,'YTick',[],...
    'YTickLabel','off',...
    'XTick',[],... 
    'XTickLabel',{});
box on;
rectangle ('position', vData.stimPos, 'linewidth', 2, 'EdgeColor', [1 0 0]);
rectangle ('position', vData.boxPos, 'linewidth', 2, 'EdgeColor', 'k');
title('Mouse Trajectory')



% creat surf plot 6*6 grid
rdim = ones(floor(vData.vidHeight/6),1)*6;
cdim = ones(floor(vData.vidWidth/8),1)*8;
c = mat2cell(bwMousePos,rdim,cdim);
density = cellfun(@(x) sum(sum(x)), c);
%HeatMap(density);
% Create surf
[X,Y] = meshgrid((1:vData.vidWidth/8)*8,(1:vData.vidHeight/6)*6);                                
Z = density/vData.perSecondReadFrames;
subplot(2,2,2)
cmap = [0.862745106220245 0.862745106220245 0.862745106220245;0.882352948188782 0.882352948188782 0.739495813846588;0.901960790157318 0.901960790157318 0.616246521472931;0.921568632125854 0.921568632125854 0.492997199296951;0.941176474094391 0.941176474094391 0.369747906923294;0.960784316062927 0.960784316062927 0.246498599648476;0.980392158031464 0.980392158031464 0.123249299824238;1 1 0;0.998677253723145 0.952380955219269 0;0.997354507446289 0.904761910438538 0;0.996031761169434 0.857142865657806 0;0.994709014892578 0.809523820877075 0;0.993386268615723 0.761904776096344 0;0.992063462734222 0.714285731315613 0;0.990740716457367 0.666666686534882 0;0.989417970180511 0.61904764175415 0;0.988095223903656 0.571428596973419 0;0.986772477626801 0.523809552192688 0;0.985449731349945 0.476190477609634 0;0.98412698507309 0.428571432828903 0;0.982804238796234 0.380952388048172 0;0.981481492519379 0.333333343267441 0;0.980158746242523 0.28571429848671 0;0.978835940361023 0.238095238804817 0;0.977513194084167 0.190476194024086 0;0.976190447807312 0.142857149243355 0;0.974867701530457 0.095238097012043 0;0.973544955253601 0.0476190485060215 0;0.972222208976746 0 0;0.944444417953491 0 0;0.916666626930237 0 0;0.888888895511627 0 0;0.861111104488373 0 0;0.833333313465118 0 0;0.805555522441864 0 0;0.777777791023254 0 0;0.75 0 0;0.722222208976746 0 0;0.694444417953491 0 0;0.666666686534882 0 0;0.638888895511627 0 0;0.611111104488373 0 0;0.583333313465118 0 0;0.555555522441864 0 0;0.527777791023254 0 0;0.5 0 0;0.472222208976746 0 0;0.444444447755814 0 0;0.416666656732559 0 0;0.388888895511627 0 0;0.361111104488373 0 0;0.333333343267441 0 0;0.305555552244186 0 0;0.277777761220932 0 0;0.25 0 0;0.222222223877907 0 0;0.194444447755814 0 0;0.16666667163372 0 0;0.138888880610466 0 0;0.111111111938953 0 0;0.0833333358168602 0 0;0.0555555559694767 0 0;0.0277777779847384 0 0;0 0 0];
colormap (gca,cmap);
surf(X,Y,Z,'FaceColor','interp','EdgeColor','none');
ylim(gca,[0 vData.vidHeight]);
xlim(gca,[0 vData.vidWidth]);
view(3);
box on;
axis ij
% Create colorbar
colorbar('peer',gca);
% set axes properties
set(gca,'ZGrid','on',...
    'YTickLabel',{},...
    'YMinorTick','off',...
    'XTickLabel',{},...
    'XMinorTick','off');
 %'Color',[0.831372559070587 0.815686285495758 0.7843137383461],...
% plot ROI status
title('Track Density Map (s)')
subplot(2,2,3)
% timePerPoint = 1;
% y = modData(vData,cornerState(:),timePerPoint,0)>= threL;
% y = y +1;
% x = 1:1:length(y);
% stairs(x,y,'r');

y = stimRangeState(:);
y = y+1;
x = (1:1:length(stimRangeState))/vData.perSecondReadFrames;
stairs(x,y,'r');
hold on


if isempty(vData.stimTag) 
    vData.stimTag(1:length(stimRangeState)) = 0;
end
y = vData.stimTag(:) +3;
%x = 1:1:length(y);
stairs(x,y,'r');

y = streState(:)+5;
%x = 1:1:length(y);
stairs(x,y,'r');



y = immobState(:)+7;
%x = 1:1:length(y);
stairs(x,y,'r');

y = hmobState(:)+9;
%x = 1:1:length(y);
stairs(x,y,'r');


hold off
set(gca,'YLim',[0 11],'YTick',[1.5 3.5 5.5 7.5 9.5],'YTickLabel','stimROI|stimTag|Stretch|Freeze|Hmobile');
box on;
title('ROI & Mouse State')

% plot speed
subplot(2,2,4)
timePerPoint = 10;
len = floor(length(speedT)/ (vData.perSecondReadFrames*timePerPoint));% 10 s per point
x = (1:1:len)*timePerPoint;
tSpeed = speedT/ppm;
dist = modData(vData,tSpeed,timePerPoint,0);
plot(x,dist,'b-');
box(gca,'on');
title('Travel Distance (mm)')

trueDist = totalDist/ppm;

vData.speedT = speedT;
vData.dist = dist;
vData.trueDist = trueDist;
vData.totalDist = totalDist;
vData.avgSpeed = avgSpeed;
vData.bwMousePos = bwMousePos;
vData.stimRangeInNum = stimRangeInNum;
vData.stimRangeInTime = stimRangeInTime;
% vData.cornerInTime = cornerInTime;
vData.stimRangeInSpeed = stimRangeInSpeed;
vData.stimRangeOutSpeed = stimRangeOutSpeed;
% vData.cornerInSpeed = cornerInSpeed;
vData.avgCerterInSpeed = avgCerterInSpeed;
vData.avgstimRangeOutSpeed = avgstimRangeOutSpeed;
vData.stimRangeState = stimRangeState;
% vData.avgCornerInSpeed = avgCornerInSpeed;
% vData.avgCornerOutSpeed = avgCornerOutSpeed;
vData.streTime = streTime;
vData.streNum = streNum;
vData.streState = streState;
% vData.groTime = groTime;
% vData.groNum = groNum;
% vData.groState = groState;
vData.threL = threL;
vData.threH = threH;
vData.immobTime = immobTime;
vData.immobNum = immobNum;
vData.immobState = immobState;
vData.hmobTime = hmobTime;
vData.hmobNum = hmobNum;
vData.hmobState = hmobState;
res = {'','stimRangeState','stretchState','immobileState','highMobileState','tureDist';...
       'Number',stimRangeInNum,streNum,immobNum,hmobNum,trueDist;...
       'Time',stimRangeInTime,streTime,immobTime,hmobTime,'mm'};
vData.res = res;
res
trueDist

matFileName = strrep(vData.filename, 'dat', 'mat');   
%[pathstr, name, ext] = fileparts(vData.dataFile);
%txtoutput = [name '.txt'];
% fid = fopen(txtoutput, 'w');
% fprintf(fid,'Total Time in ROI: %.1f s\n Number of ROI Entry: %d\n Travel Distance: %.1f\n Speed into ROI: %.1f\n Speed Leaving ROI: %.1f\n',stimRangeInTime,stimRangeInNum,totalDist,avgCerterInSpeed,avgstimRangeOutSpeed);
%matoutput = [name '.mat'];
save(matFileName,'-struct', 'vData');
figFileName = strrep(vData.filename, 'dat', 'fig');
%print(gcf, '-djpeg', datFileName)
saveas(gcf, figFileName, 'fig'); 
xlsfilename = strrep(vData.filename, 'dat', 'xls');
xlswrite(xlsfilename, res, 1);

disp('well done!')

function outData = modData(vData,inData,timePerPoint,mTag)

len = floor(length(inData)/ (vData.perSecondReadFrames*timePerPoint));% s per point
outData = zeros(len,size(inData,2));
if mTag == 0 
    tmp = sum(inData(1:(vData.perSecondReadFrames*timePerPoint-1)));
    outData(1) = tmp; 
    for i = 2:floor(length(inData)/ (vData.perSecondReadFrames*timePerPoint))
        tmp = sum(inData((i-1)*vData.perSecondReadFrames*timePerPoint:((i*vData.perSecondReadFrames*timePerPoint)-1)));
        outData(i) = tmp;
    end
else if mTag ==1
    tmp = mean(inData(1:(vData.perSecondReadFrames*timePerPoint-1)));
    outData(1) = tmp; 
    for i = 2:floor(length(inData)/ (vData.perSecondReadFrames*timePerPoint))
        tmp = mean(inData((i-1)*vData.perSecondReadFrames*timePerPoint:((i*vData.perSecondReadFrames*timePerPoint)-1)));
        outData(i) = tmp;
    end  
    end
end