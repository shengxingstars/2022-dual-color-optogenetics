function varargout = singleTrialAna(varargin)
% SINGLETRIALANA MATLAB code for singleTrialAna.fig
%      SINGLETRIALANA, by itself, creates a new SINGLETRIALANA or raises the existing
%      singleton*.
%
%      H = SINGLETRIALANA returns the handle to a new SINGLETRIALANA or the handle to
%      the existing singleton*.
%
%      SINGLETRIALANA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SINGLETRIALANA.M with the given input arguments.
%
%      SINGLETRIALANA('Property','Value',...) creates a new SINGLETRIALANA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before singleTrialAna_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to singleTrialAna_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help singleTrialAna

% Last Modified by GUIDE v2.5 15-May-2015 11:23:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @singleTrialAna_OpeningFcn, ...
                   'gui_OutputFcn',  @singleTrialAna_OutputFcn, ...
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


% --- Executes just before singleTrialAna is made visible.
function singleTrialAna_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to singleTrialAna (see VARARGIN)

% Choose default command line output for singleTrialAna
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes singleTrialAna wait for user response (see UIRESUME)
% uiwait(handles.gui2);


% --- Outputs from this function are returned to the command line.
function varargout = singleTrialAna_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in stim_pp.
function stim_pp_Callback(hObject, eventdata, handles)
% hObject    handle to stim_pp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns stim_pp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from stim_pp


% --- Executes during object creation, after setting all properties.
function stim_pp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_pp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DiffWT_pb.
function DiffWT_pb_Callback(hObject, eventdata, handles)
% hObject    handle to DiffWT_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = findobj('Tag','gui2');
vData = getappdata(h,'UserData');
% assignin('base','vData',vData);
% calculate ncDiff
colorOrder = [0,0.447,0.741;0.850,0.325,0.098;0.929,0.694,0.125;0.494,0.184,0.556;0.466,0.674,0.188;0.301,0.745,0.933;0.635,0.078,0.184];
vData.colorOrder = colorOrder;
stimNum = vData.stimNum;
cStimIdx = get(handles.stim_pp,'Value');
trialID = str2double(get(handles.trialID_edt,'String')); 
deciR = 10;
mERF = vData.mERF;
eval(['cTotalTrialNum = size(vData.ERF',int2str(cStimIdx),');']);
if ~isnan(trialID) & trialID <= cTotalTrialNum - 9
    eval(['cTrial = vData.ERF',int2str(cStimIdx),'(trialID:trialID + 9,:);']);
    cTrial = mean(cTrial,1);
else
    cTrial = mERF(cStimIdx + 1,:); % important to + 1
end
cTrial = decimate(cTrial,deciR);
cTrial = cTrial./max(cTrial,[],2);
cDiff = diff(cTrial,1,2);
step = vData.resp1.interval*deciR;
cDiff = cDiff./step;
ncDiff = modData(cDiff);
cTrial = modData(cTrial);
xMin = min(mERF(1,:));
xMax = max(mERF(1,:));
x = xMin:step:xMax;
% eval(['vData.nERF',int2str(cStimIdx),'= modData(vData.ERF',int2str(cStimIdx),');'])
nx = modData(x);
sc = get(handles.sc_pp,'Value');
vData.deciR = deciR;
vData.ncDiff = ncDiff;
vData.sc = sc;
vData.nx = nx;
vData.cStimIdx = cStimIdx;
vData.cTrial = cTrial;
vData.xMin = xMin;
vData.xMax = xMax;

if cStimIdx <= stimNum
    axes(handles.axes1);
    cla
    plot(nx,ncDiff,'color',[0.5 0.5 0.5]);% real velocity too large
%     [coeff,denCTrial,denCoeff,~,~] = Run_Neigh(nx,ncDiff,sc);
    [coeff,denCTrial,denCoeff,~] = Run_NZT(nx,ncDiff,sc);
    vData.cCoeff = coeff;
    vData.cDenCoeff = denCoeff;
    vData.denCTrial = denCTrial;
    hold on
    plot(nx,denCTrial,'Color',colorOrder(2,:))
    set(gca,'YLim',[-2 4])
    yrange = get(handles.axes1,'ylim');
    line([0 0],[yrange(1) yrange(2)],'Linestyle',':','color','k')
    hold off
%     title('ERP','FontSize',10)
    xlabel('Time(s)','FontSize',10)
    ylabel('Norm. dF','FontSize',10);
    set(gca,'XLim',[xMin xMax])
    % prelocate virables
%     vData.mcoeff = zeros(size(coeff,1),size(coeff,2),stimNum);
%     vData.mdenCoeff = zeros(size(denCoeff,1),size(denCoeff,2),stimNum);
%     vData.myDen = zeros(size(yDen,1),size(yDen,2),stimNum);
    % trans to vData
