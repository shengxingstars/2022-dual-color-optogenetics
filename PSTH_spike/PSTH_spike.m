function varargout = PSTH_spike(varargin)
% 20160322 when base sample > 1000,use thresh; else use multiperm
% smooth the spikecount each trial
% 20151227 calculate SNR in plotSigPnt
% 20151222 modified sigPntPlot
% 20151212 modified singleTrialAna
% 20151204 compitable with .tdms
% 20151130 modified areaErrorBar
% 20150624 ERFPeak baseline MAD based calculation 
% 20150620 triggerpretreat for event triggers
% 20150619 add auROC analysis if stimNum==2
% 20150617 clims default [-10 40], if max exceeds 40 then use the max
% 20150614 pks were calculated without threshould
% 20150612 not equal triger duration will be calculated acording to median
% value rather basline based.
% 20150607 ERFPeak increased the MAD & detrend based method besides the
% trial by trial baseline based method. Results of the two methods differs not much. 
% 20150604 save DataOut including peaks, pvals, significant time range; add
% ERFPeak function; modified areaErrorPlot function to out put sigRange;
% GC6 signal also can be ploted by PETH button due to ERFPeak based
% eventlization.
% 20150603 modified areaError to plot contineous line insted of dots when
% 80% of the points are significant
% 20150602 added PETH button and related functions; permutation test
% modified for matched test
%20150526 heatmap ytick[start end]
% 20150524 automatic yrange;tmx_perm1 calculated and ploted by
% areaError
% 20150523 triggerPretreat trialNum changed to trialTo
% 20150516 created posPeak and negPeak Fcn; modified trialByTrialPropCal with area under the curve
% 20150515 for individual trial analysis (positive and negative) peak diff latency and Amp by trialByTrialProCal; 
% 20150412 change trialNum to trialTo; calculate ERF with matrix rather
% cell
% 20150403 delTrial_edt to delete trials with the format [1:10] or [1 4 5 6]
% 20150401 tested version
% 20150326 load and plot multi stimulus;automatic offset calculation; heatmap parula 
% PSTH_SPIKE MATLAB code for PSTH_spike.fig
%      PSTH_SPIKE, by itself, creates a new PSTH_SPIKE or raises the existing
%      singleton*.
%
%      H = PSTH_SPIKE returns the handle to a new PSTH_SPIKE or the handle to
%      the existing singleton*.
%
%      PSTH_SPIKE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PSTH_SPIKE.M with the given input arguments.
%
%      PSTH_SPIKE('Property','Value',...) creates a new PSTH_SPIKE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PSTH_spike_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PSTH_spike_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PSTH_spike

% Last Modified by GUIDE v2.5 31-Jan-2022 21:13:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PSTH_spike_OpeningFcn, ...
                   'gui_OutputFcn',  @PSTH_spike_OutputFcn, ...
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


% --- Executes just before PSTH_spike is made visible.
function PSTH_spike_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PSTH_spike (see VARARGIN)

% Choose default command line output for PSTH_spike
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PSTH_spike wait for user response (see UIRESUME)
% uiwait(handles.gui1);


% --- Outputs from this function are returned to the command line.
function varargout = PSTH_spike_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function stim_edt_Callback(hObject, eventdata, handles)
% hObject    handle to stim_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim_edt as text
%        str2double(get(hObject,'String')) returns contents of stim_edt as a double


% --- Executes during object creation, after setting all properties.
function stim_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function resp_edt_Callback(hObject, eventdata, handles)
% hObject    handle to resp_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resp_edt as text
%        str2double(get(hObject,'String')) returns contents of resp_edt as a double


% --- Executes during object creation, after setting all properties.
function resp_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resp_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function preTime_edt_Callback(hObject, eventdata, handles)
% hObject    handle to preTime_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of preTime_edt as text
%        str2double(get(hObject,'String')) returns contents of preTime_edt as a double


% --- Executes during object creation, after setting all properties.
function preTime_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preTime_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function postTime_edt_Callback(hObject, eventdata, handles)
% hObject    handle to postTime_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of postTime_edt as text
%        str2double(get(hObject,'String')) returns contents of postTime_edt as a double


% --- Executes during object creation, after setting all properties.
function postTime_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to postTime_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function offset_edt_Callback(hObject, eventdata, handles)
% hObject    handle to offset_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of offset_edt as text
%        str2double(get(hObject,'String')) returns contents of offset_edt as a double


% --- Executes during object creation, after setting all properties.
function offset_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offset_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in av_pb.
function av_pb_Callback(hObject, eventdata, handles)
% hObject    handle to av_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);

preTime = str2double(get(handles.preTime_edt,'String'));
postTime = str2double(get(handles.postTime_edt,'String'));
trials = str2num(get(handles.trials_edt,'String'));
sTrial = trials(1); trialTo = trials(2);
delTrial = str2num(get(handles.delTrial_edt,'String'));
ctrlTime = str2num(get(handles.ctrlTime_edt,'String'));
sCtrl = ctrlTime(1); eCtrl = ctrlTime(2);
clims = str2num(get(handles.clims_edt,'String'));%important to use str2num
% offset calculation
resp1 = handles.data.resp1;
offset = str2double(get(handles.offset_edt,'String'));
if isnan(offset)
    % offset calculation  mean value of first 5 s
    num = round(5/resp1.interval);
    offset = max(resp1.values(1:num));
    set(handles.offset_edt,'String',num2str(offset))
end
% ERF calculation
interval = resp1.interval;
x = -preTime:interval:postTime-interval;
stimNum = handles.data.stimNum
mERF = x;
lineFig = figure;
set(gca,'LineWidth',3,'FontSize',25)
for i = 1:1:stimNum    
    % ERF mERF sem calculation
    eval(['stim',int2str(i),'=handles.data.stim',int2str(i),';']);
    eval(['cStim = triggerPretreat(stim',int2str(i),',sTrial,trialTo,handles);']);
    [cERF,cmERF] = ERFWave(cStim,resp1,preTime,postTime,sCtrl,eCtrl,offset,0);
    % areaError line plot
    if ~isnan(delTrial)
        cERF(delTrial,:) = [];
        cmERF = mean(cERF);
    end
    figure(lineFig)
    areaErrorbar(x,cERF,i);
    assignin('base',['ERF' int2str(i)],cERF);
    eval(['handles.data.ERF',int2str(i),'=cERF;']);
    % heatmap
    figure
    if isnan(clims)
        climsMax = max(round(max(cmERF)/10)*10,40);
        climsMin = min(round(min(cmERF)/10)*10,-10);
        clims = [climsMin climsMax];
    end
    plotHeatmap(x,cERF,clims);
    mERF = [mERF;cmERF];
end
figure(lineFig)
yrange = get(gca,'YLim');
if yrange(2)<=30 & yrange(1) >= -10
    yrange = [-10 20];
end
set(gca,'Xlim',[-preTime postTime],'YLim',yrange,'LineWidth',3,'FontName','Arial','FontSize',20,'TickDir','out');
xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
ylabel('\Delta F/F(%)','FontName','Arial','FontSize',25,'FontWeight','Bold');
xP = 0;
plot([xP xP],yrange,'LineStyle',':','Color',[0 0 0],'LineWidth',3)
hold off

assignin('base','mERF',mERF);
handles.data.mERF = mERF;
handles.lineFig = lineFig;
vData = handles.data;
% filename = handles.filename;
% Data_filename = [filename(1:end-4),' analysis.mat'];
% Data_filename = handles.Data_filename
% save(handles.Data_filename,'-struct','vData')
save('DataOut', '-struct', 'vData');

guidata(hObject,handles);
handles = guidata(hObject);




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~exist('handles.data.mERF','var')
    av_pb_Callback(hObject, eventdata, handles);
    h1 = findobj('Tag','gui1');
    handles = guidata(h1);
end
singleTrialAna
h = findobj('Tag','gui2');
setappdata(h,'UserData',handles.data)
trialByTrialPropCal(handles.data);



% --- Executes on button press in stimLoad_pb.
function stimLoad_pb_Callback(hObject, eventdata, handles)
% hObject    handle to stimLoad_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
[filename, pathname] = uigetfile('*.mat','*.dat', 'MultiSelect', 'on');
if isequal(filename,0)
   disp('User selected Cancel')
else
    filename = cellstr(filename);
    stimNum = size(filename,2);
    for i = 1:stimNum
            disp(['User selected stimuli', fullfile(pathname, filename{i})])
            eval(['stim',int2str(i), '=importdata(fullfile(pathname, filename{i}));']);
            eval(['handles.data.stim',int2str(i),'=stim',int2str(i),';']);
    end
%     set(handles.trials_edt,'String','[1 500]')
    temp = length(stim1.times)/2
    set(handles.trials_edt,'String',num2str([1 temp]))
    set(handles.delTrial_edt,'String','NaN')
%     set(handles.stim_edt,'String',[pathname 'total' int2str(stimNum)])
    set(handles.stim_edt,'String',filename{i})
    handles.data.stimNum = stimNum;
end
handles.filename_stim = filename;
% handles.pathname = pathname;

% Data_filename = [filename(1:end-4), ' analysis.mat'];
% handles.Data_filename = Data_filename;
guidata(hObject,handles);
handles = guidata(hObject);


