function varargout = RTPP(varargin)
% dio,diOut,obj in handles directly
% other data are in handles.data
% replace parallel with Arduino
% use text file to save data and also incread log file to detect error
% RTPP MATLAB code for RTPP.fig
%      RTPP, by itself, creates a new RTPP or raises the existing
%      singleton*.
%
%      H = RTPP returns the handle to a new RTPP or the handle to
%      the existing singleton*.
%
%      RTPP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RTPP.M with the given input arguments.
%
%      RTPP('Property','Value',...) creates a new RTPP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RTPP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RTPP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RTPP

% Last Modified by GUIDE v2.5 31-Jan-2022 21:33:02
% Add load push button to load refImg directly compared to version 2.718

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RTPP_OpeningFcn, ...
                   'gui_OutputFcn',  @RTPP_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before RTPP is made visible.
function RTPP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RTPP (see VARARGIN)

% Choose default command line output for RTPP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RTPP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RTPP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function testTime_edt_Callback(hObject, eventdata, handles)
% hObject    handle to testTime_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of testTime_edt as text
%        str2double(get(hObject,'String')) returns contents of testTime_edt as a double


% --- Executes during object creation, after setting all properties.
function testTime_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testTime_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function psrf_edt_Callback(hObject, eventdata, handles)
% hObject    handle to psrf_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of psrf_edt as text
%        str2double(get(hObject,'String')) returns contents of psrf_edt as a double


% --- Executes during object creation, after setting all properties.
function psrf_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to psrf_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cTime_edt_Callback(hObject, eventdata, handles)
% hObject    handle to cTime_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cTime_edt as text
%        str2double(get(hObject,'String')) returns contents of cTime_edt as a double


% --- Executes during object creation, after setting all properties.
function cTime_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cTime_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fName_edt_Callback(hObject, eventdata, handles)
% hObject    handle to fName_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fName_edt as text
%        str2double(get(hObject,'String')) returns contents of fName_edt as a double


% --- Executes during object creation, after setting all properties.
function fName_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fName_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_pb.
function save_pb_Callback(hObject, eventdata, handles)
% hObject    handle to save_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~isempty(daqfind))
    stop(daqfind)
    delete(daqfind) % It is important to delete unused object to free resources
    clear daqfind
end
if(~isempty(timerfind))
    stop(timerfind)
    delete(timerfind) % It is important to delete unused object to free resources
    clear timerfind
end

% Save file
[filename, pathname]= uiputfile('*.log', 'save data file'); 
if isequal(filename,0)
   disp('User selected Cancel!')
   diary ('error.log');
else
    %disp(['User selected: ', fullfile(pathname, filename)])
    logf = filename;
    diary (logf);
    fprintf('User selected: \n%s \n\n', fullfile(pathname, filename));
   %set(gcf,'Name',filename);
    % set(handles.edit_pathname, 'String', pathname); 
    Filename=[pathname filename];
    set(handles.fName_edt, 'String', filename); 
%     % connect the board
%     ad = arduino('COM3');
% 
%     % specify pin mode for pins 2:13
%     pinMode(ad,9,'output');% light sig out
%     digitalWrite(ad,9,0);

    %Construct a video input object associated with a Matrox device at ID 1.
    obj = videoinput('winvideo', 1,'YUY2_640x480');
    set(obj,'ReturnedColorspace','grayscale','FramesPerTrigger',1,'TriggerRepeat',Inf)
    triggerconfig(obj, 'Manual');

    %obj.LoggingMode = 'disk';
    %Initiate an acquisition and access the logged data.
    %start(obj);
    axes(handles.axes1);
    vidRes = get(obj, 'VideoResolution'); 
    nBands = get(obj, 'NumberOfBands'); 
    hImage = imshow(zeros(vidRes(2), vidRes(1), nBands)); 
    preview(obj, hImage); 
    