%     vData.mcoeff(:,:,cStimIdx) = coeff;
%     vData.mdenAv(cStimIdx,:) = denAv;
%     vData.mdenCoeff(:,:,cStimIdx) = denCoeff;
%     vData.myDen(:,:,cStimIdx) = yDen;
    assignin('base','vData',vData);
    setappdata(h,'UserData',vData);
    axes(handles.axes2)
    plotCoefficients(handles)
    posTag = get(handles.positive_rb,'Value');
    negTag = get(handles.neg_rb,'Value');
    if posTag == 1
        positive_rb_Callback(hObject, eventdata, handles)
    end
    if negTag == 1
        neg_rb_Callback(hObject, eventdata, handles)
    end
else
    disp(['Totoal ' num2str(stimNum) ' stimulus !']);
end


% --- Executes on selection change in sc_pp.
function sc_pp_Callback(hObject, eventdata, handles)
% hObject    handle to sc_pp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sc_pp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sc_pp


% --- Executes during object creation, after setting all properties.
function sc_pp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sc_pp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function from_edt_Callback(hObject, eventdata, handles)
% hObject    handle to from_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of from_edt as text
%        str2double(get(hObject,'String')) returns contents of from_edt as a double


% --- Executes during object creation, after setting all properties.
function from_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to from_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function to_edt_Callback(hObject, eventdata, handles)
% hObject    handle to to_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of to_edt as text
%        str2double(get(hObject,'String')) returns contents of to_edt as a double


% --- Executes during object creation, after setting all properties.
function to_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to to_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in positive_rb.
function positive_rb_Callback(hObject, eventdata, handles)
% hObject    handle to positive_rb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of positive_rb
h = findobj('Tag','gui2');
vData = getappdata(h,'UserData');
posTag = get(handles.positive_rb,'Value');
negTag = get(handles.neg_rb,'Value');
tmin = str2double(get(handles.from_edt,'String'));% should be n times of 20 ms
tmax = str2double(get(handles.to_edt,'String'));
nx = vData.nx;
idx0 = find(nx == 0);
denCTrial = vData.denCTrial;
ncDiff = vData.ncDiff;
cTrial = vData.cTrial;
% replot
axes(handles.axes1)
if negTag == 0
    cla
end
%replot denoised average.
hold on
plot(nx,ncDiff,'Color',[0.5 0.5 0.5])
plot(nx,denCTrial,'Color',vData.colorOrder(2,:))
plot(nx,vData.cTrial,'Color',vData.colorOrder(1,:));
incOnsetLat = NaN;
incOnsetAmp = NaN;
posMaxALat = NaN;
posMaxAAmp = NaN;

% positive max accelerate and its onset
if posTag == 1
%         if isnan(tmin) & isnan(tmax)
%             idxMin = 1;
%             [pks,pLocs] = findpeaks(denCTrial,'minpeakdistance',5,'sortstr','descend');
%         else
%             idxMin = find(nx == tmin);
%             idxMax = find(nx == tmax);
%             [pks,pLocs] = findpeaks(denCTrial(idxMin:idxMax),'minpeakdistance',5,'sortstr','descend');        
%         end
%         if ~isempty(pLocs)
%             idx0sL = crossing(denCTrial(idxMin:pLocs(1) + idxMin));
%             if ~isempty(idx0sL)
%                 zeroIdxL = idx0sL(end);
%                 incOnsetLat = nx(zeroIdxL + idxMin) - nx(idx0);
%                 incOnsetAmp = cTrial(zeroIdxL + idxMin);
%             end
%             posMaxALat = nx(pLocs(1) + idxMin) - nx(idx0);
%             posMaxAAmp = cTrial(pLocs(1) + idxMin);
%         end
% %     idx0sR = crossing(denCTrial(pLocs(1) + idxMin:idxMax));
% %     zeroIdxR = idx0sR(1);  
% %     incOffset.lat = nx(zeroIdxR + idxMin) - nx(idx0);
% %     incOffset.amp = vData.cTrial(zeroIdxR + idxMin);
%     plot(nx(pLocs(1) + idxMin),vData.denCTrial(pLocs(1) + idxMin),'b*')
% %     plot(nx(zeroIdxL + idxMin),vData.cTrial(zeroIdxL + idxMin),'o','Color',[0 0.5 0])
% %     plot(nx(zeroIdxR + idxMin),vData.cTrial(zeroIdxR + idxMin),'o','Color',[0 0.5 0])
    [incOnsetLat,incOnsetAmp,posMaxALat,posMaxAAmp] = posPeak(denCTrial,nx,tmin,tmax);
    plot(posMaxALat,posMaxAAmp,'r*')
    [incOnsetLat,incOnsetAmp,posMaxALat,posMaxAAmp] = posPeak(cTrial,nx,tmin,tmax);
    plot(posMaxALat,posMaxAAmp,'b*')
    