% --- Executes on button press in respLoad_pb.
function respLoad_pb_Callback(hObject, eventdata, handles)
% hObject    handle to respLoad_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
[filename, pathname] = uigetfile({'*.mat';'*.t64';'*.tdms'},'MultiSelect', 'on');
handles.filename_resp = filename;
if isequal(filename,0)
   disp('User selected Cancel')
else
    filename = cellstr(filename);
    respNum = size(filename,2);
    for i = 1:respNum
            disp(['User selected response', fullfile(pathname, filename{i})])
            if strfind(filename{i},'.mat')
                eval(['resp',int2str(i), '=importdata(fullfile(pathname, filename{i}));']);
            end
            if strfind(filename{i},'.t64')
                cspikes = LoadSpikes(fullfile(pathname, filename{i}));
                eval(['resp',int2str(i),'.times=cspikes{1,1}.T;']);
                eval(['resp',int2str(i),'.title=[];']);
            end
            if strfind(filename{i},'.tdms') % specifically for pavloven conditioning                
                eval(['resp',int2str(i), '=Loadtdms(fullfile(pathname, filename{i}));']);
            end
            eval(['handles.data.resp',int2str(i),'=resp',int2str(i),';']);
    end
    set(handles.offset_edt,'String',NaN)
    set(handles.resp_edt,'String',filename{1})
    set(handles.delTrial_edt,'String','NaN')
end

guidata(hObject,handles);
handles = guidata(hObject);



function trials_edt_Callback(hObject, eventdata, handles)
% hObject    handle to trials_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trials_edt as text
%        str2double(get(hObject,'String')) returns contents of trials_edt as a double


% --- Executes during object creation, after setting all properties.
function trials_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trials_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trialTo_edt_Callback(hObject, eventdata, handles)
% hObject    handle to trialTo_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trialTo_edt as text
%        str2double(get(hObject,'String')) returns contents of trialTo_edt as a double


% --- Executes during object creation, after setting all properties.
function trialTo_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trialTo_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ctrlTime_edt_Callback(hObject, eventdata, handles)
% hObject    handle to ctrlTime_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ctrlTime_edt as text
%        str2double(get(hObject,'String')) returns contents of ctrlTime_edt as a double


% --- Executes during object creation, after setting all properties.
function ctrlTime_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ctrlTime_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eCtrl_edt_Callback(hObject, eventdata, handles)
% hObject    handle to eCtrl_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eCtrl_edt as text
%        str2double(get(hObject,'String')) returns contents of eCtrl_edt as a double


% --- Executes during object creation, after setting all properties.
function eCtrl_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eCtrl_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function clims_edt_Callback(hObject, eventdata, handles)
% hObject    handle to clims_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of clims_edt as text
%        str2double(get(hObject,'String')) returns contents of clims_edt as a double


% --- Executes during object creation, after setting all properties.
function clims_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clims_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delTrial_edt_Callback(hObject, eventdata, handles)
% hObject    handle to delTrial_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delTrial_edt as text
%        str2double(get(hObject,'String')) returns contents of delTrial_edt as a double


% --- Executes during object creation, after setting all properties.
function delTrial_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delTrial_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PETH_pb.
function PETH_pb_Callback(hObject, eventdata, handles)
% hObject    handle to PETH_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
denoise = get(handles.radiobutton_denoise,'Value');
name = get(handles.radiobutton_name,'Value');
clims = str2num(get(handles.clims_edt,'String'));%important to use str2num
preTime = str2double(get(handles.preTime_edt,'String'));
postTime = str2double(get(handles.postTime_edt,'String'));
trials = str2num(get(handles.trials_edt,'String'));
sTrial = trials(1); trialTo = trials(2);
delTrial = str2num(get(handles.delTrial_edt,'String'));
ctrlTime = str2num(get(handles.ctrlTime_edt,'String'));
sCtrl = ctrlTime(1); eCtrl = ctrlTime(2);
bin = str2double(get(handles.bin_edt,'String'));
xp2 = str2double(get(handles.edit_xp2,'String'));
resp1 = handles.data.resp1;
x = -preTime+bin:bin:postTime;
stimNum = handles.data.stimNum;
mPETH = x;
lineFig = figure;
set(gca,'LineWidth',3,'FontSize',25)

for i = 1:1:stimNum
    
    % ERF mERF sem calculation
    eval(['stim',int2str(i),'=handles.data.stim',int2str(i),';']);
    eval(['cStim = triggerPretreat(stim',int2str(i),',sTrial,trialTo,handles);']);
    assignin('base',['cStim' int2str(i)],cStim);%%%%%20210820
    if ~isempty(strfind(upper(resp1.title),'GC6'))% spike2 specific for waveform channel or resp1.title == 'GC6'
        offset = str2double(get(handles.offset_edt,'String'));
        if isnan(offset)
            % offset calculation  mean value of first 5 s
            num = round(5/resp1.interval);
            offset = max(resp1.values(1:num));
            set(handles.offset_edt,'String',num2str(offset))
        end
        [peaks,cERF,cMaxPks] = ERFPeak(resp1,cStim,preTime,postTime,sCtrl,eCtrl,offset,0);
        assignin('base',['ERF' int2str(i)],cERF);
        assignin('base',['GC6Pks' int2str(i)],cMaxPks);
        eval(['handles.data.ERF',int2str(i),'=cERF;']);
        eval(['handles.data.GC6Pks',int2str(i),'= cMaxPks;']);
    else
        peaks = resp1;
        %%%%%20210820 added by llh; exclude noise interspike interval
        %%%%%smaller than 2 ms
        a=diff(peaks.times);
%         b=find(a<0.002);
        peaks.times(a<0.002)=[];
        peaks.values(a<0.002,:)=[];
    end    
    assignin('base',['peaks' int2str(i)],peaks);
    %[cERF,cmERF] = ERFWave(stimTimes,resp1,preTime,postTime,sCtrl,eCtrl,offset);
    [cspikeCount,cmPETH,base_spike,stim_spike] = PETHDraw(cStim,peaks, preTime,postTime,bin,i,delTrial,denoise,xp2); 
    
    %%%%%%%%%%%%%%%%%%%the following lines are added by llh at 20180102
    yrange = get(gca,'YLim');
    set(gca,'Xlim',[-preTime postTime],'YLim',yrange,'LineWidth',3,'FontName','Arial','FontSize',20,'TickDir','out');
%     xP = 0;
%     line([xP xP],yrange,'LineStyle',':','Color',[0 0 1],'LineWidth',3);
%     line([xp2 xp2],yrange,'LineStyle',':','Color',[0 0 1],'LineWidth',3);
    box off;
%     xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     ylabel('Trial','FontName','Arial','FontSize',25,'FontWeight','Bold');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%     if ~isnan(delTrial)
%         cspikeCount(delTrial,:) = [];
%         cmPETH = mean(cspikeCount)/bin;
%     end
%%%%%%%20210819 added by llh
    noise =  [];
%     for j=1:size(cspikeCount,1)
% %         cspikeCount(j,:) = smooth(cspikeCount(j,:));    
%         if any(cspikeCount(j,1:20)>5) || any(cspikeCount(j,26:end)>5) || sum(cspikeCount(j,:))<2
% %             disp('noise trial');
%             noise = [noise;j];
%         end
%     end
    cPETH = cspikeCount/bin;
    figure(lineFig)
    areaErrorbar(x,cPETH,i)
    % output to workspace
    assignin('base',['PETH' int2str(i)],cPETH);
    eval(['handles.data.PETH',int2str(i),'=cPETH;']);
    mPETH = [mPETH;cmPETH];
end
figure(lineFig)
set(gca,'YLim',clims);
yrange = get(gca,'YLim');
if yrange(1) > 0
    yrange(1) = 0;
end
set(gca,'Xlim',[-preTime postTime],'YLim',yrange,'LineWidth',3,'FontName','Arial','FontSize',20,'TickDir','out');
xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
ylabel('Spikes/s','FontName','Arial','FontSize',25,'FontWeight','Bold');
xP = 0;
line([xP xP],yrange,'LineStyle',':','Color',[0 0 0],'LineWidth',3)
line([xp2 xp2],yrange,'LineStyle',':','Color',[0 0 0],'LineWidth',3)
hold off


%%%20210819 added by llh
% figure;
% bar(x,mean(cPETH),'BarWidth',1,'FaceColor','black');
% set(gca,'Xlim',[-preTime postTime],'YLim',yrange,'LineWidth',3,'FontName','Arial','FontSize',20,'TickDir','out');
% xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
% ylabel('Spikes/s','FontName','Arial','FontSize',25,'FontWeight','Bold');
% xP = 0;
% line([xP xP],yrange,'LineStyle',':','Color',[0 0 0],'LineWidth',3)
% line([xp2 xp2],yrange,'LineStyle',':','Color',[0 0 0],'LineWidth',3)
% hold off
assignin('base','noise',noise);
assignin('base','mPETH',mPETH);
handles.data.mPETH = mPETH;
handles.lineFig = lineFig;
% vData = handles.data;
vData.cspikeCount = cspikeCount;
vData.mPETH = mPETH;
vData.cPETH = cPETH;
vData.noise = noise;
vData.delTrial = delTrial;
vData.base_spike = base_spike;
vData.stim_spike = stim_spike;
filename = handles.filename;
dataFilename = strrep(filename,'.mat','_ANA.mat');
% dataFilename = strrep(filename,'.mat','_analysis.mat');
try
    data_filename = strrep(dataFilename,'.mat',handles.filename_stim)