%     disp('Please Select Box Range......');
%     set(handles.ROI_txt1,'Visible','on');
%     h1 = imrect(gca,[154.201680672269 5.92436974789916 360 470.420168067227]);
%     boxPos = floor(wait(h1));
%     setColor(h1,'k');
%     bwBoxRange = createMask(h1,hImage);
%     bwBoxRange = uint8(bwBoxRange);
%     if isempty(bwBoxRange)
%         disp('ROI selection canceled!');
%         return
%     else
%         axes(handles.axes1);
%         hImage = imshow(zeros(boxPos(4), boxPos(3), nBands)); 
%         set(obj,'ROIPosition',boxPos)
%         preview(obj, hImage); 
%     end
%     set(handles.ROI_txt1,'Visible','off');
%     data.bwBoxRange = bwBoxRange;
%     data.boxPos = boxPos;
    
%     data.filename = filename;

    handles.obj = obj;
    data.vidWidth = vidRes(1);
    data.vidHeight = vidRes(2);
    data.vidBands = nBands;

%     handles.ad = ad;
    data.filename = filename;
    handles.data = data;

    guidata(hObject,handles);
    handles = guidata(hObject);
end


function ppm_edt_Callback(hObject, eventdata, handles)
% hObject    handle to ppm_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ppm_edt as text
%        str2double(get(hObject,'String')) returns contents of ppm_edt as a double


% --- Executes during object creation, after setting all properties.
function ppm_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ppm_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mouseThresh_edt_Callback(hObject, eventdata, handles)
% hObject    handle to mouseThresh_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mouseThresh_edt as text
%        str2double(get(hObject,'String')) returns contents of mouseThresh_edt as a double


% --- Executes during object creation, after setting all properties.
function mouseThresh_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mouseThresh_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in mThresh_pb.
function mThresh_pb_Callback(hObject, eventdata, handles)
% hObject    handle to mThresh_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
vData = handles.data;

trigger(handles.obj);
currentImg = getdata(handles.obj,1,'uint8');
%currentImg = double(currentImg)/255;
rMouseRegion1 = vData.refImg - currentImg;

% rMouseRegion = rMouseRegion(rMouseRegion < 100);
tmp = double(max(max(rMouseRegion1)));
rMouseRegion1 = mat2gray(rMouseRegion1,[30 tmp]);
L = max(graythresh(rMouseRegion1),0.25);
bwrMouseRegion1 = im2bw(rMouseRegion1,L);
se = strel('disk',2); 
openMouse1 = imopen(bwrMouseRegion1,se);
mFiltMouse1 = medfilt2(openMouse1);
closeMouse1=imclose(mFiltMouse1,se);
bwrMouse = closeMouse1;
figure;
subplot(2,1,1);imshow(closeMouse1);
%figure;imshow(bwMouse);
%bwOpenMouseRegion = bwareaopen(bwMouse,100);
cc = bwconncomp(bwrMouse);
stats = regionprops(bwrMouse, 'Area','Centroid' );
[currentArea, idx] = max([stats.Area]);
bwMouse = ismember(labelmatrix(cc), idx);
subplot(2,1,2);imshow(bwMouse);
if ~isempty(idx) & currentArea > 250
    hold on 
    centroids = stats(idx(1)).Centroid;
    plot(centroids(:,1), centroids(:,2), 'b*');
    hold off
end

% --- Executes on button press in getRef_pb.
function getRef_pb_Callback(hObject, eventdata, handles)
% hObject    handle to getRef_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
vData = handles.data;
start(handles.obj); % start to get ref
% nBands = get(handles.obj, 'NumberOfBands'); %%%%%%%%%%%%%%%%%%
n = 10;
trigger(handles.obj);
tmp = getdata(handles.obj,1,'uint8');
imData = uint8(zeros(size(tmp,1),size(tmp,2),n));
for i = 1:1:n
trigger(handles.obj);
imData(:,:,i) = getdata(handles.obj,1,'uint8');
end
refImg = uint8(mean(imData,3));
% RRefImg = refImg(:,:,1);
stoppreview(handles.obj);
stop(handles.obj);
bmpFileName = strrep(vData.filename, '.log', '.bmp');
imwrite(refImg,bmpFileName,'bmp'); 
axes(handles.axes1);
baseImg = imshow(refImg);