end
yrange = get(handles.axes1,'ylim');
line([0 0],[yrange(1) yrange(2)],'Linestyle',':','color','k')
% title('DiffERP','FontSize',10)
xlabel('Time(s)','FontSize',10);
ylabel('Norm. dF','FontSize',10);
set(gca,'XLim',[vData.xMin vData.xMax])



% --- Executes on button press in indTrial_edt.
function indTrial_edt_Callback(hObject, eventdata, handles)
% hObject    handle to indTrial_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of indTrial_edt
h = findobj('Tag','gui2');
vData = getappdata(h,'UserData');
trialByTrialPropCal(vData)


function trialID_edt_Callback(hObject, eventdata, handles)
% hObject    handle to trialID_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trialID_edt as text
%        str2double(get(hObject,'String')) returns contents of trialID_edt as a double


% --- Executes during object creation, after setting all properties.
function trialID_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trialID_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in neg_rb.
function neg_rb_Callback(hObject, eventdata, handles)
% hObject    handle to neg_rb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of neg_rb
h = findobj('Tag','gui2');
vData = getappdata(h,'UserData');
posTag = get(handles.positive_rb,'Value');
tmin = str2double(get(handles.from_edt,'String'));% should be n times of 20 ms
tmax = str2double(get(handles.to_edt,'String'));
nx = vData.nx;
idx0 = find(nx == 0);
denCTrial = vData.denCTrial;
ncDiff = vData.ncDiff;
cTrial = vData.cTrial;
% replot
axes(handles.axes1)
if posTag == 0
    cla
end
%replot denoised average.
hold on
plot(nx,ncDiff,'Color',[0.5 0.5 0.5])
plot(nx,denCTrial,'Color',vData.colorOrder(2,:))
plot(nx,vData.cTrial,'Color',vData.colorOrder(1,:));
decOnsetLat = NaN;
decOnsetAmp = NaN;
negMaxALat = NaN;
negMaxAAmp = NaN;

% negtive max accelerate and its onset (peak value of original signal)
negTag = get(handles.neg_rb,'Value');
if negTag == 1
%         negDenCTrial = - denCTrial;
%         if isnan(tmin) & isnan(tmax)
%             idxMin = 1;
%             [pks,nLocs] = findpeaks(negDenCTrial,'minpeakdistance',5,'sortstr','descend');
%         else
%             idxMin = find(nx == tmin);
%             idxMax = find(nx == tmax);
%             [pks,nLocs] = findpeaks(negDenCTrial(idxMin:idxMax),'minpeakdistance',5,'sortstr','descend');     
%         end
%         if ~isempty(nLocs)
%             idx0sL = crossing(negDenCTrial(idxMin:nLocs(1) + idxMin));
%             if ~isempty(idx0sL)
%                 zeroIdxL = idx0sL(end);
%                 decOnsetLat = nx(zeroIdxL + idxMin) - nx(idx0);
%                 decOnsetAmp = cTrial(zeroIdxL + idxMin);
%             end
%             negMaxALat = nx(nLocs(1) + idxMin) - nx(idx0);
%             negMaxAAmp = cTrial(nLocs(1) + idxMin);
%         end
% %     idx0sR = crossing(denCTrial(nLocs(1) + idxMin:idxMax));
% %     zeroIdxR = idx0sR(1);  
% %     decOffset.lat = nx(zeroIdxR + idxMin) - nx(idx0);
% %     decOffset.amp = vData.cTrial(zeroIdxR + idxMin);
%     plot(nx(nLocs(1) + idxMin),vData.cTrial(nLocs(1) + idxMin),'b*')
% %     plot(nx(zeroIdxL + idxMin),vData.cTrial(zeroIdxL + idxMin),'o','Color',[0 0.5 0])
% %     plot(nx(zeroIdxR + idxMin),vData.cTrial(zeroIdxR + idxMin),'o','Color',[0 0.5 0])
         [decOnsetLat,decOnsetAmp,negMaxALat,negMaxAAmp] = negPeak(denCTrial,nx,tmin,tmax);
         plot(negMaxALat,negMaxAAmp,'r*')
         [decOnsetLat,decOnsetAmp,negMaxALat,negMaxAAmp] = negPeak(cTrial,nx,tmin,tmax);
         plot(negMaxALat,negMaxAAmp,'b*')         
end
yrange = get(handles.axes1,'ylim');
line([0 0],[yrange(1) yrange(2)],'Linestyle',':','color','k')
% title('DiffERP','FontSize',10)
xlabel('Time(s)','FontSize',10);
ylabel('Norm. dF','FontSize',10);
set(gca,'XLim',[vData.xMin vData.xMax])