catch
    disp('can not compose filename');
end
% save(data_filename, '-struct', 'vData');
save(' PETH analysis', '-struct', 'vData');

guidata(hObject,handles);
handles = guidata(hObject);





function bin_edt_Callback(hObject, eventdata, handles)
% hObject    handle to bin_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bin_edt as text
%        str2double(get(hObject,'String')) returns contents of bin_edt as a double


% --- Executes during object creation, after setting all properties.
function bin_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bin_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotSigPnt_rb.
function plotSigPnt_rb_Callback(hObject, eventdata, handles)
% hObject    handle to plotSigPnt_rb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotSigPnt_rb
guidata(hObject,handles);
handles = guidata(hObject);
plotSigTag = get(hObject,'Value') ;
stimNum = handles.data.stimNum;
if  plotSigTag == 1 & stimNum == 1
    resp1 = handles.data.resp1;
    preTime = str2double(get(handles.preTime_edt,'String'));
    postTime = str2double(get(handles.postTime_edt,'String'));
    trials = str2num(get(handles.trials_edt,'String'));
    sTrial = trials(1); trialTo = trials(2);
    stim1 = handles.data.stim1;
    cStim = triggerPretreat(stim1,sTrial,trialTo,handles);
    delTrial = str2num(get(handles.delTrial_edt,'String'));
    ctrlTime = str2num(get(handles.ctrlTime_edt,'String'));
    sCtrl = ctrlTime(1); eCtrl = ctrlTime(2);
    if ~isempty(strfind(upper(resp1.title),'GC6'))% spike2 specific for waveform channel or resp1.title == 'GC6'
        interval = resp1.interval;
        x = -preTime:interval:postTime-interval;
        offset = str2double(get(handles.offset_edt,'String'));
         if isnan(offset)
        % offset calculation  mean value of first 5 s
        num = round(5/resp1.interval);
        offset = max(resp1.values(1:num));
        set(handles.offset_edt,'String',num2str(offset))
        end
        [cERF,cmERF] = ERFWave(cStim,resp1,preTime,postTime,sCtrl,eCtrl,offset,0);
        % areaError line plot
        if ~isnan(delTrial)
        cERF(delTrial,:) = [];
        cmERF = mean(cERF);
        end
        trialLen = size(cERF,2);
        baseLen =abs((eCtrl - sCtrl)/interval);
        baseS = (preTime + sCtrl)./(preTime + postTime)*trialLen + 1;
        cCtrl = cERF(:,baseS:baseS + baseLen - 1);
        ctrl = reshape(cCtrl,[],1);
%         figure
%         hist(baseERF)
        s = skewness(ctrl);
        % thresh = 2.91*mad(baseERF,1)
        SNRp =  prctile(ctrl,99.9)./std(ctrl);
        SNRn = prctile(ctrl,0.1)./std(ctrl);
        report = sprintf('SNR: %0.2f  %0.2f  skew: %0.2f\n',SNRp,SNRn,s);
        fprintf('%s\n',report);
        if ~any(findobj(allchild(0), 'flat', 'type', 'figure') == handles.lineFig)
            handles.lineFig = figure;
            areaErrorbar(x,cERF,1);
        end
        mplot = cmERF;
        figure(handles.lineFig)
        hold on
        cData = cERF;
        if length(ctrl) > 1000
            threshH = prctile(ctrl,95);
            threshL = prctile(ctrl,5);
            posSigIdx = mplot > threshH;
            negSigIdx = mplot < threshL;  
        else
            baseMean = nanmean(ctrl);
            mCtrl = nanmean(cCtrl,2);
            dataCtrl =  repmat(mCtrl,1,size(cData,2));
            dif=cData-dataCtrl; %difference between conditions
            alpha_level = 0.05;
            [cpval, t_orig, crit_t, est_alpha, seed_state]=mult_comp_perm_t1(dif,1000,0,alpha_level);
            posSigIdx = mplot > baseMean & cpval<alpha_level;
            negSigIdx = mplot < baseMean & cpval<alpha_level;
        end        
        sigRange = sigPntPlot2(x,mplot,posSigIdx,negSigIdx)
        yrange = get(gca,'YLim');
        if yrange(2)<=30 & yrange(1) >= -10
            yrange = [-10 20];
        end
        set(gca,'Xlim',[-preTime postTime],'YLim',yrange,'LineWidth',3,'FontName','Arial','FontSize',20,'TickDir','out');
        xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
        ylabel('\Delta F/F(%)','FontName','Arial','FontSize',25,'FontWeight','Bold');
        xP = 0;
        plot([xP xP],yrange,'LineStyle',':','Color',[0 0 0],'LineWidth',3)
        hold off
    end
    if isempty(strfind(upper(resp1.title),'GC6'))
          bin = str2double(get(handles.bin_edt,'String'));
          x = -preTime:bin:postTime;
         [cspikeCount,cmPETH] = PETHDraw(cStim,resp1, preTime,postTime,bin,1);    
         if ~isnan(delTrial)
            cspikeCount(delTrial,:) = [];
            cmPETH = mean(cspikeCount)/bin;
        end
        cPETH = cspikeCount/bin;
        trialLen = size(cPETH,2);
        baseLen =abs((eCtrl - sCtrl)/bin);
        baseS = (preTime + sCtrl)./(preTime + postTime)*trialLen + 1;
        cCtrl= cPETH(:,baseS:baseS + baseLen - 1);
        ctrl = reshape(cCtrl,[],1);
        if ~any(findobj(allchild(0), 'flat', 'type', 'figure') == handles.lineFig)
            handles.lineFig = figure;
            areaErrorbar(x,cPETH,1);
        end
        mplot = cmPETH;
        figure(handles.lineFig)
        hold on
        cData = cPETH;
        if length(ctrl) > 1000
            threshH = prctile(ctrl,95);
            threshL = prctile(ctrl,5);
            posSigIdx = mplot > threshH;
            negSigIdx = mplot < threshL;  
        else
            baseMean = nanmean(ctrl);
            mCtrl = nanmean(cCtrl,2);
            dataCtrl =  repmat(mCtrl,1,size(cData,2));
            dif=cData-dataCtrl; %difference between conditions
            alpha_level = 0.05;
            [cpval, t_orig, crit_t, est_alpha, seed_state]=mult_comp_perm_t1(dif,1000,0,alpha_level);
            posSigIdx = mplot > baseMean & cpval<alpha_level;
            negSigIdx = mplot < baseMean & cpval<alpha_level;
        end        
        sigRange = sigPntPlot2(x,mplot,posSigIdx,negSigIdx)
        yrange = get(gca,'YLim');
        if yrange(1) > 0
        yrange(1) = 0;
        end
        set(gca,'Xlim',[-preTime postTime],'YLim',yrange,'LineWidth',3,'FontName','Arial','FontSize',20,'TickDir','out');
        xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
        ylabel('Spikes/s','FontName','Arial','FontSize',25,'FontWeight','Bold');
        xP = 0;
        line([xP xP],yrange,'LineStyle',':','Color',[0 0 0],'LineWidth',3)
        hold off
    end
end
if  plotSigTag == 1 & stimNum == 2
    resp1 = handles.data.resp1;
    preTime = str2double(get(handles.preTime_edt,'String'));
    postTime = str2double(get(handles.postTime_edt,'String'));
    interval = resp1.interval;
    x = -preTime:interval:postTime-interval;
    AUC = x;
        [FPR, TPR, cAUC] = auROC(handles.data.ERF1, handles.data.ERF2);
        handles.data.FPR = FPR;
        handles.data.TPR = TPR;
        AUC = [AUC;cell2mat(cAUC)];
        handles.data.AUC = AUC; 
        figure
        plot(x,AUC(2,:),'LineWidth',3,'Color',[0,0.447,0.741]);
        hold on
        line([-preTime postTime],[0.5 0.5],'LineWidth',3,'LineStyle',':','Color','k');
        hold off
        set(gca,'Xlim',[-preTime postTime],'YLim',[0 1],'LineWidth',3,'FontName','Arial','FontSize',20,'TickDir','out');
        xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
        ylabel('auROC','FontName','Arial','FontSize',25,'FontWeight','Bold');
    assignin('base','AUC',AUC);
end

% --- Executes on button press in LEST_rb.
function LEST_rb_Callback(hObject, eventdata, handles)
% hObject    handle to LEST_rb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LEST_rb
guidata(hObject,handles);
handles = guidata(hObject);
vData = handles.vData;
if get(hObject,'Value')
    [R L C P Indiff] = LEST(handles.data.stim1,handles.data.resp1);
    vData.optrode_r = [R(1) L(1) C(1) P(1)];
    vData.light_stim1 = handles.data.stim1;
    handles.vData = vData;
end


guidata(hObject,handles);
handles = guidata(hObject);