%%%%%%%%%%%%%%
disp('Please Select Box Range......');
    set(handles.ROI_txt1,'Visible','on');
    h1 = imrect(gca,[183.329831932773 7.35582983193277 263.638392857143 467.299107142857]);
    boxPos = floor(wait(h1));
    setColor(h1,'k');
    bwBoxRange = createMask(h1,baseImg);
    bwBoxRange = uint8(bwBoxRange);
    if isempty(bwBoxRange)
        disp('ROI selection canceled!');
%         return
%     else
%         axes(handles.axes1);
%         hImage = imshow(zeros(boxPos(4), boxPos(3), nBands)); 
%         set(handles.obj,'ROIPosition',boxPos)
%         preview(handles.obj, hImage); 
    end
%     set(handles.ROI_txt1,'Visible','off');
    data.bwBoxRange = bwBoxRange;
    data.boxPos = boxPos;
    handles.data = data;
    
%%%%%%%%%%%%%
% disp('Please Select Stimulation ROI......');
set(handles.ROI_txt1,'Visible','on');
mouseThresh = str2double(get(handles.mouseThresh_edt,'String'));
h2 = imrect(gca,[162.344537815126 9.06722689075616 290.205357142857 241.090336134453]);
iPos1 = wait(h2);
setColor(h2,'r');
bwIPos1 = createMask(h2,baseImg);
if isempty(bwIPos1)
    disp('ROI selection canceled!');
    return
end

h3 = imrect(gca,[164.503676470588 252.520483193278 283.910714285714 214.078781512605]);
setColor(h3,'r');
iPos2 = wait(h3);
bwIPos2 = createMask(h3,baseImg);
if isempty(iPos2)
    disp('ROI selection canceled!');
    return
end

set(handles.ROI_txt1,'Visible','off');
% preview boxrange vid
axes(handles.axes2);
hImage = imshow(zeros(vData.vidHeight, vData.vidWidth,vData.vidBands)); 
%     data.vidWidth = vidRes(1);
%     data.vidHeight = vidRes(2);
%     data.vidBands = nBands;
preview(handles.obj,hImage);
start(handles.obj);
vData.refImg = refImg;
vData.mouseThresh = mouseThresh;
vData.bwIPos1 = bwIPos1;
vData.iPos1 = iPos1; % except boxPos other positions are [x y] format, boxPos is [xoffset, yoffset, width, height];
vData.iPos2 = iPos2;
vData.bwIPos2 = bwIPos2;
handles.data = vData;

guidata(hObject,handles);
handles = guidata(hObject);




% --- Executes on button press in start_pb.
function start_pb_Callback(hObject, eventdata, handles)
% hObject    handle to start_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Timer for tracking
%trackTimer = timer('TimerFcn',{@getMouse,handles}, 'Period',timerPeriod, 'ExecutionMode','fixedRate');
%start(trackTimer);
guidata(hObject,handles);
handles = guidata(hObject);
vData = handles.data;

timerPeriod = 1/str2double(get(handles.psrf_edt,'String'));
testTime = floor(str2double(get(handles.testTime_edt,'String')));% acctually testTime is the time caculated,means 300s(5min)
perSecondReadFrames = floor(str2double(get(handles.psrf_edt,'String')));

global centroids   stimTag
centroids = []; stimTag = [];

global timeValue
timeValue = 0;
%set(handles.cTime_edt,'String',num2str(timeValue,'%.1f'));
% onTime = str2double(get(handles.onTime_edt,'String'));
% offTime = str2double(get(handles.offTime_edt,'String'));
% perNum = ceil(timerPeriod /(onTime + offTime));%str2double(get(handles.perNum_edt,'String'));

