function varargout = PSTH_DAs(varargin)
% PSTH_DAS MATLAB code for PSTH_DAs.fig
%      PSTH_DAS, by itself, creates a new PSTH_DAS or raises the existing
%      singleton*.
%
%      H = PSTH_DAS returns the handle to a new PSTH_DAS or the handle to
%      the existing singleton*.
%
%      PSTH_DAS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PSTH_DAS.M with the given input arguments.
%
%      PSTH_DAS('Property','Value',...) creates a new PSTH_DAS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PSTH_DAs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PSTH_DAs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PSTH_DAs

% Last Modified by GUIDE v2.5 19-Feb-2021 09:12:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PSTH_DAs_OpeningFcn, ...
                   'gui_OutputFcn',  @PSTH_DAs_OutputFcn, ...
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


% --- Executes just before PSTH_DAs is made visible.
function PSTH_DAs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PSTH_DAs (see VARARGIN)

% Choose default command line output for PSTH_DAs
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PSTH_DAs wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PSTH_DAs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_stimulus1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_stimulus1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_stimulus1 as text
%        str2double(get(hObject,'String')) returns contents of edit_stimulus1 as a double


% --- Executes during object creation, after setting all properties.
function edit_stimulus1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_stimulus1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_response_Callback(hObject, eventdata, handles)
% hObject    handle to edit_response (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_response as text
%        str2double(get(hObject,'String')) returns contents of edit_response as a double


% --- Executes during object creation, after setting all properties.
function edit_response_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_response (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit_trial_from_Callback(hObject, eventdata, handles)
% hObject    handle to edit_trial_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_trial_from as text
%        str2double(get(hObject,'String')) returns contents of edit_trial_from as a double


% --- Executes during object creation, after setting all properties.
function edit_trial_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_trial_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_trial_number_Callback(hObject, eventdata, handles)
% hObject    handle to edit_trial_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_trial_number as text
%        str2double(get(hObject,'String')) returns contents of edit_trial_number as a double


% --- Executes during object creation, after setting all properties.
function edit_trial_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_trial_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pre_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pre as text
%        str2double(get(hObject,'String')) returns contents of edit_pre as a double


% --- Executes during object creation, after setting all properties.
function edit_pre_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_post_Callback(hObject, eventdata, handles)
% hObject    handle to edit_post (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_post as text
%        str2double(get(hObject,'String')) returns contents of edit_post as a double


% --- Executes during object creation, after setting all properties.
function edit_post_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_post (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_stimulus2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_stimulus2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_stimulus2 as text
%        str2double(get(hObject,'String')) returns contents of edit_stimulus2 as a double


% --- Executes during object creation, after setting all properties.
function edit_stimulus2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_stimulus2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_stimulus1.
function pushbutton_stimulus1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_stimulus1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.mat', 'Open Stimulus file');
file_path_and_name = [pathname filename];

if filename == 0
    return;
end
handles.filename = filename;
set(handles.edit_stimulus1, 'String', filename);
Triggers = importdata(file_path_and_name);
set(handles.edit_trial_number,'String',num2str(length(Triggers.level)/2));   
set(handles.edit_stimulus1, 'UserData', Triggers);

vData.filename = filename;
handles.vData = vData;

guidata(hObject,handles);
handles = guidata(hObject);

% --- Executes on button press in pushbutton_response.
function pushbutton_response_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_response (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.mat', 'Open Response file');
file_path_and_name = [pathname filename];
if filename == 0
    return;
end
set(handles.edit_offset,'String',0);
set(handles.edit_response, 'String', filename);
Spikes = importdata(file_path_and_name);
set(handles.edit_response, 'UserData', Spikes);

guidata(hObject,handles);
handles = guidata(hObject);

% try
%     times = Spikes.times;
%     max_time = floor(max(times));
% catch
%     interval = Spikes.interval;
%     length = Spikes.length;
%     max_time = floor((length-1)*interval);
% end
% 
% set(handles.edit_time_to,'String',num2str(max_time));

% --- Executes on button press in pushbutton_stimulus2.
function pushbutton_stimulus2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_stimulus2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.mat', 'Open Stimulus file');
file_path_and_name = [pathname filename];
if filename == 0
    return;
end

set(handles.edit_stimulus2, 'String', filename);
Triggers = importdata(file_path_and_name);
set(handles.edit_stimulus2, 'UserData', Triggers);
handles.filename2 = filename;

guidata(hObject,handles);
handles = guidata(hObject);






% --- Executes on button press in pushbutton_average.
function pushbutton_average_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% warning('off');
guidata(hObject,handles);
handles = guidata(hObject);
filename = handles.filename;
% filename2 = handles.filename2;
vData = handles.vData;
delTrial = str2num(get(handles.edit_delTrial,'String'));
t_times = str2num(get(handles.edit_t_times,'String'));
trial_from = str2num(get(handles.edit_trial_from,'String'));
trial_number = str2num(get(handles.edit_trial_number,'String'));
pre_sti_time = str2double(get(handles.edit_pre,'String'));
post_sti_time = str2double(get(handles.edit_post,'String'));
control_from = str2double(get(handles.edit_control_from,'String'));
control_to = str2double(get(handles.edit_control_to,'String'));
clims = str2num(get(handles.edit_clims,'String'));
yrange = str2num(get(handles.edit_yrange,'String'));
xP = str2double(get(handles.edit_line1,'String'));
xP2 = str2double(get(handles.edit_line2,'String'));
LEDthr = str2double(get(handles.edit_LEDthr,'String'));
bin = 0.1;
% handles.pre_sti_time = pre_sti_time;
% handles.post_sti_time = post_sti_time;
Triggers2 = get(handles.edit_stimulus2, 'UserData');
Triggers = get(handles.edit_stimulus1, 'UserData');
Waves = get(handles.edit_response, 'UserData');
% interval = Waves.interval;
interval = bin;
values = Waves.values;
% values = resample(values,10,500);
values = smooth(values);
% length(values);

% offset calculation
offset = str2double(get(handles.edit_offset,'String'));
if  offset == 0
    % offset calculation  mean value of first 5 s
    num = round(5/interval);
    offset = mean(values(1:num));
    set(handles.edit_offset,'String',num2str(offset))
end

times = -pre_sti_time:interval:post_sti_time-interval;
trigger_times1 = trigger_times_pretreatment(Triggers,trial_from,trial_number,pre_sti_time,post_sti_time,handles);
trigger_times1(delTrial) = [];

% trigger_times1([40 41]) = [];
% trigger_times1([ 20 21 22]) = [];

if ~isempty(t_times)
    trigger_times1 = trigger_times1(t_times);
end
assignin('base','trigger_times',trigger_times1);
trigger_times1 = trigger_times1 - LEDthr;

[psth,psth_mean,sem] = psth_wave(trigger_times1,interval,values,pre_sti_time,post_sti_time,control_from,control_to,offset);
assignin('base','psth_mean',psth_mean);
vData.trigger_times1 = trigger_times1;
vData.psth = psth;
vData.psth_mean = psth_mean;
vData.psth_sem = sem;
vData.delTrial = delTrial;
handles.vData = vData;

figure
set(gcf,'Position',[100,100,500,400]);
if size(psth,1)==1
    plot(times,psth,'k','LineWidth',3);
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
    set(gca,'xLim',[-pre_sti_time post_sti_time],'xTick',-pre_sti_time:5:post_sti_time);
    set(gca,'yLim',clims);
    xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
    ylabel('\DeltaF /F','FontName','Arial','FontSize',25,'FontWeight','Bold');
    line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
    line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
    xP3 = 2*xP2;
    line([xP3 xP3],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
    title(filename(1:end-4),'FontName','Arial','FontSize',15);
else
subplot(2,1,2);
drawErrorLine(times,psth_mean,sem,'k',0.2);
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
set(gca,'xLim',[-pre_sti_time post_sti_time],'xTick',-pre_sti_time:5:post_sti_time);
set(gca,'yLim',yrange);
xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
ylabel('\DeltaF /F','FontName','Arial','FontSize',25,'FontWeight','Bold');
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
xP3 = 2*xP2;
line([xP3 xP3],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
% title([strrep(filename(1:end-7), '\', '\\') ' Advance = ' num2str(advance,6),'s']);
% str = strrep(filename, '\', '\\');
% title(filename(1:end-20),'FontSize',10);

subplot(2,1,1);
plotHeatmap(times,psth,clims);
% ylabel('GC6 Trial #','FontSize',10,'FontWeight','Bold');
% colorbar([0.93 0.42 0.03 0.2],'FontSize',5);
colorbar('Position',[0.92 0.68 0.03 0.2],'FontSize',10,'yTick',clims);
set(gca,'FontSize',20,'FontWeight','Bold','yTick',[1 size(psth,1)],'xTick',[]);
xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
ylabel('Trial #','FontName','Arial','FontSize',25,'FontWeight','Bold');
title(filename(1:end-4),'FontName','Arial','FontSize',15);
end
% save([strrep(filename(1:end-13), '\', '\\') ' analysis.mat'],'-struct','vData');
save([handles.filename(1:end-4),' analysis.mat'], '-struct', 'vData');
% figFileName = strrep(filename, 'mat', 'fig');
% saveas(gcf, figFileName, 'fig'); 
guidata(hObject,handles);
handles = guidata(hObject);


function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_offset_Callback(hObject, eventdata, handles)
% hObject    handle to edit_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_offset as text
%        str2double(get(hObject,'String')) returns contents of edit_offset as a double


% --- Executes during object creation, after setting all properties.
function edit_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_stimulus2.
function checkbox_stimulus2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_stimulus2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_stimulus2



function edit_control_from_Callback(hObject, eventdata, handles)
% hObject    handle to edit_control_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_control_from as text
%        str2double(get(hObject,'String')) returns contents of edit_control_from as a double


% --- Executes during object creation, after setting all properties.
function edit_control_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_control_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_control_to_Callback(hObject, eventdata, handles)
% hObject    handle to edit_control_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_control_to as text
%        str2double(get(hObject,'String')) returns contents of edit_control_to as a double


% --- Executes during object creation, after setting all properties.
function edit_control_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_control_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_clims_Callback(hObject, eventdata, handles)
% hObject    handle to edit_clims (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_clims as text
%        str2double(get(hObject,'String')) returns contents of edit_clims as a double


% --- Executes during object creation, after setting all properties.
function edit_clims_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_clims (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_line1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_line1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_line1 as text
%        str2double(get(hObject,'String')) returns contents of edit_line1 as a double


% --- Executes during object creation, after setting all properties.
function edit_line1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_line1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_line2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_line2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_line2 as text
%        str2double(get(hObject,'String')) returns contents of edit_line2 as a double


% --- Executes during object creation, after setting all properties.
function edit_line2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_line2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_locomotion.
function pushbutton_locomotion_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_locomotion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
filename = handles.filename;
vData = handles.vData;
trial_from = str2num(get(handles.edit_trial_from,'String'));
trial_number = str2num(get(handles.edit_trial_number,'String'));
pre_sti_time = str2double(get(handles.edit_pre,'String'));
post_sti_time = str2double(get(handles.edit_post,'String'));
control_from = str2double(get(handles.edit_control_from,'String'));
control_to = str2double(get(handles.edit_control_to,'String'));
% clims = str2num(get(handles.edit_clims,'String'));
xP1 = str2double(get(handles.edit_line1,'String'));
xP2 = str2double(get(handles.edit_line2,'String'));
cmpp = str2double(get(handles.edit_cmpp,'String'));
delTrial = str2num(get(handles.edit_delTrial,'String'));
led_thre = str2double(get(handles.edit_LEDthr,'String'));
bin = 0.1;
clims = [0 20];
data = get(handles.edit_stimulus2, 'UserData');

readBox_LED = data.readBox_LED;
% stimOnset = data.stimOnset;
xLocation = data.x;
yLocation = data.y;

%%%find trigger 
disp('calculate stimOnset again......');%%---------------------
k  = 1;
while k<=length(readBox_LED)
%%%set a threshold again
%         if k<16200
        if readBox_LED(k) > led_thre
            stimOnset(k) = 1;
            else
            stimOnset(k) = 0;
        end
%             if k>8000 && k<8500
%                 stimOnset(k) = 0;
%             end
%         elseif k>700 
%             if readBox_LED(k) > 0.055
%             stimOnset(k) = 1;
%             else
%             stimOnset(k) = 0;
%             end
%         end
    k = k+1;
end
%%%find trigger times again
stimOnsetDiff = diff(stimOnset);
trigger_pupil_up = find(stimOnsetDiff == 1)+1;
trigger_pupil_down = find(stimOnsetDiff == -1)+1;
assignin('base','trigger_LED_up',trigger_pupil_up);
assignin('base','trigger_LED_down',trigger_pupil_down);
LEDdur =  trigger_pupil_down - trigger_pupil_up;
LEDdur_thre = find(LEDdur>5);
trigger_LED = trigger_pupil_up(LEDdur_thre); 
assignin('base','trigger_LED',trigger_LED);
trigger_LED_len = length(trigger_LED)
trigger_LED(delTrial) = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_speed = get(handles.edit_stimulus2, 'UserData');
xdiff = diff(xLocation);
ydiff = diff(yLocation);
travel_distance = sqrt(xdiff.^2 + ydiff.^2);
assignin('base','travel_distance',travel_distance);
velocity = travel_distance.*cmpp/bin; %velocity cm/s
% velocity = velocity';
velocity = smooth(velocity);
assignin('base','velocity',velocity);

tn = -pre_sti_time:bin:post_sti_time;
% time = 0.1:bin:length(velocity)/10;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure
% set(gcf,'Position',[100,500,1200,400]);
% plot(time,velocity);
% xlabel('Time (s)','FontSize',10,'FontWeight','Bold');
% ylabel('Speed(cm/s)','FontSize',10,'FontWeight','Bold');
% set(gca,'ylim',[0 150]);
% str = strrep(filename, '\', '\\');
% title(str(1:end-16),'FontSize',10);

% %align speed time and calcium signal time
% speed_duration = data_speed.testTime; 
% speed_duration2 = data.speeds.times(end)-data.speeds.times(end-1);
% % speed_duration2 = 1913.678+2-data.speeds.times(1);
% speed_delay = speed_duration2 - speed_duration
% correct_time = speed_delay/(trial_number-trial_from+1)
% correct_time = 0.01
% speed_start = data.speeds.times(end-1);
% trigger_times_speed = trigger_times1 - speed_start;
% assignin('base','trigger_times_speed',trigger_times_speed);
% % n = length(trigger_times_speed);

n = length(trigger_LED);
speed =[];
for i = 1:n
   speed = [speed,velocity(round(trigger_LED(i)-pre_sti_time/bin):round(trigger_LED(i)+post_sti_time/bin))];
%     start = (trigger_times_speed(i)-(i-0)*correct_time-pre_sti_time)/bin;
%     stop = (trigger_times_speed(i)-(i-0)*correct_time+post_sti_time)/bin;
%     speed = [speed;velocity(round(start):round(stop))];
end
speed = speed';
assignin('base','speed',speed);
speed_size = size(speed);
speed_mean = mean(speed);
speed_sem = std(speed)/sqrt(speed_size(1)-1);
assignin('base','speed_mean',speed_mean);
vData.delTrial = delTrial;
vData.trigger_LED = trigger_LED;
vData.speed_size = speed_size;
vData.speed_mea = speed_mean;
vData.speed_sem = speed_sem;
handles.vData = vData;

figure; 
set(gcf,'Position',[500,100,500,400]);
subplot(2,1,1);
plotHeatmap(tn,speed,clims);
% set(gca,'xTickLabel',-pre_sti_time:2:post_sti_time);
colorbar('Position',[0.92 0.68 0.03 0.2],'FontSize',10,'yTick',clims);
set(gca,'FontSize',20,'FontWeight','Bold','yTick',[1 n],'xTick',[]);
% set(gca,'xTick',pre_stim_time:5:post_stim_time);
xlabel('Time (s)','FontName','Arial','FontSize',15,'FontWeight','Bold');
ylabel('Trail #','FontName','Arial','FontSize',15,'FontWeight','Bold');
title(filename(1:end-8),'FontName','Arial','FontSize',15);

subplot(2,1,2);
drawErrorLine(tn,speed_mean,speed_sem,'k',0.3);
% set(gca,'yLim',[-18 18]);
set(gca,'xLim',[-pre_sti_time post_sti_time],'xTick',-pre_sti_time:2:post_sti_time);
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
set(gca,'yLim',clims);
% set(gca,'xLim',[pre_stim_time post_stim_time],'xTick',pre_stim_time:5:post_stim_time);
xlabel('Time (s)','FontName','Arial','FontSize',15,'FontWeight','Bold');
ylabel('Speed (cm/s)','FontName','Arial','FontSize',15,'FontWeight','Bold');
xP = 0;
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);

save([handles.filename(1:end-8),' analysis.mat'], '-struct', 'vData');


guidata(hObject,handles);
handles = guidata(hObject);


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



function edit_delTrial_Callback(hObject, eventdata, handles)
% hObject    handle to edit_delTrial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_delTrial as text
%        str2double(get(hObject,'String')) returns contents of edit_delTrial as a double


% --- Executes during object creation, after setting all properties.
function edit_delTrial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_delTrial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_LEDthr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_LEDthr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_LEDthr as text
%        str2double(get(hObject,'String')) returns contents of edit_LEDthr as a double


% --- Executes during object creation, after setting all properties.
function edit_LEDthr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_LEDthr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_t_times_Callback(hObject, eventdata, handles)
% hObject    handle to edit_t_times (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_t_times as text
%        str2double(get(hObject,'String')) returns contents of edit_t_times as a double


% --- Executes during object creation, after setting all properties.
function edit_t_times_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_t_times (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
trial_from = str2num(get(handles.edit_trial_from,'String'));
trial_number = str2num(get(handles.edit_trial_number,'String'));
t_from = str2double(get(handles.edit_t_from,'String'));
t_to = str2double(get(handles.edit_t_to,'String'));
clims = str2num(get(handles.edit_clims,'String'));
Triggers = get(handles.edit_stimulus1, 'UserData');
Triggers2 = get(handles.edit_stimulus2, 'UserData');
Waves = get(handles.edit_response, 'UserData');
GC6_times = Waves.times;
GC6_values = Waves.values;
GC6_interval = Waves.interval;

trigger_times1 = trigger_times_pretreatment2(Triggers,trial_from,trial_number,t_from,t_to,handles);
% trigger_times1(delTrial) = [];
assignin('base','trigger_times1',trigger_times1);

trigger_times2 = trigger_times_pretreatment2(Triggers2,trial_from,trial_number,t_from,t_to,handles);
% trigger_times1(delTrial) = [];
assignin('base','trigger_times2',trigger_times2);
trigger_times1 = (trigger_times1-t_from)/GC6_interval;
trigger_times2 = (trigger_times2-t_from)/GC6_interval;


% offset calculation
offset = str2double(get(handles.edit_offset,'String'));
if  offset == 0
    % offset calculation  mean value of first 5 s
    num = round(5/GC6_interval);
    offset = mean(GC6_values(1:num));
    set(handles.edit_offset,'String',num2str(offset))
end



GC6_times = GC6_times(t_from/GC6_interval:t_to/GC6_interval,:);
x2 = 1:length(GC6_times);
GC6_values = GC6_values(t_from/GC6_interval:t_to/GC6_interval,:);

%%%%smooth calcium signal
GC6_values = smooth(x2,GC6_values,0.003,'moving');  
assignin('base','GC6_times',GC6_times);
assignin('base','GC6_values',GC6_values);

%%%%calculate deltaF/F
baseline = mean(GC6_values(1:3/GC6_interval,:));
dF = (GC6_values - baseline)./(baseline-offset)*100;
assignin('base','dF',dF);

%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
gcf_Position=[1,1,1300,300];
set(gcf,'Position',gcf_Position);
plot(x2,dF,'b','LineWidth',3);hold on;
set(gca,'FontSize',20,'LineWidth',3,'FontWeight','Bold');
set(gca,'XLim',[0,length(dF)],'TickDir','out');
if length(dF)<=1000
    set(gca,'xTick',100:100:length(dF),'xTickLabel',10:10:length(dF)*GC6_interval);
else
    set(gca,'xTick',1000:1000:length(dF),'xTickLabel',100:100:length(dF)*GC6_interval);
end
set(gca,'YLim',clims,'TickDir','out');
ylabel('\DeltaF/F (%)','FontName','Arial','FontSize',25,'FontWeight','Bold');
xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');

xP1 = clims(2)-3;
xP2 = clims(2)-6;
for i = 1:size(trigger_times1,1)
%     line([xP1 xP1],'LineStyle',':','Color',[1 0 0],'LineWidth',3);
    line([trigger_times1(i,1),trigger_times1(i,2)],[xP1 xP1],'Color',[1 0 0],'LineWidth',3);
end
for i = 1:size(trigger_times2,1)
%     line([xP1 xP1],'LineStyle',':','Color',[1 0 0],'LineWidth',3);
    line([trigger_times2(i,1),trigger_times2(i,2)],[xP2 xP2],'Color',[0 0 1],'LineWidth',3);
end



function edit_t_from_Callback(hObject, eventdata, handles)
% hObject    handle to edit_t_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_t_from as text
%        str2double(get(hObject,'String')) returns contents of edit_t_from as a double


% --- Executes during object creation, after setting all properties.
function edit_t_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_t_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_t_to_Callback(hObject, eventdata, handles)
% hObject    handle to edit_t_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_t_to as text
%        str2double(get(hObject,'String')) returns contents of edit_t_to as a double


% --- Executes during object creation, after setting all properties.
function edit_t_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_t_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_yrange_Callback(hObject, eventdata, handles)
% hObject    handle to edit_yrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_yrange as text
%        str2double(get(hObject,'String')) returns contents of edit_yrange as a double


% --- Executes during object creation, after setting all properties.
function edit_yrange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_yrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