% --- Executes on button press in permStep_rb.
function permStep_rb_Callback(hObject, eventdata, handles)
% hObject    handle to permStep_rb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of permStep_rb
guidata(hObject,handles);
handles = guidata(hObject);
stepPermTag = get(handles.permStep_rb,'Value');
if stepPermTag
    stimNum = handles.data.stimNum;
    resp1 = handles.data.resp1;
    preTime = str2double(get(handles.preTime_edt,'String'));
    postTime = str2double(get(handles.postTime_edt,'String'));
    trials = str2num(get(handles.trials_edt,'String'));
    sTrial = trials(1); trialTo = trials(2);
    delTrial = str2num(get(handles.delTrial_edt,'String'));
    ctrlTime = str2num(get(handles.ctrlTime_edt,'String'));
    sCtrl = ctrlTime(1); eCtrl = ctrlTime(2);

    step = str2double(get(handles.eventStep_edt,'String'));
    wnum = floor((preTime + postTime)/step); % window number
    pvalStep = nan(stimNum,wnum);
    nAUC = nan(stimNum,wnum);

% GC6 signal
if ~isempty(strfind(upper(resp1.title),'GC6'))
    % offset calculation
    offset = str2double(get(handles.offset_edt,'String'));
    if isnan(offset)
    % offset calculation  mean value of first 5 s
    num = round(5/resp1.interval);
    offset = max(resp1.values(1:num));
    set(handles.offset_edt,'String',num2str(offset))
    end
    % ERF calculation
    interval = resp1.interval;
    x = -preTime:interval:postTime-interval;
    for i = 1:1:stimNum    
        % ERF mERF sem calculation
        eval(['stim',int2str(i),'=handles.data.stim',int2str(i),';']);
        eval(['cStim = triggerPretreat(stim',int2str(i),',sTrial,trialTo,handles);']);
        [cERF,cmERF] = ERFWave(cStim,resp1,preTime,postTime,sCtrl,eCtrl,offset,0);
        % areaError line plot
        if ~isnan(delTrial)
        cERF(delTrial,:) = [];
        cmERF = mean(cERF);
        end
        % AUC contribution
        for n = 1:1:wnum
        nAUC(i,n) = aucCal(x,[(n-1)*step - preTime n*step - preTime],cmERF);        
        end
        nAUC(i,:) = nAUC(i,:)./sum(nAUC(i,:))*100;
     
        % step based pvalue
        % baseDiff
        trialNum = size(cERF,1);
        trialLen = size(cERF,2);
        baseLen =abs((eCtrl - sCtrl)/interval);
        edges = floor(min(min(cERF))):1:ceil(max(max(cERF)));  % bin boundaries
        baseS = (preTime + sCtrl)./(preTime + postTime)*trialLen + 1; 
        permNum = 20;
        permBaseS = randperm(abs(baseLen - step/interval),permNum);
        baseDiff = nan(trialNum,permNum,permNum);
        for m = 1:1:trialNum
            for n = 1:1:permNum
                hc1 = histc(cERF(m,baseS+permBaseS(n) - 1:baseS+permBaseS(n) - 1+step/interval),edges);
                D1 = hc1./sum(hc1);
                for j = n:1:permNum
                    hc2 = histc(cERF(m,baseS+permBaseS(j) - 1:baseS+permBaseS(j) - 1+step/interval),edges);
                    D2 = hc2./sum(hc2);
%                     assignin('base','D1',D1);
%                     assignin('base','D2',D2);
                    baseDiff(m,n,j) = JSdiv(D1,D2); 
                end
            end
        end
%     assignin('base','baseDiff',baseDiff);
    
        % data diff per 1 s from 0 s to end
        baseERF = cERF(:,baseS:baseS + round(step/interval) - 1);
%     idx0 =  abs(preTime)./(preTime + postTime)*trialLen + 1;
        dataDiff = nan(trialNum,wnum);
        for m = 1:1:trialNum
             hc1 = histc(baseERF(m,:),edges);
             D1 = hc1./sum(hc1);  
            for n = 1:1:wnum
             cDataERF = cERF(m,1+ (n-1)*round(step/interval):n*round(step/interval));             
             hc2 = histc(cDataERF,edges);
             D2 = hc2./sum(hc2);
             dataDiff(m,n) = JSdiv(D1,D2);  % pairwise modified JS-divergence (real metric!)
%              assignin('base','dataDiff',dataDiff);
            end
        end   
        % make p
        nullhypdiff = baseDiff(~isnan(baseDiff));   % nullhypothesis
        sno = length(nullhypdiff(:));   % sample size for nullhyp. distribution
        mdDataDiff = median(dataDiff);
        for n = 1:1:wnum
        testDiff = mdDataDiff(n);
        pvalStep(i,n) = double(length(find(nullhypdiff>=testDiff)) / sno);
        end  
   
    end
end

% PETH signal
if isempty(strfind(upper(resp1.title),'GC6'))
    bin = str2double(get(handles.bin_edt,'String'));
    x = -preTime:bin:postTime;
    for i = 1:1:stimNum
         eval(['stim',int2str(i),'=handles.data.stim',int2str(i),';']);
         eval(['cStim = triggerPretreat(stim',int2str(i),',sTrial,trialTo,handles);']);
         [cspikeCount,cmPETH] = PETHDraw(cStim,resp1, preTime,postTime,bin,i);    
         if ~isnan(delTrial)
            cspikeCount(delTrial,:) = [];
            cmPETH = mean(cspikeCount)/bin;
        end
        cPETH = cspikeCount/bin;
        % AUC contribution
        for n = 1:1:wnum
            nAUC(i,n) = aucCal(x,[(n-1)*step - preTime n*step - preTime],cmPETH);        
        end
        nAUC(i,:) = nAUC(i,:)./sum(nAUC(i,:))*100;        
    end    
end

assignin('base','nAUC',nAUC);
assignin('base','nAUC',nAUC);
handles.data.pvalStep = pvalStep;
handles.data.pvalStep = pvalStep;
vData = handles.data;
save('DataOut.mat','-struct','vData')

end




function eventStep_edt_Callback(hObject, eventdata, handles)
% hObject    handle to eventStep_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eventStep_edt as text
%        str2double(get(hObject,'String')) returns contents of eventStep_edt as a double


% --- Executes during object creation, after setting all properties.
function eventStep_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eventStep_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_TriggerTimes.
function pushbutton_TriggerTimes_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_TriggerTimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);

clims = str2num(get(handles.clims_edt,'String'));
bin = str2double(get(handles.bin_edt,'String'));
pre_stim_time = str2double(get(handles.preTime_edt,'String'));
post_stim_time = str2double(get(handles.postTime_edt,'String'));
% data = load(file);
% data = get(handles.stim_edt,'UserData');
data = handles.data.stim1;
% fname = fieldnames(data);

values_A1 = data.values;
interval_A1 = data.interval;
% values_A1(1:GC6_start) = 0;
% assignin('base','values_A1',values_A1); 
% values_A1 = eval(['data.',char(fname(1)),'.values']);
% interval_A1 = eval(['data.',char(fname(1)),'.interval']);
times_A1 = 0.1:0.1:floor(length(values_A1)/10);
values_A1 = values_A1';
bin = 0.1;


% find trigger-times that runing at least 3 second,and almost immobility 2
% second before runing
a = -pre_stim_time/interval_A1;
b = post_stim_time/interval_A1;

k = 1;
for i = a:length(values_A1)-b+1
    B = values_A1(i:i+b-1);
    C = values_A1(i-a+1:i);
    if (length(find(B > 0))>=b*0.92) && (length(find(C > 0))<=b*0.2 && max(B) > 10)
        cTrigger_times(k) = times_A1(i);
        k = k+1;   
    end
    
    if (length(find(B > 0))<=a*0.25) && (length(find(C > 0))>=a*0.85 && max(C) > 8)
        cTrigger_times2(k) = times_A1(i);
        k = k+1;   
    end
end
assignin('base','cTrigger_times2',cTrigger_times2); 

k2 = 1;
for j = 1:(length(cTrigger_times)-1)
    df = cTrigger_times(j+1)-cTrigger_times(j);
    if df > 5
        trigger_times(k2) = cTrigger_times(j+1);
    end
    k2 = k2+1;
end
trigger_times = (trigger_times(logical(trigger_times)))';
% trigger_times = ([cTrigger_times(1),trigger_times])';
assignin('base','trigger_times',trigger_times); 
% trigger_times = [117;197.200000000000;309.600000000000;321.900000000000;405.400000000000;415.700000000000;471.800000000000;487.800000000000;523.800000000000];
k3 = 1;
for j = 1:(length(cTrigger_times2)-1)
    df = cTrigger_times2(j+1)-cTrigger_times2(j);
    if df > 5
        trigger_times2(k3) = cTrigger_times2(j+1);
    end
    k3 = k3+1;
