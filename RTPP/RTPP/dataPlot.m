function dataPlot(vData)
centroids = vData.centroids;
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
bwMousePos = zeros(vData.vidHeight,vData.vidWidth);
iPos1InTime=0;iPos1OutSpeed=[];
iPos1InNum=0;iPos1InSpeed=[];
iPos1State = false(length(centroids),1);

iPos2InTime=0;iPos2OutSpeed=[];
iPos2InNum=0;iPos2InSpeed=[];
iPos2State = false(length(centroids),1);
iPosMState = false(length(centroids),1);
k = 1;    
while (k < length(centroids))
    % stimRange ROI analysis
    bwMousePos(centroids(k,2),centroids(k,1))= bwMousePos(centroids(k,2),centroids(k,1)) + 1;
    if vData.bwIPos1(centroids(k,2),centroids(k,1)) 
       iPos1State(k) = 1;
       %if ~bwRefROI(centroids(k-1,2),centroids(k-1,1))
       iPos1InNum = iPos1InNum+1;
       iPos1InTime = iPos1InTime+1;
       if k == 1
            iPos1InSpeed=[];
       else
            iPos1InSpeed = [iPos1InSpeed; speedT(k-1)];
       end
                
       while (k+1)<=length(centroids) & vData.bwIPos1(centroids(k+1,2),centroids(k+1,1))
                k=k+1; 
                iPos1InTime = iPos1InTime+1;
                iPos1State(k) = 1;
                if k == length(centroids)
                    break
                end
       end
                
       if (k+1)<=length(centroids)
            iPos1OutSpeed = [iPos1OutSpeed;speedT(k)];
       end
    end
                %end;end
    if vData.bwIPos2(centroids(k,2),centroids(k,1))
       iPos2State(k) = 1;
       %if ~bwRefROI(centroids(k-1,2),centroids(k-1,1))
       iPos2InNum = iPos2InNum+1;
       iPos2InTime = iPos2InTime+1;
       if k == 1
            iPos2InSpeed=[];
       else
            iPos2InSpeed = [iPos2InSpeed; speedT(k-1)];
       end
                
       while (k+1)<=length(centroids) & vData.bwIPos2(centroids(k,2),centroids(k,1))
                k=k+1; 
                iPos2InTime = iPos2InTime+1;
                iPos2State(k) = 1;
                if k == length(centroids)
                    break
                end
       end
                
       if (k+1)<=length(centroids)
            iPos2OutSpeed = [iPos2OutSpeed;speedT(k)];
       end
            
    end
    
    k=k+1;
end

iPos1InTime = iPos1InTime/vData.perSecondReadFrames;
ppm = vData.ppm;% pixels per mm
avgiPos1InSpeed=mean(iPos1InSpeed)*vData.perSecondReadFrames/ppm;
avgiPos1OutSpeed=mean(iPos1OutSpeed)*vData.perSecondReadFrames/ppm;

iPos2InTime = iPos2InTime/vData.perSecondReadFrames;
avgiPos2InSpeed=mean(iPos2InSpeed)*vData.perSecondReadFrames/ppm;
avgiPos2OutSpeed=mean(iPos2OutSpeed)*vData.perSecondReadFrames/ppm;

speed = speedT/ppm;
% mobile state
immobNum=0; immobTime = 0;
hmobNum=0; hmobTime = 0;
immobState = zeros(length(speed),1);
hmobState = zeros(length(speed),1);
threL = 1; % less than 1mm/s  is considered immobility
threH = 250; %  more than 100mm/s is considered high mobile
k = 1;    
while (k < (length(speed)-1))
    
    if speed(k) < threL & speed(k+1) < threL
       immobState(k) = 1;
       immobNum = immobNum+1;
       immobTime = immobTime+1;
                
       while ((k+1)<(length(speed)-1) & (speed(k+1) < threL))  
            k=k+1;
            immobState(k) = 1;
            immobTime = immobTime+1;
       end
    end
    
    if speed(k) > threH & speed(k+1) > threH
        hmobState(k) = 1;
        hmobNum = hmobNum+1;
        hmobTime = hmobTime+1;
                
         while ((k+1)<(length(speed)-1) & (speed(k+1) > threH))
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
axis ij
set(gca,'YTick',[],...
    'YTickLabel','off',...
    'XTick',[],... 
    'XTickLabel',{});