stimSigOut = get(handles.stimSig_rb,'Value');
t = timer;
digitalWrite(handles.ad,9,0);  
vData.timerPeriod = timerPeriod;
vData.testTime = testTime;
vData.perSecondReadFrames = perSecondReadFrames;
vData.ppm = str2double(get(handles.ppm_edt,'String'));% pixels per mm
vData.FR = round(str2double(get(handles.FR_edt,'String')));
% vData.onTime = onTime;
% vData.offTime = offTime;
% vData.perNum = perNum;
vData.stimSigOut = stimSigOut;
handles.t = t;
startTime = clock;
fprintf('Mission Started @ %s\n',datestr(startTime));


vData.startTime = startTime;
handles.data = vData;
guidata(hObject,handles);
handles = guidata(hObject);

vData = handles.data;
set(handles.t,'Period',vData.timerPeriod,'TimerFcn',{@getMouse,handles},'ExecutionMode','fixedRate');% 'StopFcn',{@stopAll,handles}%'TasksToExecute',ceil(vData.perSecondReadFrames*vData.testTime) ,
start(handles.t);
disp('Timer Running......')
% Configure property values 

% --- Executes on button press in ROIAna_pb.
function ROIAna_pb_Callback(hObject, eventdata, handles)
% hObject    handle to ROIAna_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
vData = handles.data;
dataPlot(vData);


% --- Executes on button press in stop_pb.
function stop_pb_Callback(hObject, eventdata, handles)
% hObject    handle to stop_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
digitalWrite(handles.ad,9,0);
stop(handles.obj);
vData = handles.data;
global centroids  timeValue stimTag
%figFileName = strrep(vData.filename, 'dat', 'fig');

matFileName = strrep(vData.filename, '.log', '.mat');
%vData.testTime = timeValue;
vData.centroids = centroids;
vData.testTime = timeValue;
vData.stimTag = stimTag;
endTime = clock;
a = sprintf('Mission Ended @ %s\n',datestr(endTime));
disp(a);
vData.endTime = endTime;
handles.data = vData;
guidata(hObject,handles);
handles = guidata(hObject);
save(matFileName, '-struct', 'vData');
baseImg = imshow(vData.refImg,'Parent',handles.axes2);
hold on
if ~isempty(centroids)
    plot(centroids(:,1),centroids(:,2),'b-');
end
rectangle ('position', vData.iPos1, 'linewidth', 2, 'EdgeColor', [1 0 0]);
hold off
centroids = [];
timeValue = 0;
stimTag = [];
clear centroids timeValue stimTag

delete(instrfind({'Port'},{'COM9'}));
if(~isempty(timerfind))
    stop(timerfind)
    delete(timerfind) % It is important to delete unused object to free resources
    clear timerfind
end
if(~isempty(daqfind))
    stop(daqfind)
    delete(daqfind) % It is important to delete unused object to free resources
    clear daqfind
end
guidata(hObject,handles);
handles = guidata(hObject);

disp('Mission End!')


function dateTime_edt_Callback(hObject, eventdata, handles)
% hObject    handle to dateTime_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dateTime_edt as text
%        str2double(get(hObject,'String')) returns contents of dateTime_edt as a double


% --- Executes during object creation, after setting all properties.
function dateTime_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dateTime_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function getMouse(hObject, eventdata, handles)
%flushdata(handles.obj,'triggers');
global centroids stimTag
persistent inNum
if isempty(inNum)
    inNum = [0,0];
end
vData = handles.data;
global timeValue
timeValue = hObject.TasksExecuted*vData.timerPeriod;
if timeValue > vData.testTime
    digitalWrite(handles.ad,9,0);
    stop(handles.obj);
    inNum = [0,0];
    clear inNum
    stop(hObject);
    delete(hObject);
    clear hObject
    disp('vidTimer Stopped!')
    matFileName = strrep(vData.filename, '.log', '.mat');
    endTime = clock;
    fprintf('Mission ended @ %s\n',datestr(endTime));
    diary
    vData.endTime = endTime;
    vData.centroids = centroids;
    vData.testTime = timeValue;
    vData.stimTag = stimTag;
    save(matFileName, '-struct', 'vData');
    disp('MAT File Saved!')
    return