end
trigger_times2 = trigger_times2(logical(trigger_times2));
% trigger_times2(13) = [];
% trigger_times2 = ([cTrigger_times2(1),trigger_times2])';
assignin('base','trigger_times2',trigger_times2');



n = length(trigger_times);
speed =[];
for i = 1:n
   speed = [speed;values_A1(round((trigger_times(i)+pre_stim_time)*10):round((trigger_times(i)+post_stim_time)*10))];
end

speed = speed*(pi*23.5/600)/bin;%换算成cm/s
assignin('base','speed',speed);

n2 = length(trigger_times2);
speed2 =[];
for i = 1:n2
   speed2 = [speed2;values_A1(round((trigger_times2(i)+pre_stim_time)*10):round((trigger_times2(i)+post_stim_time)*10))];
end

speed2 = speed2*(pi*23.5/600)/bin;%换算成cm/s
assignin('base','speed2',speed2);

vData.trigger_times = trigger_times;
vData.speed = speed;
vData.trigger_times2 = trigger_times2;
vData.speed2 = speed2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tn = pre_stim_time:bin:post_stim_time;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y=1:length(trigger_times);
figure; 
subplot(2,1,1);
plotHeatmap(tn,speed,clims);
% imagesc(tn,y,speed);
xlabel('time/s');
ylabel('trail');

spa = mean(speed);
spe = std(speed)/sqrt(length(speed-1));
assignin('base','spa',spa);
assignin('base','spe',spe);
assignin('base','tn',tn);
% tn = -5:bin:5-bin;
% spa = [];
% spe = [];
% for i=1:length(tn)
%     spa=[spa,mean(speed(1:n,i))];
%     spe=[spe,std(speed(1:n,i))/sqrt(length(speed(1:n,i))-1)];
% end;
vData.spa = spa;
% handles.spa = spa;
vData.spe = spe;
vData.tn = tn;

subplot(2,1,2);
% drawErrorLine(tn,spa,spe,'r',0.2);
areaErrorbar(tn,spa,1);
set(gca,'YLim',[-5 50]);
assignin('base','spa',spa);
xlabel('time(s)');
ylabel('speed(cm/s)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tn = -5:bin:5-bin;
% y = 1:length(trigger_times2);
% figure; 
% subplot(2,1,1);
% plotHeatmap(tn,speed2,clims);
% % imagesc(tn,y,speed2);
% xlabel('time/s');
% ylabel('trail');
% 
% 
% % tn = -5:bin:5-bin;
% spa2 = [];
% spe2 = [];
% for i=1:length(tn)
%     spa2=[spa2,mean(speed2(1:n2,i))];
%     spe2=[spe2,std(speed2(1:n2,i))/sqrt(length(speed2(1:n2,i))-1)];
% end;
% vData.spa2 = spa2;
% vData.spe2 = spe2;
% handles.vData = vData;
% 
% subplot(2,1,2);
% % drawErrorLine(tn,spa2,spe2,'r',0.2);
% areaErrorbar(tn,spa2,1);
% set(gca,'YLim',[-5 50]);
% xlabel('time(s)');
% ylabel('speed(cm/s)');
handles.vData = vData;
guidata(hObject,handles);
handles = guidata(hObject);

% --- Executes on button press in pushbutton_Analysis.
function pushbutton_Analysis_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
filename = handles.filename_resp;
name = get(handles.radiobutton_name,'Value');
vData = handles.vData;
speed = vData.speed;
start_time = handles.data.start_t1.times(1)

clims = str2num(get(handles.clims_edt,'String'));
ylim_speed = str2num(get(handles.edit_ylim_speed, 'String'));
ylim_spike = str2num(get(handles.edit_ylim_spike, 'String'));
bin = str2double(get(handles.bin_edt,'String'));
pre_stim_time = str2double(get(handles.preTime_edt,'String'));
post_stim_time = str2double(get(handles.postTime_edt,'String'));
ctrlTime = str2num(get(handles.ctrlTime_edt,'String'));
control_from = ctrlTime(1);
control_to = ctrlTime(2);

%%%%%find backward or forward times
light_back = vData.light_back*bin;
light_fore = vData.light_fore*bin;
trigger_times = light_back+start_time;
trigger_times2 = light_fore+start_time;
vData.trigger_times = trigger_times;
vData.trigger_times2 = trigger_times2;
%%%%%get response data
Data1 = handles.data.resp1;
spike_times = Data1.times;

basal_time = pre_stim_time;
odor_time = post_stim_time;
bin = 0.05;%%%%%%%%%%%%%%%%%%
width = 0.01;
sigma = 0.1;
raster_size = 0.4; %%%0.4
raster_width = 1;
raster = 1;

%%%%%%%%%%%%%backward locomotion
h = figure;
% title(strrep(filename(1:end-4), '\', '\\'));
% title(strrep(filename, '.mat', ' back.mat'));
spike_count = cell(length(trigger_times),1);
gauss_data = cell(length(-basal_time:width:odor_time),1);
spike_sequence1 = cell(length(trigger_times),1);
for i=1:length(trigger_times)
       k = spike_times >= trigger_times(i) - basal_time & spike_times <= trigger_times(i) + odor_time;
       spike_sequence = spike_times(k)-trigger_times(i);
       spike_sequence1{i,1} = spike_sequence;
       if raster
           hold on;
           subplot(2,1,1);
           stem_handle = stem(spike_sequence,i+ones(length(spike_sequence),1)*raster_size,...
               'BaseValue',i,'color','black','marker','none','linewidth',raster_width,'ShowBaseLine','off');
           hold on;
       end
       
       p1 = histc(spike_sequence,-basal_time:bin:odor_time);
       p1 = p1( : )';
       spike_count{i,1} = p1;
       gauss_data{i,1} = zeros(1,length(-basal_time:width:odor_time));
       for j =1:length(spike_sequence)
           gauss_data{i,1} = gauss_data{i,1} + gaussmf(-basal_time:width:odor_time,[sigma,spike_sequence(j)]);
       end
end
spike_sequence1 = cell2mat(spike_sequence1);
spike_count = cell2mat(spike_count);
gauss_data = cell2mat(gauss_data);
assignin('base','spike_sequence1',spike_sequence1);
assignin('base','spike_count',spike_count);
assignin('base','gauss_data',gauss_data);
if raster
%     baseline_handle = get(stem_handle,'BaseLine');
%     set(baseline_handle,'LineStyle','none')
    set(gca,'xlim',[-basal_time odor_time]);
    set(gca,'ylim',[0 length(trigger_times) + 1]);
    set(gca,'LineWidth',3,'FontSize',15,'FontWeight','Bold','TickDir','out');
    ylabel('Trial #','FontSize',15,'FontWeight','Bold');
end
% basal_time = basal_time - bin*2;
% odor_time = odor_time - bin*2;

% spike_count = spike_count(:,3:end-2);
spike_count = spike_count(:,1:end-1);
gauss_data = gauss_data(:,(2*bin/width)+1 : end - 2*bin/width);
spike_probability = mean(spike_count & 1);
psth = spike_count./bin;%for PSTH bar plot
psth_mean = mean(spike_count)/bin;%for PSTH bar plot
gaus = mean(gauss_data)/(sigma*(pi*2)^0.5);
assignin('base','psth',psth);
assignin('base','gaus',gaus);
assignin('base','spike_probability',spike_probability);

z_score_psth = (psth_mean-mean(psth_mean))./std(psth_mean);
z_score_gaus = (gaus-mean(gaus))/std(gaus);
psth_sem = std(psth)/sqrt(length(trigger_times-1));
gaus_sem = std(gaus)/sqrt(length(trigger_times-1));
vData.psth = psth;
vData.psth_mean = psth_mean;
vData.psth_sem = psth_sem;
vData.z_score_psth = z_score_psth;

back_name = strrep(filename,'.mat',' back.mat');
title(back_name,'FontSize',15);
subplot(2,1,2);
gcf_Position=[1,250,600,400];
set(gcf,'Position',gcf_Position);
% bar((-basal_time:bin:odor_time)+bin*0.5,psth,'BarWidth',1,'FaceColor','black');
% %     warning('off'); 
% %     xlabel('Time (s)');
% ylabel('Spikes(Hz)');
% set(gca,'Xlim',[-basal_time odor_time]);
x = -basal_time:bin:odor_time-bin;
drawErrorLine(x,psth_mean,psth_sem,'k',0.2);
set(gca,'LineWidth',3,'FontSize',15,'FontWeight','Bold','TickDir','out');
set(gca,'xlim',[-basal_time odor_time]);
xlabel('Time (s)','FontSize',15,'FontWeight','Bold');
ylabel('Spikes/s','FontSize',15,'FontWeight','Bold');
hold on
% 
tn = vData.tn;
speedb = vData.speedb;
speedb_mean = vData.speedb_mean;
speedb_sem = vData.speedb_sem;
haxes1 = gca; % handle to axes
set(haxes1,'xtick',[]);
set(haxes1,'XColor','k','YColor','k');
% set(haxes1,'ylim',ylim_spike);
set(haxes1,'YLim',[0 max(psth_mean)+max(psth_sem)]); 
haxes1_pos = get(haxes1,'Position'); % store position of first axes
haxes2 = axes('Position',haxes1_pos,...
              'XAxisLocation','bottom',...
              'YAxisLocation','right',...
              'color','none');
set(haxes2,'XColor','k','YColor','r');
set(haxes2,'YLim',ylim_speed); 
areaErrorbar(tn,speedb,1);
set(gca,'LineWidth',3,'FontSize',15,'FontWeight','Bold','TickDir','out');
% drawErrorLine(tn,spa,spe,'r',0.2);
set(haxes2,'FontSize',15,'FontWeight','Bold');
ylabel('Speed (cm/s)','FontSize',10,'FontWeight','Bold');
xP = 0;
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);

% SAVE plot
outputfilename = [pwd,'\figures\', filename(1:end-4) ' back spike.png'];
% outputfilename = strrep(filename,'.mat', ' back spike.png');
if name
    saveas(h,outputfilename,'png');
else
    saveas(h,'back spike.png','png');
end
% close(h)

 
%%%%%%%%%%forward locomotion---------------------------------------------------
forward_plot = 1;
if forward_plot
    speedf = vData.speedf;
    speedf_mean = vData.speedf_mean;
    speedf_sem = vData.speedf_sem;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    h = figure;
    spike_count2 = cell(length(trigger_times2),1);
    gauss_data2 = cell(length(-basal_time:width:odor_time),1);
    spike_sequence1 = cell(length(trigger_times2),1);
    for i=1:length(trigger_times2)
           k = spike_times >= trigger_times2(i) - basal_time & spike_times <= trigger_times2(i) + odor_time;
           spike_sequence = spike_times(k)-trigger_times2(i);
           spike_sequence1{i,1} = spike_sequence;
           if raster
               hold on;
               subplot(2,1,1);
               stem_handle = stem(spike_sequence,i+ones(length(spike_sequence),1)*raster_size,...
                   'BaseValue',i,'color','black','marker','none','linewidth',raster_width);
               hold on;
           end

           p1 = histc(spike_sequence,-basal_time:bin:odor_time);
           p1 = p1( : )';
           spike_count2{i,1} = p1;
           gauss_data2{i,1} = zeros(1,length(-basal_time:width:odor_time));
           for j =1:length(spike_sequence)
               gauss_data2{i,1} = gauss_data2{i,1} + gaussmf(-basal_time:width:odor_time,[sigma,spike_sequence(j)]);
           end
    end
    % spike_sequence1 = cell2mat(spike_sequence1);
    spike_count2 = cell2mat(spike_count2);
    gauss_data2 = cell2mat(gauss_data2);
    % assignin('base','spike_sequence1',spike_sequence1);
    assignin('base','spike_count2',spike_count2);
    assignin('base','gauss_data2',gauss_data2);

    if raster
        baseline_handle = get(stem_handle,'BaseLine');
        set(baseline_handle,'LineStyle','none')
        set(gca,'xlim',[-basal_time odor_time]);
        set(gca,'ylim',[0 length(trigger_times2) + 1]);
        set(gca,'LineWidth',3,'FontSize',15,'FontWeight','Bold','TickDir','out');
        ylabel('Trial #','FontSize',15,'FontWeight','Bold');
    end
%     basal_time = basal_time - bin*2;
%     odor_time = odor_time - bin*2;
%     spike_count2 = spike_count2(:,3:end-2);
    spike_count2 = spike_count2(:,1:end-1);
    gauss_data2 = gauss_data2(:,(2*bin/width)+1 : end - 2*bin/width);
    spike_probability2 = mean(spike_count2 & 1);
    psth2 = spike_count2./bin;%for PSTH bar plot
    psth2_mean = mean(spike_count2)/bin;%for PSTH bar plot
    gaus2 = mean(gauss_data2)/(sigma*(pi*2)^0.5);
    assignin('base','psth2',psth2);
    assignin('base','gaus2',gaus2);
    assignin('base','spike_probability2',spike_probability2);

    z_score_psth2 = (psth2_mean-mean(psth2_mean))./std(psth2_mean);
    z_score_gaus2 = (gaus2-mean(gaus2))/std(gaus2);
    psth2_sem = std(psth2)/sqrt(length(trigger_times2-1));
    gaus2_sem = std(gaus2)/sqrt(length(trigger_times2-1));
vData.psth2 = psth2;
vData.psth2_mean = psth2_mean;
vData.psth2_sem = psth2_sem;
vData.z_score_psth2 = z_score_psth2;

    back_name = strrep(filename,'.mat',' forward.mat');
    title(back_name,'FontSize',15);
    subplot(2,1,2);
    gcf_Position=[1,250,600,400];
    set(gcf,'Position',gcf_Position);
    % bar((-basal_time:bin:odor_time)+bin*0.5,psth,'BarWidth',1,'FaceColor','black');
    % %     warning('off'); 
    % %     xlabel('Time (s)');
    % ylabel('Spikes(Hz)');
    % set(gca,'Xlim',[-basal_time odor_time]);
%     x = -basal_time:bin:odor_time;
    drawErrorLine(x,psth2_mean,psth_sem,'k',0.2);
    set(gca,'LineWidth',3,'FontSize',15,'FontWeight','Bold','TickDir','out');
    set(gca,'xlim',[-basal_time odor_time]);
    xlabel('Time (s)','FontSize',15,'FontWeight','Bold');
    ylabel('Spikes/s','FontSize',15,'FontWeight','Bold');
    hold on
    % 
    tn = vData.tn;
    speedb = vData.speedb;
    speedb_mean = vData.speedb_mean;
    speedb_sem = vData.speedb_sem;
    haxes1 = gca; % handle to axes
    set(haxes1,'xtick',[]);
    set(haxes1,'XColor','k','YColor','k');
%     set(haxes1,'ylim',ylim_spike);
    set(haxes1,'YLim',[0 max(psth2_mean)+max(psth2_sem)]); 
    haxes1_pos = get(haxes1,'Position'); % store position of first axes
    haxes2 = axes('Position',haxes1_pos,...
                  'XAxisLocation','bottom',...
                  'YAxisLocation','right',...
                  'color','none');
    set(haxes2,'XColor','k','YColor','r');
    set(haxes2,'YLim',ylim_speed); 
    areaErrorbar(tn,speedf,1);
    set(gca,'LineWidth',3,'FontSize',15,'FontWeight','Bold','TickDir','out');
    % drawErrorLine(tn,spa,spe,'r',0.2);
    set(haxes2,'FontSize',15,'FontWeight','Bold');
    ylabel('Speed (cm/s)','FontSize',10,'FontWeight','Bold');
    xP = 0;
    line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);

    % SAVE plot
    outputfilename = [pwd,'\figures\', filename(1:end-4) 'back spike.png'];
%     outputfilename = strrep(handles.filename_resp,'.mat', ' back spike.png');
    if name
    saveas(h,outputfilename,'png');
    else
    saveas(h,'forward spike.png','png');
    end
    % close(h)
end

assignin('base','vData',vData);    
filename = handles.filename;
dataFilename = strrep(filename,'.dat','_analysis_.mat');
% dataFilename = strrep(filename,'.mat','_analysis.mat');
try
    data_filename = strrep(dataFilename,'.mat',handles.filename_resp);
catch
    disp('can not compose filename');
end
if name
    save(data_filename, '-struct', 'vData');
else
    save(' analysis', '-struct', 'vData');    
end
    
% times = 0.1:0.1:length(values_spike);  
% assignin('base','times',times);
% val1 = cell(1,length(trigger_times));
% for i=1:length(trigger_times)
%     k1 = times >= trigger_times(i) + pre_stim_time & times < trigger_times(i) + post_stim_time;
%     assignin('base','k1',k1);
%     val1{1,i} = values_spike(k1);
% end
% val1 = cell2mat(val1)';
% assignin('base','val1',val1);
% vData.val1 = val1;
% frequency = mean(val1(1:length(trigger_times),:));
% vData.frequency = frequency;
% tn = pre_stim_time:bin:post_stim_time-bin;
% % tn = pre_stim_time+bin:bin:post_stim_time;
% assignin('base','tn',tn);
% assignin('base','frequency',frequency);
% 
% n = length(trigger_times);
% spa = [];
% spe = [];
% for i=1:length(tn)
%     spa=[spa,mean(speed(1:n,i))];
%     spe=[spe,std(speed(1:n,i))/sqrt(length(speed(1:n,i))-1)];
% end;
% vData.spa = spa;
% vData.spe = spe;
% assignin('base','spa',spa);
% assignin('base','spe',spe);
% 
% 
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure
% gcf_Position=[1,1,600,400];
% set(gcf,'Position',gcf_Position);
% % gca_Position=[.10 .10 .80 .80];
% % set(gca,'Position',gca_Position);
% % pre_stim_time+bin:bin:post_stim_time;
% % hist(val1,30);
% bar(tn+bin,frequency,1.0);
% set(gca,'xLim',[pre_stim_time post_stim_time+bin]);
% ylabel('Firing rate(Hz)','FontSize',10,'FontWeight','Bold');
% hold on
% 
% haxes1 = gca; % handle to axes
% set(haxes1,'xtick',[]);
% set(haxes1,'XColor','w','YColor','b');
% % ylim1 = [-max(max(frequency))*0.2 max(max(frequency))*1.2];
% % set(haxes1,'ylim',ylim1);
% haxes1_pos = get(haxes1,'Position'); % store position of first axes
% haxes2 = axes('Position',haxes1_pos,...
%               'XAxisLocation','bottom',...
%               'YAxisLocation','right',...
%               'color','none');
% set(haxes2,'XColor','k','YColor','r');
% % YLim2 = [-max(max(spa))*0.2 max(max(spe))*1.2];
% % set(haxes2,'YLim',YLim2);
% tn = pre_stim_time:bin:post_stim_time-bin;
% drawErrorLine(tn,spa,spe,'r',0.2);
% % set(gca,'xTick',1:1*10:length(frequency));
% % set(gca,'xTickLabel',tn(1):tn(end));
% set(haxes2,'FontSize',10,'FontWeight','Bold');
% xlabel('Time (s)');
% ylabel('Speed(cm/s)','FontSize',10,'FontWeight','Bold');
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% val2 = cell(1,length(trigger_times2));
% for i=1:length(trigger_times2)
%     k1 = times >= trigger_times2(i) + pre_stim_time & times < trigger_times2(i) + post_stim_time;
%     assignin('base','k1',k1);
%     val2{1,i} = values_spike(k1);
% end
% val2 = cell2mat(val2)';
% assignin('base','val2',val2);
% vData.val2 = val2;
% frequency2 = mean(val2(1:length(trigger_times2),:));
% vData.frequency2 = frequency2;
% tn = pre_stim_time:bin:post_stim_time-bin;
% % tn = pre_stim_time+bin:bin:post_stim_time;
% assignin('base','tn',tn);
% assignin('base','frequency2',frequency2);
% 
% n2 = length(trigger_times2);
% spa2 = [];
% spe2 = [];
% for i=1:length(tn)
%     spa2=[spa2,mean(speed2(1:n2,i))];
%     spe2=[spe2,std(speed2(1:n2,i))/sqrt(length(speed2(1:n2,i))-1)];
% end;
% vData.spa2 = spa2;
% vData.spe2 = spe2;
% assignin('base','spa2',spa2);
% assignin('base','spe2',spe2);
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure
% gcf_Position=[1,1,600,400];
% set(gcf,'Position',gcf_Position);
% % gca_Position=[.10 .10 .80 .80];
% % set(gca,'Position',gca_Position);
% bar(tn+bin,frequency2,1.0);
% set(gca,'xLim',[pre_stim_time post_stim_time+bin]);
% ylabel('Firing rate(Hz)','FontSize',10,'FontWeight','Bold');
% hold on
% 
% haxes1 = gca; % handle to axes
% set(haxes1,'xtick',[]);
% set(haxes1,'XColor','w','YColor','b');
% % ylim1 = [-max(max(frequency))*0.2 max(max(frequency))*1.2];
% % set(haxes1,'ylim',ylim1);
% haxes1_pos = get(haxes1,'Position'); % store position of first axes
% haxes2 = axes('Position',haxes1_pos,...
%               'XAxisLocation','bottom',...
%               'YAxisLocation','right',...
%               'color','none');
% set(haxes2,'XColor','k','YColor','r');
% % YLim2 = [-max(max(spa))*0.2 max(max(spe))*1.2];
% % set(haxes2,'YLim',YLim2);
% % tn = pre_stim_time:bin:post_stim_time-bin;
% drawErrorLine(tn,spa2,spe2,'r',0.2);
% % % set(gca,'xTick',1:1*10:length(frequency));
% % set(gca,'xTickLabel',tn(1):tn(end));
% set(haxes2,'FontSize',10,'FontWeight','Bold');
% xlabel('Time (s)');
% ylabel('Speed(cm/s)','FontSize',10,'FontWeight','Bold');

% matFileName = strrep(handles.file_path_and_name,'.mat',' vData.mat'); 
% save(matFileName,'-struct', 'vData');



function edit_xp2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_xp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_xp2 as text
%        str2double(get(hObject,'String')) returns contents of edit_xp2 as a double


% --- Executes during object creation, after setting all properties.
function edit_xp2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_xp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_denoise.
function radiobutton_denoise_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_denoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_denoise


% --- Executes on button press in pushbutton_speedAna.
function pushbutton_speedAna_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_speedAna (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
filename = handles.filename;
name = get(handles.radiobutton_name,'Value');
data1 = get(handles.edit_speed, 'UserData');
ylim_speed = str2num(get(handles.edit_ylim_speed, 'String'));
% ylim_gc = str2num(get(handles.edit_ylim_gc, 'String'));
% stopTrial = str2double(get(handles.edit_stop_trial,'String'));
% startTrial = str2double(get(handles.edit_start_trial,'String'));
bin = str2double(get(handles.bin_edt,'String'));
pre_stim_time = str2double(get(handles.preTime_edt,'String'));
post_stim_time = str2double(get(handles.postTime_edt,'String'));
xP2 = str2double(get(handles.edit_xp2,'String'));
delete_trial1 = str2num(get(handles.delTrial_edt,'String'));
delete_trial2 = str2num(get(handles.edit_deleteTrial2,'String'));
cmpp = str2double(get(handles.edit_cmpp,'String'));%%%%%60cm, 364 pixel, B102 左边屏蔽箱
% offset = str2double(get(handles.edit_offset,'String'));
% sCtrl = str2double(get(handles.edit_sCtrl,'String'));
% eCtrl = str2double(get(handles.edit_eCtrl,'String'));


%%%%%
assignin('base','data1',data1);
data1=data1(:,:);
t = data1(:,1); 
ym = data1(:,2); 
xm = data1(:,3); 
velocity = data1(:,4); 
back = data1(:,6); 
fore = data1(:,5); 
laser = data1(:,7); 
% sWater = data1(:,8); 
% GC6 = smooth(data1(:,9)); %%%%%gc6 signal intensity
% RFP = data1(:,10); 
light_back1 = find(laser==1&back==1);
light_fore1 = find(laser==1&fore==1);
light_back_c = find(laser==2&back==1);
light_fore_c = find(laser==2&fore==1);
light_back = sort([light_back1;light_back_c]);
light_fore = sort([light_fore1;light_fore_c]);
%calculate mouse travel distance
diff_xm = diff(xm);
diff_ym = diff(ym);
mDistance = sqrt(diff_xm.^2+diff_ym.^2); 
total_mDistance = sum(mDistance);
total_mDistance = cmpp*total_mDistance/100;  %%%meter
direction1 = diff_xm;%%%%NIBS B102 屏蔽箱内，logitech 930c,往左是前进，往右是后退
if get(handles.radiobutton_reverse,'Value')
    direction2 = find(direction1<0);%%%%%%%%20210924 正常情况后退>0,写反的数据改为<
else
    direction2 = find(direction1>0);%%%%%%%%20210924 正常情况后退>0,写反的数据改为<
end
% assignin('base','direction2',direction2);
speed1 = mDistance*cmpp/bin;
speed1 = smooth(speed1);
speed1(direction2) = -speed1(direction2); 
assignin('base','speed1',speed1);
vData.speed = speed1;

plot_track = 0;
if plot_track
    %%%%%%%%%%%%plot locomotion track%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%----------------------
    figure;
    plot(xm,t); hold on;
    set(gca,'xlim',[0 320]);
    xlabel('X ','FontName','Arial','FontSize',20,'FontWeight','Bold'); 
    % ylabel('Y','FontName','Arial','FontSize',20,'FontWeight','Bold');
    ylabel('Time (s)','FontName','Arial','FontSize',20,'FontWeight','Bold'); 

    %%%%%%%%%%%%%%%%plot locomotion speed-------------
    figure;
    subplot(2,1,1);
    plot(speed1,'k','LineWidth',1);hold on;
    legend(gca,'calculated speed');
    ylabel('Speed (cm/s)','FontName','Arial','FontSize',10,'FontWeight','Bold');
    subplot(2,1,2);
    plot(velocity,'b','LineWidth',1);hold on;
    set(gca,'ylim',[-40 40]);
    legend(gca,'raw speed');
    xlabel('Time (x0.1s)','FontName','Arial','FontSize',10,'FontWeight','Bold'); 
    ylabel('Speed (pixel)','FontName','Arial','FontSize',10,'FontWeight','Bold');
end

% %%%%find forward onset and backward onset
% disp('find locomotion onset......');
% [ onset_back, onset_for ] = start_pretreat( speed1,10,0.05,20 );
post_stim = 2;
[ onset_back, onset_for ] = start_pretreat2( speed1,t,pre_stim_time,post_stim,bin );
% [ onset_back, onset_for ] = start_pretreat3( back,fore,t,pre_stim_time,post_stim_time,0.1 );
light_back = onset_back;
light_fore = onset_for;
assignin('base','light_back',light_back);
assignin('base','light_fore',light_fore);
if ~isnan(delete_trial1)
    light_back(delete_trial1) = [];
end
if ~isempty(delete_trial2)
    light_fore(delete_trial2) = [];
end
% light_fore = light_fore(startTrial:stopTrial);
% light_back = light_back(startTrial:stopTrial);

%%%%%%%%%%%%%
if light_back(end)+abs(post_stim_time)/bin >= length(speed1)
    light_back(end) = [];
end
if light_back(1)-abs(pre_stim_time)/bin<=0
    light_back(1) = [];
end
if light_fore(end)+abs(post_stim_time)/bin >= length(speed1)
    light_fore(end) = [];
end
if light_fore(1)-abs(pre_stim_time)/bin<=0
    light_fore(1) = [];
end
vData.light_back = light_back;
vData.light_fore = light_fore;
%%
%%%%%%%backward speed signal
% trigger_times = water_times;
trigger_times = light_back;
n = length(trigger_times);
speed_back =[];
for i = 1:n
    start = round(trigger_times(i)-pre_stim_time/bin);
    stop = round(trigger_times(i)+post_stim_time/bin);
   speed_temp = speed1(start:stop);
   speed_back = [speed_back,speed_temp];
end
speed_back = speed_back';
speed_mean = mean(speed_back);
speed_sem = std(speed_back)/sqrt(size(speed_back,1)-1);
assignin('base','speed_back',speed_back);
assignin('base','speed_mean',speed_mean);
vData.speedb = speed_back;
vData.speedb_mean = speed_mean;
vData.speedb_sem = speed_sem;

% [ERF,mERF,semERF] = ERFWave3(trigger_times,resp,pre_stim_time,post_stim_time,sCtrl,eCtrl,offset,0);
% assignin('base','ERF',ERF);
% assignin('base','mERF',mERF);
% vData.ERF = ERF;
% vData.mERF = mERF;
% vData.semERF = semERF;

n = length(trigger_times);
tn = -pre_stim_time:bin:post_stim_time;
assignin('base','tn',tn);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h=figure;
clims = ylim_speed;
subplot(2,1,1);
% set(gcf,'Position',[1,1,700,700]);
% subplot(3,1,1);
drawErrorLine(tn,speed_mean,speed_sem,'r',0.2);
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
ylabel('Speed(cm/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');hold on;
haxes1 = gca; % handle to axes
set(haxes1,'xLim',[-pre_stim_time post_stim_time]);
set(haxes1,'yLim',clims);
xP = 0;
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
back_name = strrep(filename,'.dat',' back.mat');
title(back_name,'FontSize',15);

subplot(2,1,2);
plotHeatmap(tn,speed_back,clims);
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
% colorbar([0.93 0.22 0.03 0.2],'FontSize',5);
% colorbar;
% outputfilename0 = strrep(handles.filename_resp,'.mat', ' back speed.png')
outputfilename = [pwd,'\figures\',filename(1:end-4) ' backward speed.png']
if name
    saveas(h,outputfilename,'png');
else
    saveas(h,'backward speed.png','png');
end
%%%%%%%%%%%%%%%%%--------------------------
% figure
% clims_gc = ylim_gc;
% subplot(2,1,1);
% drawErrorLine(tn,mERF,semERF,'b',0.2);
% xP = 0;
% line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
% haxes2 = gca;
% set(haxes2,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
% % set(haxes2,'FontName','Arial','FontSize',10,'FontWeight','Bold');
% set(haxes2,'xLim',[pre_stim_time post_stim_time]);
% set(haxes2,'yLim',clims_gc);
% xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
% ylabel('\DeltaF /F (%)','FontName','Arial','FontSize',25,'FontWeight','Bold');
% title(strrep(filename(1:end-4), '.dat',' back.mat'),'FontSize',15);
% 
% subplot(2,1,2);
% plotHeatmap(tn,ERF,clims_gc);
% set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
% colorbar([0.93 0.22 0.03 0.2],'FontSize',5);
% colorbar;

%%forth movement----------------------------------------------------
trigger_times = light_fore;
n = length(trigger_times);
speed_fore =[];
for i = 1:n
   speed_temp = speed1(round(trigger_times(i)-pre_stim_time/bin):round(trigger_times(i)+post_stim_time/bin));
   speed_fore = [speed_fore,speed_temp];
end
speed_fore = speed_fore';
assignin('base','speed_fore',speed_fore);
speedf_mean = mean(speed_fore);
speedf_sem = std(speed_fore)/sqrt(size(speed_fore,1)-1);
vData.tn = tn;
vData.speedf = speed_fore;
vData.speedf_mean = speedf_mean;
vData.speedf_sem = speedf_sem;

% trigger_times = trigger_times;
% [ERF,mERF,semERF] = ERFWave3(trigger_times,resp,pre_stim_time,post_stim_time,sCtrl,eCtrl,offset,0);
% % assignin('base','ERF',ERF);
% % assignin('base','mERF',mERF);
% vData.ERF_for = ERF;
% vData.mERF_for = mERF;
% vData.semERF_for = semERF;
% 
h=figure;
clims = sort(-ylim_speed);
subplot(2,1,1);
% set(gcf,'Position',[1,1,700,700]);
% subplot(3,1,1);
drawErrorLine(tn,speedf_mean,speedf_sem,'r',0.2);
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
ylabel('Speed(cm/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');hold on;
haxes1 = gca; % handle to axes
set(haxes1,'xLim',[-pre_stim_time post_stim_time]);
set(haxes1,'yLim',clims);
xP = 0;
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
fore_name = strrep(filename,'.dat',' fore.mat');
title(fore_name,'FontName','Arial','FontSize',15,'FontWeight','Bold');

subplot(2,1,2);
plotHeatmap(tn,speed_fore,clims);
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
% colorbar([0.93 0.22 0.03 0.2],'FontSize',5);
% outputfilename = strrep(handles.filename_resp,'.mat', ' forward.png')
outputfilename = [pwd,'\figures\',filename(1:end-4) ' forward speed.png'];
if name
    saveas(h,outputfilename,'png');
else
    saveas(h,'forward speed.png','png');
end

% figure
% % clims = [-10 60];
% subplot(2,1,1);
% drawErrorLine(tn,mERF,semERF,'b',0.2);
% xP = 0;
% line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
% haxes2 = gca;
% set(haxes2,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
% % set(haxes2,'FontName','Arial','FontSize',10,'FontWeight','Bold');
% set(haxes2,'xLim',[pre_stim_time post_stim_time]);
% xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
% ylabel('\DeltaF /F (%)','FontName','Arial','FontSize',25,'FontWeight','Bold');
% title(fore_name,'FontName','Arial','FontSize',15,'FontWeight','Bold');
% set(haxes2,'yLim',clims_gc);
% 
% subplot(2,1,2);
% plotHeatmap(tn,ERF,clims_gc);
% set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
% colorbar([0.93 0.22 0.03 0.2],'FontSize',5);

% Data_filename = [filename(1:end-4),' analysis.mat'];
% save(Data_filename, '-struct', 'vData');


handles.vData = vData;

guidata(hObject,handles);
handles = guidata(hObject);



function edit_speed_Callback(hObject, eventdata, handles)
% hObject    handle to edit_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_speed as text
%        str2double(get(hObject,'String')) returns contents of edit_speed as a double


% --- Executes during object creation, after setting all properties.
function edit_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_speed.
function pushbutton_speed_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.dat','open stim file');
file_path_and_name = [pathname filename];
% handles.file_path_and_name = file_path_and_name;
if filename == 0
    return;
end
set(handles.edit_speed, 'String', filename);
% set(handles.edit_delete_trial, 'String', []);
% set(handles.edit_index_pupil, 'String', []);
Triggers = importdata(file_path_and_name); 
set(handles.edit_speed, 'UserData', Triggers);
Data_filename = [filename(1:end-4),' analysis.mat'];
handles.Data_filename = Data_filename;
handles.filename = filename;
% set(handles.edit_delete_trial,'String',[]);
% set(handles.edit_delete_trial2,'String',[]);

guidata(hObject,handles);
handles = guidata(hObject);



function edit_ylim_speed_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ylim_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ylim_speed as text
%        str2double(get(hObject,'String')) returns contents of edit_ylim_speed as a double


% --- Executes during object creation, after setting all properties.
function edit_ylim_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ylim_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_cmpp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cmpp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cmpp as text
%        str2double(get(hObject,'String')) returns contents of edit_cmpp as a double


% --- Executes during object creation, after setting all properties.
function edit_cmpp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cmpp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_deleteTrial2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_deleteTrial2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_deleteTrial2 as text
%        str2double(get(hObject,'String')) returns contents of edit_deleteTrial2 as a double


% --- Executes during object creation, after setting all properties.
function edit_deleteTrial2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_deleteTrial2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ylim_spike_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ylim_spike (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ylim_spike as text
%        str2double(get(hObject,'String')) returns contents of edit_ylim_spike as a double


% --- Executes during object creation, after setting all properties.
function edit_ylim_spike_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ylim_spike (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_start_t_Callback(hObject, eventdata, handles)
% hObject    handle to edit_start_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_start_t as text
%        str2double(get(hObject,'String')) returns contents of edit_start_t as a double


% --- Executes during object creation, after setting all properties.
function edit_start_t_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_start_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_start_t.
function pushbutton_start_t_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_start_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
[filename, pathname] = uigetfile('*.mat','*.dat', 'MultiSelect', 'on');
if isequal(filename,0)
   disp('User selected Cancel')
else
    filename = cellstr(filename);
    stimNum = size(filename,2)
    for i = 1:stimNum
            disp(['User selected stimuli', fullfile(pathname, filename{i})])
            eval(['stim',int2str(i), '=importdata(fullfile(pathname, filename{i}));']);
            eval(['handles.data.start_t',int2str(i),'=stim',int2str(i),';']);
    end
%     set(handles.trials_edt,'String','[1 500]')
%     set(handles.delTrial_edt,'String','NaN')
%     set(handles.stim_edt,'String',[pathname 'total' int2str(stimNum)])
    set(handles.edit_start_t,'String',filename{i})
%     handles.data.stimNum = stimNum;
end
% handles.filename_stim = filename;
% handles.pathname = pathname;

% Data_filename = [filename(1:end-4), ' analysis.mat'];
% handles.Data_filename = Data_filename;
guidata(hObject,handles);
handles = guidata(hObject);


% --- Executes on button press in radiobutton_name.
function radiobutton_name_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_name


% --- Executes on button press in radiobutton_reverse.
function radiobutton_reverse_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_reverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_reverse