box on;

rectangle ('position', vData.iPos1, 'linewidth', 2, 'EdgeColor', [1 0 1]);
rectangle ('position', vData.iPos2, 'linewidth', 2, 'EdgeColor', [1 0 1]);
% title('Mouse Trajectory')
title(strrep(vData.filename(1:end-4), '\', '\\'));


% creat surf plot 6*6 grid
rdim = ones(floor(vData.vidHeight/6),1)*6;
cdim = ones(floor(vData.vidWidth/8),1)*8;
c = mat2cell(bwMousePos,rdim,cdim);
density = cellfun(@(x) sum(sum(x)), c);
%HeatMap(density);
% Create surf
[X,Y] = meshgrid((1:vData.vidWidth/8)*8,(1:vData.vidHeight/6)*6);                                
Z = density/vData.perSecondReadFrames;

%%%%%%%%%%%%%%%%%%%%%%%%%%
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
% title('Track Density Map (s)');


%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,2,3)

y = iPos1State(:);
y = y+1;
x = (1:1:length(iPos1State))/vData.perSecondReadFrames;
stairs(x,y,'r');
hold on

y = vData.stimTag+3;
%x = 1:1:length(y);
stairs(x,y,'r');
y = iPos2State(:) +5;
%x = 1:1:length(y);
stairs(x,y,'r');

iPosMState = ~(iPos1State | iPos2State);
y = iPosMState(:) +7;
stairs(x,y,'r');

y = immobState(:)+9;
%x = 1:1:length(y);
stairs(x,y,'r');

y = hmobState(:)+1;
%x = 1:1:length(y);
stairs(x,y,'r');


hold off
set(gca,'YLim',[0 13],'YTick',[1.5 3.5 5.5 7.5 9.5 11.5],'YTickLabel','ROI1|stimTag|ROI2|ROIM|Freeze|Hmobile');
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
vData.iPos1InNum = iPos1InNum;
vData.iPos1InTime = iPos1InTime;
vData.iPos2InNum = iPos2InNum;
vData.iPos2InTime = iPos2InTime;
vData.iPos1InSpeed = iPos1InSpeed;
vData.iPos1OutSpeed = iPos1OutSpeed;
vData.iPos2InSpeed = iPos2InSpeed;
vData.avgiPos1InSpeed = avgiPos1InSpeed;
vData.avgiPos1OutSpeed = avgiPos1OutSpeed;
vData.iPos1State = iPos1State;
vData.avgiPos2InSpeed = avgiPos2InSpeed;
vData.avgiPos2OutSpeed = avgiPos2OutSpeed;
vData.iPos1State = iPos1State;
vData.iPos2State = iPos2State;
vData.iPosMState = iPosMState;
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
res = {'','iPos1State','iPos2State','immobileState','highMobileState','tureDist';...
       'Number',iPos1InNum,iPos2InNum,immobNum,hmobNum,trueDist;...
       'Time',iPos1InTime,iPos2InTime,immobTime,hmobTime,'mm'};
vData.res = res;
res

matFileName = strrep(vData.filename, '.log', '.mat');   
%[pathstr, name, ext] = fileparts(vData.filename);
%txtoutput = [name '.log'];
fid = fopen(vData.filename, 'w');
fprintf(fid,'iPos1Time iPos2Time trueDist\n %.1f %.1f %.1f %.1f\n',iPos1InTime,iPos2InTime,trueDist);
fclose(fid);
%matoutput = [name '.mat'];
save(matFileName,'-struct', 'vData');
figFileName = strrep(vData.filename, '.log', '.fig');
%print(gcf, '-djpeg', datFileName)
saveas(gcf, figFileName, 'fig'); 


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