end
set(handles.cTime_edt,'String',num2str(timeValue,'%.1f'));
%set(obj,'UserData',timeValue);
trigger(handles.obj);
currentImg = getdata(handles.obj,1,'uint8');
%currentImg = double(currentImg)/255;
rMouseRegion1 = vData.refImg - currentImg;

% rMouseRegion = rMouseRegion(rMouseRegion < 100);
tmp = double(max(max(rMouseRegion1)));
rMouseRegion1 = mat2gray(rMouseRegion1,[30 tmp]);
L = max(graythresh(rMouseRegion1),0.25);
bwrMouseRegion1 = im2bw(rMouseRegion1,L);
se = strel('disk',2); 
openMouse1 = imopen(bwrMouseRegion1,se);
mFiltMouse1 = medfilt2(openMouse1);
closeMouse1=imclose(mFiltMouse1,se);
bwrMouse = closeMouse1;
%figure;imshow(bwMouse);
%bwOpenMouseRegion = bwareaopen(bwMouse,100);
cc = bwconncomp(bwrMouse);
stats = regionprops(bwrMouse, 'Area','Centroid');
[currentArea, idx] = max([stats.Area]);
bwMouse = ismember(labelmatrix(cc), idx);
inROI = sum(sum(bwMouse & vData.bwIPos1))/sum(sum(bwMouse));

if ~isempty(idx) & currentArea > 200
    centroids = [centroids;stats(idx).Centroid];
    cC = uint16(stats(idx).Centroid);
    %cPosTag = vData.bwIPos1(cC(1,2),cC(1,1));
    if inROI > 0.5
        cPosTag = 1;
    else
        cPosTag = 0;
    end
    if vData.FR == 1
        cStimTag = cPosTag;
        stimTag = [stimTag; cStimTag];
        set(handles.cTime_edt,'BackgroundColor',[1-cStimTag 1 1-cStimTag]);
%         putvalue(handles.diOut,cStimTag);
        digitalWrite(handles.ad,9,cStimTag);
    else
        cStimTag = 0;
        stimTag = [stimTag; cStimTag];
        set(handles.cTime_edt,'BackgroundColor',[1-cStimTag 1 1-cStimTag]);
%         putvalue(handles.diOut,cStimTag);
        digitalWrite(handles.ad,9,cStimTag);
    end
    
else
    lossTag = 1
    tmpCentrod = centroids(end,:);
    centroids = [centroids;tmpCentrod];
    cStimTag = stimTag(end);
    stimTag = [stimTag; cStimTag];
end






function onTime_edt_Callback(hObject, eventdata, handles)
% hObject    handle to onTime_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of onTime_edt as text
%        str2double(get(hObject,'String')) returns contents of onTime_edt as a double


% --- Executes during object creation, after setting all properties.
function onTime_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to onTime_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function offTime_edt_Callback(hObject, eventdata, handles)
% hObject    handle to offTime_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of offTime_edt as text
%        str2double(get(hObject,'String')) returns contents of offTime_edt as a double


% --- Executes during object creation, after setting all properties.
function offTime_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offTime_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stimSig_rb.
function stimSig_rb_Callback(hObject, eventdata, handles)
% hObject    handle to stimSig_rb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stimSig_rb


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function FR_edt_Callback(hObject, eventdata, handles)
% hObject    handle to FR_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FR_edt as text
%        str2double(get(hObject,'String')) returns contents of FR_edt as a double


% --- Executes during object creation, after setting all properties.
function FR_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FR_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadRef_pb.
function loadRef_pb_Callback(hObject, eventdata, handles)
% hObject    handle to loadRef_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject,handles);
handles = guidata(hObject);
vData = handles.data;

% load bmp refImg
refFilename = uigetfile({'*.bmp';'*.png';'*.jpg'}, 'load refImg...'); 
if isequal(refFilename,0)
   disp('User selected Cancel!')
   diary('error.log');
else
   logf=refFilename;
   diary (logf);
   fprintf('User selected refImg: \n%s \n\n', refFilename);
%    disp(['User selected: ', refFilename])
   refImg = imread(refFilename);
   refImg = uint8(refImg);
   RRefImg = refImg(:,:,1);
   axes(handles.axes1);
   baseImg = imshow(refImg);

   disp('Please Select Box Range and Stimulation ROI......');
   %msgbox('Please Select Possible Mouse Range......');
   set(handles.ROI_txt1,'Visible','on');
   h1 = imrect(gca,[183.329831932773 7.35582983193277 263.638392857143 467.299107142857]);
   boxPos = wait(h1);
   setColor(h1,'k');
   bwBoxRange = createMask(h1,baseImg);
   bwBoxRange = uint8(bwBoxRange);
   if isempty(bwBoxRange)
       disp('ROI selection canceled!');
       return
   end
   % get box position
   xS = boxPos(:,1);
   xE = boxPos(:,1) + boxPos(:,3) - 1;
   yS = boxPos(:,2);
   yE = boxPos(:,2) + boxPos(:,4) - 1;
   boxWidth = boxPos(:,3);
   boxHeight = boxPos(:,4);
   %boxPos = [xS yS boxWidth boxHeight];
   mouseThresh = str2double(get(handles.mouseThresh_edt,'String'));
   boxRangeRefImg = RRefImg.*bwBoxRange;
   %bwRefImg = boxRangeRefImg(:,:,1) < mouseThresh;
   bwRefImg = refImg(:,:,1) < mouseThresh;
   % baseImg = imshow(refImg(xS:xE,yS:yE));
   h2 = imrect(gca,[162.344537815126 9.06722689075616 290.205357142857 241.090336134453]);
   iPos1 = wait(h2);
   setColor(h2,'r');
   bwIPos1 = createMask(h2,baseImg);
   if isempty(bwIPos1)
       disp('ROI selection canceled!');
       return
   end
   h3 = imrect(gca,[164.503676470588 252.520483193278 283.910714285714 214.078781512605]);
   iPos2 = wait(h3);
   setColor(h3,'r');
   bwIPos2 = createMask(h3,baseImg);
   if isempty(iPos2)
    disp('ROI selection canceled!');
    return
   end

   set(handles.ROI_txt1,'Visible','off');
   % preview boxrange vid
   axes(handles.axes2);
   %handles.obj.ROIPosition = boxPos;
   hImage = imshow(zeros(vData.vidHeight, vData.vidWidth,vData.vidBands));
   preview(handles.obj,hImage);
   start(handles.obj);
   
   vData.boxxS = xS;
   vData.boxxE = xE;
   vData.boxyS = yS;
   vData.boxyE = yE;
   vData.refImg = refImg;
   vData.RRefImg = RRefImg;
   vData.bwBoxRange = bwBoxRange;
   vData.mouseThresh = mouseThresh;
   vData.boxRangeRefImg = boxRangeRefImg;
   vData.bwBoxRangeRefImg = boxRangeRefImg < mouseThresh;
   vData.bwRefImg = bwRefImg;
   vData.bwIPos1 = bwIPos1;
   vData.boxPos = boxPos;
   vData.iPos1 = iPos1; % except boxPos other positions are [x y] format, boxPos is [xoffset, yoffset, width, height];
    vData.iPos2 = iPos2;
    vData.bwIPos2 = bwIPos2;
   handles.data = vData;

   guidata(hObject,handles);
   handles = guidata(hObject);
end


% --- Executes on button press in pushbutton_connect.
function pushbutton_connect_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   guidata(hObject,handles);
   handles = guidata(hObject);  
% connect the board
    ad = arduino('COM3');

    % specify pin mode for pins 2:13
    pinMode(ad,9,'output');% light sig out
    digitalWrite(ad,9,0);
        handles.ad = ad;
   guidata(hObject,handles);
   handles = guidata(hObject);
