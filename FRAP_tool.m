% easyFRAP:an interactive, easy-to-use tool for qualitative and
% quantitative analysis of FRAP data
% Copyright (C) 2011, Cell Cycle Lab, Medical School, University of Patras
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

function varargout = FRAP_tool(varargin)
% FRAP_tool M-file for FRAP_tool.fig
%      FRAP_tool, by itself, creates a new FRAP_tool or raises the existing
%      singleton*.
%
%      H = FRAP_tool returns the handle to a new FRAP_tool or the handle to
%      the existing singleton*.
%
%      FRAP_tool('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FRAP_tool.M with the given input arguments.
%
%      FRAP_tool('Property','Value',...) creates a new FRAP_tool or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FRAP_tool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FRAP_tool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FRAP_tool

% Last Modified by GUIDE v2.5 25-Nov-2011 18:34:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FRAP_tool_OpeningFcn, ...
                   'gui_OutputFcn',  @FRAP_tool_OutputFcn, ...
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


% --- Executes just before FRAP_tool is made visible.
function FRAP_tool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FRAP_tool (see VARARGIN)

%initialization values
handles.exp_name='Exp 1';
handles.dir_name='';
handles.flagUpload=0;
handles.flagDelete = 0;
handles.del_values=0; %deleted initial values
handles.d2=[]; %deleted samples
handles.prebleach=[];
handles.bleach=[];
handles.postbleach=[];
handles.flagNorm=0;
handles.flagSel=0; %select norm method
handles.flagFit=0;
handles.flagFitM=0;
handles.flagSelFit=0;
handles.flagCompute=0;
handles.flagPlot2=0;
handles.val = 1; %file format - csv,xls,txt

set(handles.uipanel7,'SelectionChangeFcn',@uipanel7_SelectionChangeFcn);
set(handles.uipanel16,'SelectionChangeFcn',@uipanel16_SelectionChangeFcn);
guidata(hObject, handles);
set(hObject,'toolbar','figure');

% Choose default command line output for FRAP_tool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FRAP_tool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FRAP_tool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function edit24_Callback(hObject, eventdata, handles)
handles.exp_name=get(hObject,'String');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit1_Callback(hObject, eventdata, handles)
handles.dir_name = get(hObject,'String');
if isdir(handles.dir_name)== 0
	errordlg('You must enter a valid directory','Error 1','modal')
    handles.dir_name=0;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
handles.val = get(hObject,'Value');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Browse_pushbutton1.
function Browse_pushbutton1_Callback(hObject, eventdata, handles)
if handles.flagUpload==1
    New_Exp_S_Callback(hObject, eventdata, handles)
    return
end
handles.dir_name = uigetdir;
set(handles.edit1, 'String', handles.dir_name);
guidata(hObject, handles);

% --- Executes on button press in Upload_pushbutton2.
function Upload_pushbutton2_Callback(hObject, eventdata, handles)

if isempty(handles.dir_name)| handles.dir_name==0
	errordlg('You must select a directory first','Error 2','modal')
	return
end

switch handles.val %file format
case 1
    cd(handles.dir_name)
    handles.FRAP_files = dir('*.csv');
    [handles.m,handles.n]=size(handles.FRAP_files);
    
   %check if there is any data
    if handles.m==0
      errordlg('No .csv files found. Check your data','Error 3','modal')
        return
    end
    %find the header lines
    fid = fopen(handles.FRAP_files(1).name);
    counter=0;
    tline= fgetl(fid);
    while isempty(str2num(tline))
    counter=counter+1;
    tline= fgetl(fid);
     if tline==-1
        errordlg('No measurements in your files. Check your data','Error 4','modal')
        return
    end
    end
    fclose(fid);
    handles.header=counter;  
    %read the data
    for i=1:handles.m
        handles.data{i,1}= csvread(handles.FRAP_files(i).name,handles.header,0);
    end
case 2
    cd(handles.dir_name)
    handles.FRAP_files = dir('*.txt');
    [handles.m,handles.n]=size(handles.FRAP_files);
    %find the header lines
    
    %check if there is any data
    if handles.m==0
      errordlg('No .txt files found. Check your data','Error 3','modal')
        return
    end
    fid = fopen(handles.FRAP_files(1).name);
    counter=0;
    tline= fgetl(fid);
    while isempty(str2num(tline))
    counter=counter+1;
    tline= fgetl(fid);
    if tline==-1
        errordlg('No measurements in your files. Check your data','Error 4','modal')
        return
    end
    end
    fclose(fid);
    handles.header=counter;
    %read the data
    for i=1:handles.m
        handles.data{i,1}= dlmread(handles.FRAP_files(i).name,'\t',handles.header,0);
    end
case 3
    cd(handles.dir_name)
    handles.FRAP_files = dir('*.xls');
    [handles.m,handles.n]=size(handles.FRAP_files);
    
    %check if there is any data
    if handles.m==0
      errordlg('No .xls files found. Check your data','Error 3','modal')
        return
    end
    %read the data
    for i=1:handles.m
        handles.data{i,1}= xlsread(handles.FRAP_files(i).name);
    end
    [k,l]=find(isnan(handles.data{1,1}));
    for j=1:handles.m
        handles.data{j,1}(1:max(k),:)=[];
    end
end
prompt = {'Column corresponding to time:','Column corresponding to ROI1:','Column corresponding to ROI2:','Column corresponding to ROI3:'};
dlg_title = 'Input files information';
num_lines = 1;
def = {'1','2','3','4'};
options.Resize='on';
answer = inputdlg(prompt,dlg_title,num_lines,def,options);
if isempty(answer)
    errordlg('Please insert the column - measurement correspondence','Error 5','modal')
    return
end
handles.tidx=str2num(answer{1});
handles.r1idx=str2num(answer{2});
handles.r2idx=str2num(answer{3});
handles.r3idx=str2num(answer{4});

minidx=min([handles.tidx;handles.r1idx;handles.r2idx;handles.r3idx]);
maxidx=max([handles.tidx;handles.r1idx;handles.r2idx;handles.r3idx]);

if handles.tidx>maxidx || handles.tidx<minidx
    errordlg('Time measurements should correspond to one of the columns in the input files','Error 6','modal')
    return
elseif handles.r1idx>maxidx || handles.r1idx<minidx
    errordlg('ROI1 measurements should correspond to one of the columns in the input files','Error 6','modal') 
    return
elseif handles.r2idx>maxidx || handles.r2idx<minidx
    errordlg('ROI2 measurements should correspond to one of the columns in the input files','Error 6','modal') 
    return
elseif handles.r3idx>maxidx || handles.r3idx<minidx
    errordlg('ROI3 measurements should correspond to one of the columns in the input files','Error 6','modal') 
    return
elseif length(unique(cell2mat(answer(1:4))))~=4
    errordlg('Measurements cannot be on the same column. Check your input','Error 7','modal') 
    return
end
    %check input files
    for l=1:handles.m
        handles.r(l,:)=size(handles.data{l});
    end

    if numel(unique(handles.r(:,1)))~=1
        errordlg('Different number of rows in the files. Check your data','Error 8','modal')
        return
%     elseif any(handles.r(:,2)~= 4)
%         errordlg('Wrong number of columns in the files, data must contain 4 columns (time, ROI1, ROI2, ROI3)','Error 9','modal')
%         return
    end
    
%time results
handles.t=zeros((handles.r(1,1)),handles.m);
for i=1:handles.m
    handles.t(:,i)=handles.data{i,1}(:,handles.tidx);
end
%ROI1 results
handles.ROI1=zeros((handles.r(1,1)),handles.m);
for i=1:handles.m
    handles.ROI1(:,i)=handles.data{i,1}(:,handles.r1idx);
end
%ROI2 results
handles.ROI2=zeros((handles.r(1,1)),handles.m);
for i=1:handles.m
    handles.ROI2(:,i)=handles.data{i,1}(:,handles.r2idx);
end
%ROI3 results
handles.ROI3=zeros((handles.r(1,1)),handles.m);
for i=1:handles.m
    handles.ROI3(:,i)=handles.data{i,1}(:,handles.r3idx);
end

%datafiles names
for i=1:handles.m
    handles.FRAP_names(i,1)={handles.FRAP_files(i).name};
end

handles.s=num2str([1:handles.m]');
handles.flagUpload=1;
Plot_pushbutton3_Callback(hObject, eventdata, handles)
msgbox(sprintf('%d samples succesfully uploaded \n The FRAP data contain %d rows and %d columns',handles.m, handles.r(1,1), handles.r(1,2)),'Upload');

set(handles.axes1, 'buttondownfcn',@plot_1);
set(handles.axes2, 'buttondownfcn',@plot_2);
set(handles.axes3, 'buttondownfcn',@plot_3);
guidata(hObject, handles);

function plot_1(hObject, eventdata, handles)
handles = guidata(hObject); 
if handles.flagUpload ~=0
figure(1)
plot(handles.t,handles.ROI1);
set(gca,'xlim',[0 max(handles.t(:,1))])
title('ROI1 ');
xlabel('time (sec)')
ylabel('Raw Fluorescence Intensity')
else
    return
end

function plot_2(hObject, eventdata, handles)
handles = guidata(hObject); 
if handles.flagUpload ~=0
figure(2)
plot(handles.t,handles.ROI2);
title('ROI2');
xlabel('time (sec)')
ylabel('Raw Fluorescence Intensity')
else
    return
end

function plot_3(hObject, eventdata, handles)
handles = guidata(hObject); 
if handles.flagUpload ~=0
figure(3)
plot(handles.t,ROI3);
title('ROI3');
xlabel('time (sec)')
ylabel('Raw Fluorescence Intensity')
else
    return
end

% --- Executes on button press in Plot_pushbutton3.
function Plot_pushbutton3_Callback(hObject, eventdata, handles)

if handles.flagUpload ==0
    errordlg('Please upload data first','Error','modal')
    return
else
cla(handles.axes1,'reset')
cla(handles.axes2,'reset') 
cla(handles.axes3,'reset')   

axes(handles.axes1)
plot(handles.t,handles.ROI1,'b');
title(['ROI1 - ',handles.exp_name]);
set(gca,'xlim',[0 max(handles.t(:,1))])
set(gca,'ylim',[0 max(max(handles.ROI1))])

axes(handles.axes2)
plot(handles.t,handles.ROI2,'b');
title(['ROI2 - ',handles.exp_name]);
set(gca,'xlim',[0 max(handles.t(:,1))])
set(gca,'ylim',[0 max(max(handles.ROI2))])

axes(handles.axes3)
plot(handles.t,handles.ROI3,'b');
title(['ROI3 - ',handles.exp_name]);
set(gca,'xlim',[0 max(handles.t(:,1))])
set(gca,'ylim',[0 max(max(handles.ROI3))])

end
set(handles.listbox4,'String',handles.FRAP_names)
set(handles.listbox4,'Value',1)
guidata(hObject, handles);

% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)

cla(handles.axes9,'reset')
cla(handles.axes11,'reset')    
handles.d2 = get(handles.listbox4,'Value');

axes(handles.axes1)
plot(handles.t,handles.ROI1,'b');
hold on;
plot(handles.t(:,handles.d2),handles.ROI1(:,handles.d2),'r')
title(['ROI1 - ',handles.exp_name]);
set(gca,'xlim',[0 max(handles.t(:,1))])
set(gca,'ylim',[0 max(max(handles.ROI1))])

axes(handles.axes2)
plot(handles.t,handles.ROI2,'b');
hold on;
plot(handles.t(:,handles.d2),handles.ROI2(:,handles.d2),'r')
title(['ROI2 - ',handles.exp_name]);
set(gca,'xlim',[0 max(handles.t(:,1))])
set(gca,'ylim',[0 max(max(handles.ROI2))])

axes(handles.axes3)
plot(handles.t,handles.ROI3,'b');
hold on;
plot(handles.t(:,handles.d2),handles.ROI3(:,handles.d2),'r')
title(['ROI3 - ',handles.exp_name]);
set(gca,'xlim',[0 max(handles.t(:,1))])
set(gca,'ylim',[0 max(max(handles.ROI3))])

% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Discard_pushbutton13.
function Discard_pushbutton13_Callback(hObject, eventdata, handles)

handles.d2 = get(handles.listbox4,'Value');
handles.selected = get(handles.listbox4,'String');

if handles.flagUpload ~=1
    errordlg('Please upload data first','Error 10','modal')
    return
elseif isempty(handles.d2)
    msgbox(sprintf('No samples specified'),'Delete values');
    return
    
elseif handles.d2~=0 

        handles.delname = handles.selected(handles.d2);
        handles.t(:,handles.d2)=[];
        handles.ROI1(:,handles.d2)=[];
        handles.ROI2(:,handles.d2)=[];
        handles.ROI3(:,handles.d2)=[];
        handles.FRAP_names(handles.d2)=[];
        Plot_pushbutton3_Callback(hObject, eventdata, handles)
%         msgbox(sprintf('You have successfully deleted sample: %s \n',handles.delname));
end

guidata(hObject, handles);


% --- Executes on button press in Restore_pushbutton26.
function Restore_pushbutton26_Callback(hObject, eventdata, handles)

if handles.flagUpload ~=1
    errordlg('Please upload data first','Error 10','modal')
    return
else
handles.t=zeros(size(handles.data{1,1}));
for i=1:handles.m
    handles.t(:,i)=handles.data{i,1}(:,1);
end
%ROI1 results
handles.ROI1=zeros(size(handles.data{1,1}));
for i=1:handles.m
    handles.ROI1(:,i)=handles.data{i,1}(:,2);
end
%ROI2 results
handles.ROI2=zeros(size(handles.data{1,1}));
for i=1:handles.m
    handles.ROI2(:,i)=handles.data{i,1}(:,3);
end
%ROI3 results
for i=1:handles.m
    handles.ROI3(:,i)=handles.data{i,1}(:,4);
end

%datafile names
for i=1:handles.m
    handles.FRAP_names(i,1)={handles.FRAP_files(i).name};
end
end

Plot_pushbutton3_Callback(hObject, eventdata, handles)
guidata(hObject, handles);



function edit4_Callback(hObject, eventdata, handles)

handles.prebleach= str2num(get(hObject,'String'));

if handles.prebleach<0 
    errordlg('You entered a negative value','Error 11','modal')
elseif isempty(handles.prebleach)
    errordlg('Please enter a real number','Error 12','modal')
elseif handles.prebleach > handles.r(1,1)
    errordlg('Wrong parameter value','Error 13','modal')
elseif numel(handles.prebleach)~= 1
    errordlg('Please enter only one number','Error 14','modal')
    return
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handles)

handles.bleach= str2num(get(hObject,'String'));
if handles.bleach<0 
    errordlg('You entered a negative value','Error 11','modal')   
elseif isempty(handles.bleach)
    errordlg('Please enter a real number','Error 12','modal')     
elseif handles.bleach > handles.r(1,1)
    errordlg('Wrong parameter value','Error 13','modal') 
elseif numel(handles.bleach)~= 1
    errordlg('Please enter only one number','Error 14','modal')
    return
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit6_Callback(hObject, eventdata, handles)

handles.postbleach= str2num(get(hObject,'String'));
if handles.postbleach<0 
    errordlg('You entered a negative value','Error 11','modal')
    return
elseif isempty(handles.postbleach)
    errordlg('Please enter a real number','Error 12','modal')
    return
elseif numel(handles.postbleach)~= 1
    errordlg('Please enter only one number','Error 13','modal')
    return
elseif handles.postbleach > handles.r(1,1)
    errordlg('Wrong parameter value','Error 14','modal')
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit11_Callback(hObject, eventdata, handles)

handles.del_values= str2num(get(hObject,'String'));
if handles.del_values<0 
    errordlg('You entered a negative value','Error 11','modal')
    return
elseif isempty(handles.del_values)
    errordlg('Please enter a real number','Error 12','modal')
    return
elseif handles.del_values>handles.prebleach
    errordlg('The value is out of range','Error 13','modal')
    return
elseif numel(handles.del_values)~= 1
    errordlg('Please enter only one number','Error 14','modal')
    return
end
% handles.prebleach=handles.prebleach - handles.del_values;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Compute_pushbutton15.
function Compute_pushbutton15_Callback(hObject, eventdata, handles)

if handles.flagUpload ~=1
    errordlg('Please upload data first','Error 15','modal')
    return
elseif isempty(handles.prebleach) || isempty(handles.bleach) || isempty(handles.postbleach)
    errordlg('Please enter all mandatory parameters','Error 16','modal')
    return
end

if handles.prebleach+handles.bleach+handles.postbleach ~= handles.r(1,1)
    errordlg('Wrong parameter values, check again','Error 17','modal')
     msgbox(sprintf('%d %d %d',handles.del_values, handles.prebleach, handles.r(1,1)),'Delete inital values');    
    return
elseif handles.flagDelete == 1
    errordlg('You have already deleted the initial values. Press reset to continue','Error 18','modal')
    return
else
    if handles.del_values ~= 0
        handles.t=handles.t(handles.del_values+1:end,:);
        handles.ROI1=handles.ROI1(handles.del_values+1:end,:);
        handles.ROI2=handles.ROI2(handles.del_values+1:end,:);
        handles.ROI3=handles.ROI3(handles.del_values+1:end,:);
        Plot_pushbutton3_Callback(hObject, eventdata, handles)
        msgbox(sprintf('You have successfully deleted %d initial values\n',handles.del_values),'Delete inital values');  
    %             msgbox(sprintf('%d %d %d',handles.del_values, handles.prebleach, handles.r(1,1)),'Delete inital values'); 
        handles.flagDelete = 1;
    end       
    %compute bleaching depth and gap ratio
    ROI11=handles.ROI1-handles.ROI3;
    ROI1pre_all=mean(ROI11(1:handles.prebleach - handles.del_values,:)); 
    ROI1pre=mean(ROI1pre_all);%mean prebleach value (all data)
    ROI1bleach=mean(ROI11(handles.prebleach - handles.del_values+handles.bleach+1,:)); %mean value in first after-bleach 
    handles.bd=roundn(1-(ROI1bleach/ROI1pre),-2); %bleaching depth
    set(handles.text38, 'String', handles.bd);
    ROI22=handles.ROI2-handles.ROI3;
    Iwpre_all=mean(ROI22(1:handles.prebleach - handles.del_values,:)); 
    Iwpre=mean(Iwpre_all);
    Iwpost_all=mean(ROI22(handles.prebleach - handles.del_values+handles.bleach+1:handles.prebleach - handles.del_values+handles.bleach+11,:));
    Iwpost=mean(Iwpost_all);
    handles.gr=roundn((Iwpost/Iwpre),-2); %gap ratio
    set(handles.text39, 'String', handles.gr);

end
handles.flagCompute=1;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Compute_pushbutton15_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in Reset_pushbutton27.
function Reset_pushbutton27_Callback(hObject, eventdata, handles)

if handles.flagUpload ~=1
    errordlg('Please upload data first','Error 19','modal')
    return
elseif handles.del_values==0
    errordlg('Nothing to reset, please enter number of initial values','Error 20','modal');
    return
elseif handles.flagCompute==0 
    errordlg('Nothing to reset, please press compute first','Error 21','modal');
    return
else
    handles.del_values=0;
    set(handles.edit11, 'String', handles.del_values);
    handles.t=zeros(size(handles.data{1,1}));
    for i=1:handles.m
        handles.t(:,i)=handles.data{i,1}(:,1);
    end
    %ROI1 results
    handles.ROI1=zeros(size(handles.data{1,1}));
    for i=1:handles.m
        handles.ROI1(:,i)=handles.data{i,1}(:,2);
    end
    %ROI2 results
    handles.ROI2=zeros(size(handles.data{1,1}));
    for i=1:handles.m
        handles.ROI2(:,i)=handles.data{i,1}(:,3);
    end
    %ROI3 results
    handles.ROI3=zeros(size(handles.data{1,1}));
    for i=1:handles.m
        handles.ROI3(:,i)=handles.data{i,1}(:,4);
    end

    %datafiles names
    for i=1:handles.m
        handles.FRAP_names(i,1)={handles.FRAP_files(i).name};
    end
    %in case of deleted samples
    handles.t(:,handles.d2)=[];
    handles.ROI1(:,handles.d2)=[];
    handles.ROI2(:,handles.d2)=[];
    handles.ROI3(:,handles.d2)=[];
    handles.FRAP_names(handles.d2)=[];
         
    Plot_pushbutton3_Callback(hObject, eventdata, handles)
    msgbox(sprintf('You have successfully restored all deleted initial values'));
     %compute bleaching depth and gap ratio
    ROI11=handles.ROI1-handles.ROI3;
    ROI1pre_all=mean(ROI11(1:handles.prebleach - handles.del_values,:)); 
    ROI1pre=mean(ROI1pre_all);%mean prebleach value (all data)
    ROI1bleach=mean(ROI11(handles.prebleach - handles.del_values+handles.bleach+1,:)); %mean value in first after-bleach 
    handles.bd=roundn(1-(ROI1bleach/ROI1pre),-2); %bleaching depth
    set(handles.text38, 'String', handles.bd);
    ROI22=handles.ROI2-handles.ROI3;
    Iwpre_all=mean(ROI22(1:handles.prebleach - handles.del_values,:)); 
    Iwpre=mean(Iwpre_all);
    Iwpost_all=mean(ROI22(handles.prebleach - handles.del_values+handles.bleach+1:handles.prebleach - handles.del_values+handles.bleach+11,:));
    Iwpost=mean(Iwpost_all);
    handles.gr=roundn((Iwpost/Iwpre),-2); %gap ratio
    set(handles.text39, 'String', handles.gr);
    handles.flagDelete = 0;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Reset_pushbutton27_CreateFcn(hObject, eventdata, handles)


% --- Executes when selected object is changed in uipanel7.
function uipanel7_SelectionChangeFcn(hObject, eventdata, handles)

handles = guidata(hObject); 
if handles.flagUpload ~=1
    errordlg('Please upload data first','Error 22','modal')
    return
elseif isempty(handles.prebleach) || isempty(handles.bleach) || isempty(handles.postbleach)
    errordlg('Please enter all mandatory parameters','Error 23','modal')
    return
end
handles.norm_method= get(eventdata.NewValue,'Tag');
handles.flagSel=1;
guidata(hObject, handles);


% --- Executes on button press in Norm_pushbutton18.
function Norm_pushbutton18_Callback(hObject, eventdata, handles)
if handles.flagUpload ~=1
    errordlg('Please upload data first','Error 24','modal')
    return
elseif isempty(handles.prebleach) || isempty(handles.bleach) || isempty(handles.postbleach)
    errordlg('Please enter all mandatory parameters','Error 25','modal')
    return
elseif handles.flagSel~=1
    errordlg('Please select Normalization method','Error 26','modal')
    return
elseif handles.flagCompute~=1
    errordlg('Please press Compute first','Error 27','modal')
    return
end
switch handles.norm_method   % Get Tag of selected object
    case 'double'
    R1=handles.ROI1-handles.ROI3;
    R1pre=mean(R1(1:handles.prebleach-handles.del_values,:));
    R2=handles.ROI2-handles.ROI3;
    R2pre=mean(R2(1:handles.prebleach-handles.del_values,:));
    n11=R1./R2;
    n12=R2pre./R1pre;
    k=size(handles.ROI1,2);
    for i=1:k
        n1(:,i)=n11(:,i)*n12(i);
    end

    handles.norm1=n1;
    handles.norm1(handles.prebleach-handles.del_values+1:handles.prebleach-handles.del_values+handles.bleach,:)=[];
    handles.t1=handles.t;
    handles.t1(handles.prebleach-handles.del_values+1:handles.prebleach-handles.del_values+handles.bleach,:)=[];
    handles.mn=mean(handles.norm1,2);
    handles.stdev=std(handles.norm1,0,2);
    
    case 'full_scale'
    
    R1=handles.ROI1-handles.ROI3;
    R1pre=mean(R1(1:handles.prebleach-handles.del_values,:));
    R2=handles.ROI2-handles.ROI3;
    R2pre=mean(R2(1:handles.prebleach-handles.del_values,:));
    n11=R1./R2;
    n12=R2pre./R1pre;
    k=size(handles.ROI1,2);
    for i=1:k
        g(:,i)=n11(:,i)*n12(i);
    end
    
    g1=g(handles.prebleach+handles.bleach-handles.del_values+1,:);
    for j=1:k
        n1(:,j)=(g(:,j) - g1(j))./(1-g1(j));
    end

    handles.norm1=n1;
    handles.norm1(handles.prebleach-handles.del_values+1:handles.prebleach-handles.del_values+handles.bleach,:)=[];
    handles.t1=handles.t;
    handles.t1(handles.prebleach-handles.del_values+1:handles.prebleach-handles.del_values+handles.bleach,:)=[];
    handles.mn=mean(handles.norm1,2);
    handles.stdev=std(handles.norm1,0,2);
    
    otherwise
      errordlg('Please select normalization method','Bad Input','modal')
    return
end
cla(handles.axes7,'reset')
cla(handles.axes8,'reset')
axes(handles.axes7)
plot(handles.t1(:,1),handles.norm1,'-ob','MarkerSize',1);
title(['Normalized Curves - ',handles.exp_name]);
set(gca,'xlim',[0 max(handles.t1(:,1))],'ylim',[0 1.2])

axes(handles.axes8)
hold on
errorbar(handles.t1(:,1),handles.mn,handles.stdev,'color',[0.6 0.6 0.6],'linewidth',0.5)
plot(handles.t1(:,1),handles.mn,'-ro','linewidth',0.5,'MarkerSize',2);
title(['Mean Normalized +/- Std - ',handles.exp_name]);
set(gca,'xlim',[0 max(handles.t1(:,1))],'ylim',[0 1.2])
%populate listbox5
handles.selected1 = get(handles.listbox4,'String');
handles.flagNorm=1;
set(handles.listbox5,'String',handles.selected1)
set(handles.listbox5,'Value',1)
set(handles.axes7, 'buttondownfcn',@plot_4);
set(handles.axes8, 'buttondownfcn',@plot_5);
guidata(hObject, handles);



function plot_4(hObject, eventdata, handles)
handles = guidata(hObject); 
if handles.flagNorm ~=0
figure(4)
plot(handles.t1(:,1),handles.norm1,'-o','MarkerSize',1);
title('Normalized data')
ylabel('Normalized Fluorescence Intensity')
xlabel('time (sec)')
set(gca,'xlim',[0 max(handles.t1(:,1))],'ylim',[0 1.2])
else
    return
end

function plot_5(hObject, eventdata, handles)
handles = guidata(hObject); 
if handles.flagNorm ~=0
figure(5)
hold on
errorbar(handles.t1(:,1),handles.mn,handles.stdev,'color',[0.6 0.6 0.6],'linewidth',0.5)
plot(handles.t1(:,1),handles.mn,'-ro','linewidth',0.5,'MarkerSize',2);
ylabel('Normalized Fluorescence Intensity')
xlabel('time (sec)')
title('Mean Normalized +/- Standard Deviation');
set(gca,'xlim',[0 max(handles.t1(:,1))],'ylim',[0 1.2])
else
    return
end

% --- Executes during object creation, after setting all properties.
function text38_CreateFcn(hObject, eventdata, handles)

% --- Executes on selection change in listbox5.
function listbox5_Callback(hObject, eventdata, handles)

if handles.flagUpload~=1
    errordlg('Please upload data first','Error','modal')
    return
elseif handles.flagNorm ~=1
    errordlg('Please normalize the data first','Error','modal')
    return
end
% handles.tf=[];
% handles.cdata=[];
% if strcmp('double', handles.norm_method) == 1
    handles.tf = handles.t1;
    handles.tf(1:handles.prebleach-handles.del_values,:)=[];
    for u=1:size(handles.tf,2)
        handles.tf(:,u)=handles.tf(:,u)-handles.tf(1,u);
    end
    handles.cdata = handles.norm1;
    handles.cdata(1:handles.prebleach -handles.del_values,:)=[];

% elseif strcmp('full_scale', handles.norm_method) == 1
%     handles.tf = handles.t1;
%     handles.tf(1:handles.prebleach-handles.del_values,:)=[];
%     for v=1:size(handles.tf,2)
%         handles.tf(:,v)=handles.tf(:,v)-handles.tf(1,v);
%     end
%     handles.cdata = handles.norm1;
% end
handles.d = get(handles.listbox5,'Value');
cla(handles.axes9,'reset')
cla(handles.axes11,'reset')
axes(handles.axes9)
plot(handles.tf(:,handles.d),handles.cdata(:,handles.d),'ob','markersize',2);
set(handles.axes9,'ylim',[0 1.2],'xlim',[-1 max(handles.tf(:,handles.d))])
handles.flagPlot2=1;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function listbox5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel16.
function uipanel16_SelectionChangeFcn(hObject, eventdata, handles)

handles = guidata(hObject); 
handles.fit_eq = get(eventdata.NewValue,'Tag');
switch handles.fit_eq   % Get Tag of selected object
    case 'single_exponential'
    handles.fe='yo - a*exp(-b*x)';
    handles.lower=[0 0 0];
    handles.upper=[100 100 1];
     handles.sp=[0.50 0.563 0.9]; %start point
    
    case 'double_exponential'
    handles.fe='yo - a*exp(-b*x)- c*exp(-d*x)';
    handles.lower=[0 0 0 0 0];
    handles.upper=[100 100 100 100 1];
     handles.sp=[0.5 0.563 0.316 0.36 0.9];
        
    otherwise
      errordlg('Please select fitting equation','Error','modal')
    return
end
handles.flagSelFit=1;
guidata(hObject, handles);


% --- Executes on button press in Fit_pushbutton28.
function Fit_pushbutton28_Callback(hObject, eventdata, handles)

handles = guidata(hObject); 
if handles.flagUpload~=1
    errordlg('Please upload data first','Error 28','modal')
    return
elseif isempty(handles.prebleach) || isempty(handles.bleach) || isempty(handles.postbleach)
    errordlg('Please enter all mandatory parameters','Error 29','modal')
    return
elseif handles.flagNorm ~=1
    errordlg('Please normalize the data first','Error 30','modal')
    return
elseif handles.flagSelFit~=1
    errordlg('Please select fitting equation','Error 31','modal')
    return
elseif handles.flagPlot2~=1  
    errordlg('Please select sample from the list','Error 32','modal')
    return

end

handles.d = get(handles.listbox5,'Value');
% weights=[ones(1,250)];
s = fitoptions('Method','NonlinearLeastSquares', ...
'Maxiter',1000,...
'maxfuneval',5000,...
'startpoint',handles.sp,...
'lower',handles.lower,...
'upper',handles.upper);
% 'Weights',weights);
f = fittype(handles.fe,'options',s);

[y,gof2,out] = fit(handles.tf(:,handles.d),handles.cdata(:,handles.d),f,s);
handles.res=y;
%compute mobile fraction
if strcmp('full_scale', handles.norm_method) == 1
    handles.mf=roundn(y.yo,-2);
elseif strcmp('double', handles.norm_method) == 1
    %x=0:0.01:max(handles.tf(:,handles.d));
    if strcmp('single_exponential', handles.fit_eq) == 1
        %fe2=y.yo - y.a*exp(-y.b*x);
        handles.mf=roundn((y.a)/(1-y.yo+y.a),-2);
        %handles.mf=[roundn((y.a)/(1-y.yo+y.a),-2)];
    elseif strcmp('double_exponential', handles.fit_eq) == 1
        %fe2=y.yo - y.a*exp(-y.b*x)- y.c*exp(-y.d*x);
        handles.mf=[roundn((y.a+y.c)/(1-y.yo+y.a+y.c),-2)];
        %handles.mf=[roundn((y.yo-fe2(1))/(1-fe2(1)),-2)];
    else
        return
    end
end

%compute thalf
if strcmp('single_exponential', handles.fit_eq) == 1
            handles.th=roundn((log(2)/y.b),-2);  
elseif strcmp('double_exponential', handles.fit_eq) == 1
    x=0:0.01:max(handles.tf(:,handles.d));
    fe2=y.yo - y.a*exp(-y.b*x)- y.c*exp(-y.d*x);
    hm=(y.yo+fe2(1))/2;
    yy=find(fe2<hm);
    if isempty(yy)
        handles.th=0;
    else
    ind=yy(end);
    handles.th=roundn((x(ind)),-2);
    end
end
handles.rsquare=roundn(gof2.rsquare,-2);
handles.resid=out.residuals;
cla(handles.axes9,'reset')
cla(handles.axes11,'reset')
    
axes(handles.axes9)
plot(handles.res,'r',handles.tf(:,handles.d),handles.cdata(:,handles.d),'.b')
set(handles.axes9,'ylim',[0 1.2],'xlim',[-1 max(handles.tf(:,handles.d))])
legend('data','fitted curve','location','southeast')
xlabel(' ');
ylabel(' ');
axes(handles.axes11)
plot(handles.tf,handles.resid,'.r','MarkerSize',2)
set(handles.axes11,'xlim',[-1 max(handles.tf(:,handles.d))])
xlabel(' ');
ylabel(' ');


set(handles.text48, 'String', handles.rsquare);
set(handles.text46, 'String', handles.mf);
set(handles.text47, 'String', handles.th);
handles.flagFit=1;

set(handles.axes9, 'buttondownfcn',@plot_fit1);
set(handles.axes11, 'buttondownfcn',@plot_fit2);
handles.flagFitM=0;
guidata(hObject, handles);

function plot_fit1(hObject, eventdata, handles)
handles = guidata(hObject); 
if handles.flagFit~=0
figure
plot(handles.res,'r',handles.tf(:,handles.d),handles.cdata(:,handles.d),'.b');
title('Curve Fit Results')
set(gca,'ylim',[0 1.2],'xlim',[-1 max(handles.tf(:,handles.d))])
xlabel('time (sec)');
ylabel('Relative Fluorescent Intensity');
legend('data','fitted curve','location','southeast');
else
    return
end

function plot_fit2(hObject, eventdata, handles)
handles = guidata(hObject); 
if handles.flagFit~=0
figure(7)
plot(handles.tf,handles.resid,'.r')
set(gca,'xlim',[-1 max(handles.tf(:,handles.d))])
title('Fitting Residuals')
xlabel('time (sec)');

else
    return
end


% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)

handles = guidata(hObject); 
if handles.flagUpload~=1
    errordlg('Please upload data first','Error 33','modal')
    return
elseif isempty(handles.prebleach) || isempty(handles.bleach) || isempty(handles.postbleach)
    errordlg('Please enter all mandatory parameters','Error 34','modal')
    return
elseif handles.flagNorm ~=1
    errordlg('Please normalize the data first','Error 35','modal')
    return
elseif handles.flagSelFit~=1
    errordlg('Please select fitting equation','Error 36','modal')
    return
elseif handles.flagPlot2~=1  
    errordlg('Please select sample from the list','Error 37','modal')
    return
else 
%         if strcmp('double', handles.norm_method) == 1
            handles.tfm = handles.t1(:,1);
            handles.tfm(1:handles.prebleach-handles.del_values,:)=[];
            handles.tfm=handles.tfm-handles.tfm(1);
            handles.cdatam = handles.mn;
            handles.cdatam(1:handles.prebleach -handles.del_values,:)=[];
% 
%         elseif strcmp('full_scale', handles.norm_method) == 1
%             handles.tfm = handles.t1(:,1);
%             handles.tfm=handles.tfm-handles.tfm(1);
%             handles.cdatam = handles.mn;
%         end
end

s = fitoptions('Method','NonlinearLeastSquares', ...
'Maxiter',1000,...
'maxfuneval',5000,...
'startpoint',handles.sp,...
'lower',handles.lower,...
'upper',handles.upper);
% 'Weights',weights);
f = fittype(handles.fe,'options',s);

[y,gof2,out] = fit(handles.tfm,handles.cdatam,f,s);

handles.res=y;
%compute mobile fraction
if strcmp('full_scale', handles.norm_method) == 1
    handles.mf=roundn(y.yo,-2);
elseif strcmp('double', handles.norm_method) == 1
    if strcmp('single_exponential', handles.fit_eq) == 1
        handles.mf=roundn((y.a)/(1-y.yo+y.a),-2);
    elseif strcmp('double_exponential', handles.fit_eq) == 1
        handles.mf=roundn((y.a+y.c)/(1-y.yo+y.a+y.c),-2);
    else
        return
    end
end

%compute thalf
if strcmp('single_exponential', handles.fit_eq) == 1
    handles.th=roundn((log(2)/y.b),-2);
elseif strcmp('double_exponential', handles.fit_eq) == 1
    x=0:0.01:max(handles.tfm);
    fe2=y.yo - y.a*exp(-y.b*x)- y.c*exp(-y.d*x);
    hm=(y.yo+fe2(1))/2;
    yy=find(fe2<hm);
    if isempty(yy)
        handles.th=0;
    else
    ind=yy(end);
    handles.th=roundn((x(ind)),-2);
    end
end
handles.rsquare=roundn(gof2.rsquare,-2);
handles.resid=out.residuals;
cla(handles.axes9,'reset')
cla(handles.axes11,'reset')
    
axes(handles.axes9)
plot(handles.res,'r',handles.tfm,handles.cdatam,'.b')
set(handles.axes9,'ylim',[0 1.2],'xlim',[-1 max(handles.tfm)])
legend('mean data','fitted curve','location','southeast')
xlabel(' ');
ylabel(' ');
axes(handles.axes11)
plot(handles.tfm,handles.resid,'.r','MarkerSize',2)
set(handles.axes11,'xlim',[-1 max(handles.tfm)])
xlabel(' ');
ylabel(' ');

set(handles.text48, 'String', handles.rsquare);
set(handles.text46, 'String', handles.mf);
set(handles.text47, 'String', handles.th);
handles.flagFit=1;

set(handles.axes9, 'buttondownfcn',@plot_fit3);
set(handles.axes11, 'buttondownfcn',@plot_fit4);
handles.flagFitM=1;
guidata(hObject, handles);
    
function plot_fit3(hObject, eventdata, handles)
handles = guidata(hObject); 
if handles.flagFit~=0
figure(8)
plot(handles.res,'r',handles.tfm,handles.cdatam,'.b')
set(gca,'ylim',[0 1.2],'xlim',[-1 max(handles.tfm)])
title('Curve Fit results')
xlabel('time (sec)');
else
    return
end

function plot_fit4(hObject, eventdata, handles)
handles = guidata(hObject); 
if handles.flagFit~=0
figure(9)
plot(handles.tfm,handles.resid,'.r')
set(gca,'xlim',[-1 max(handles.tfm)])
title('Fitting Residuals')
xlabel('time (sec)');
else
    return
end
% --- Executes on button press in Save_pushbutton29.
function Save_pushbutton29_Callback(hObject, eventdata, handles)

if handles.flagUpload~=1
    errordlg('Please upload data first','Error 38','modal')
    return
elseif isempty(handles.prebleach) || isempty(handles.bleach) || isempty(handles.postbleach)
    errordlg('Please enter all mandatory parameters','Error 39','modal')
    return
elseif handles.flagNorm ~=1
    errordlg('Please normalize the data first','Error 40','modal')
    return
elseif handles.flagSelFit~=1
    errordlg('Please select fitting equation','Error 41','modal')
    return
end

[filef,path] = uiputfile('*.xls','Save Fitting Results');
if isequal(filef,0) | isequal(path,0)
    return
else
    [handles.sfiles,handles.v] = listdlg('PromptString','Select samples:',...
                'SelectionMode','multiple',...
                'ListString',handles.selected1);
    if isempty(handles.sfiles)
    errordlg('Please select files for fitting','Error','modal')
    return
    end
    w=size(handles.sfiles,2);

    handles.mf_all=zeros(w,1);
    handles.th_all=zeros(w,1);
    handles.rsquare_all=zeros(w,1);
    handles.resid_all=zeros(w,1);
    h = waitbar(0,'Please wait while fitting is performed...');
for q=1:size(handles.sfiles,2)
    %         weights=[ones(1,250)];
    s = fitoptions('Method','NonlinearLeastSquares', ...
    'Maxiter',1000,'maxfuneval',5000,'lower',handles.lower,'upper',handles.upper,...
    'startpoint',handles.sp);
    %         'Weights',weights);
    f = fittype(handles.fe,'options',s);
    [y,gof2,out] = fit(handles.tf(:,handles.sfiles(q)),handles.cdata(:,handles.sfiles(q)),f,s);
    handles.gof=gof2;
    handles.out=out;
    %compute mobile fraction
    if strcmp('full_scale', handles.norm_method) == 1
        handles.mf_all(q,1)=roundn(y.yo,-2);
    elseif strcmp('double', handles.norm_method) == 1
        if strcmp('single_exponential', handles.fit_eq) == 1
            handles.mf_all(q,1)=roundn((y.a)/(1-y.yo+y.a),-2);
        elseif strcmp('double_exponential', handles.fit_eq) == 1
            handles.mf_all(q,1)=roundn((y.a+y.c)/(1-y.yo+y.a+y.c),-2);
        else
            return
        end  
%         x=0:0.01:max(handles.tf(:,handles.d));
%         fe2=y.yo - y.a*exp(-y.b*x);
%         handles.mf_all(q,1)=roundn((y.yo-fe2(1))/(1-fe2(1)),-2);
    end
    %compute thalf
    if strcmp('single_exponential', handles.fit_eq) == 1
        handles.th_all(q,1)=roundn((log(2)/y.b),-2);  
    elseif strcmp('double_exponential', handles.fit_eq) == 1
        x=0:0.01:max(handles.tf(:,q));
        fe2=y.yo - y.a*exp(-y.b*x)- y.c*exp(-y.d*x);
        hm=(y.yo+fe2(1))/2;
        yy=find(fe2<hm);
        if isempty(yy)
            handles.th_all(q,1)=0;
        else
        ind=yy(end);
        handles.th_all(q,1)=roundn((x(ind)),-2);
        end
    end     
handles.rsquare_all(q,1)=roundn(handles.gof.rsquare,-2);
waitbar(q/w);    
end

close(h);
files=dir;
for i=1:size(files,1)
    if(isequal(files(i).name, filef))
        delete(filef);
    end
end
%     handles.th_all(handles.th_all==0)=[];
%     handles.mf_all(handles.mf_all==0)=[];
cd(path);
xlswrite(filef,handles.FRAP_names(handles.sfiles),1,'A3')
xlswrite(filef,{'sample'},1,'A2')
xlswrite(filef ,handles.th_all,1,'B3')
xlswrite(filef ,[roundn(mean(handles.th_all),-2) roundn(std(handles.th_all),-2)],1,'C3')
xlswrite(filef ,handles.mf_all,1,'E3')
xlswrite(filef ,handles.rsquare_all,1,'H3')
xlswrite(filef ,[roundn(mean(handles.mf_all),-2) roundn(std(handles.mf_all),-2)],1,'F3')
xlswrite(filef,{'t-half (sec)','mean','std','mobile fraction','mean','std','R-square'},1,'B2');
xlswrite(filef ,{handles.norm_method handles.fit_eq},1,'A1')
helpdlg(sprintf('Saved Curve Fitting results for Normalization Method: %s and Fitting Equation: %s ',handles.norm_method, handles.fe),'Saving Curve fit results'); 
end
 guidata(hObject, handles);

% --------------------------------------------------------------------
function SRD_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Exp_Raw_Callback(hObject, eventdata, handles)

if handles.flagUpload ~=1
    errordlg('Please upload data first','Error 42','modal')
    return
else
    figure(1);
    plot(handles.t,handles.ROI1,'-o','MarkerSize',2);
    xlabel('time (sec)');
    ylabel('Raw Fluorescence Intensity');
    title(['ROI1 - ',handles.exp_name]);
    set(gca,'xlim',[0 max(handles.t(:,1))])
    legend(handles.FRAP_names,'location','northeast');

    figure(2)
    plot(handles.t,handles.ROI2,'-o','MarkerSize',2);
    xlabel('time (sec)');
    ylabel('Raw Fluorescence Intensity');
    title(['ROI2 - ',handles.exp_name]);
    set(gca,'xlim',[0 max(handles.t(:,1))])
    legend(handles.FRAP_names,'location','northeast');

    figure(3)
    plot(handles.t,handles.ROI3,'-o','MarkerSize',2);
    xlabel('time (sec)');
    ylabel('Raw Fluorescence Intensity');
    title(['ROI3 - ',handles.exp_name]);
    set(gca,'xlim',[0 max(handles.t(:,1))])
    legend(handles.FRAP_names,'location','northeast');
end
guidata(hObject, handles);

% --------------------------------------------------------------------
function Save_ROI1_Callback(hObject, eventdata, handles)

if handles.flagUpload~=0
[file1,path] = uiputfile('*.xls','Save Raw Data - ROI1');
if isequal(file1,0) | isequal(path,0)
    return
else
    files=dir;
    for i=1:size(files,1)
        if(isequal(files(i).name, file1))
            delete(file1);
        end
    end
cd(path);
xlswrite(file1 ,[handles.t(:,1) handles.ROI1],1,'A2')
xlswrite(file1,{'time'},1,'A1')
xlswrite(file1,handles.FRAP_names',1,'B1')
end
else
    errordlg('Please upload data first','Error 43','modal')
    return
end
guidata(hObject, handles);

% --------------------------------------------------------------------
function Save_ROI2_Callback(hObject, eventdata, handles)

if handles.flagUpload~=0
[file2,path] = uiputfile('*.xls','Save Raw Data - ROI2');
if isequal(file2,0) | isequal(path,0)
    return
else
    files=dir;
    for i=1:size(files,1)
        if(isequal(files(i).name, file2))
            delete(file2);
        end
    end
cd(path);
xlswrite(file2 ,[handles.t(:,1) handles.ROI2],1,'A2')
xlswrite(file2,{'time'},1,'A1')
xlswrite(file2,handles.FRAP_names',1,'B1')
end
else
    errordlg('Please upload data first','Error 44','modal')
    return
end

% --------------------------------------------------------------------
function Save_ROI3_Callback(hObject, eventdata, handles)

if handles.flagUpload~=0
[file3,path] = uiputfile('*.xls','Save Raw Data - ROI3');
if isequal(file3,0) | isequal(path,0)
    return
else
    files=dir;
    for i=1:size(files,1)
        if(isequal(files(i).name, file3))
            delete(file3);
        end
    end
cd(path);
xlswrite(file3 ,[handles.t(:,1) handles.ROI3],1,'A2')
xlswrite(file3,{'time'},1,'A1')
xlswrite(file3,handles.FRAP_names',1,'B1')
end
else
    errordlg('Please upload data first','Error 45','modal')
    return
end

function SND_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Exp_Norm_Callback(hObject, eventdata, handles)

if handles.flagUpload~=1
    errordlg('Please upload data first','Error 46','modal')
    return
elseif handles.flagNorm ~=1
    errordlg('Please normalize the data first','Error 47','modal')
    return
else

figure(4)
plot(handles.t1(:,1),handles.norm1,'-o','MarkerSize',2);
xlabel('time (sec)');
ylabel('Normalized Fluorescence Intensity');
title(['Normalized Curves - ',handles.exp_name]);
set(gca,'xlim',[0 max(handles.t1(:,1))],'ylim',[0 1.2])
legend(handles.FRAP_names,'location','southeast');

figure(5)
hold on
errorbar(handles.t1(:,1),handles.mn,handles.stdev,'color',[0.6 0.6 0.6],'linewidth',0.5)
set(gca,'xlim',[0 max(handles.t1(:,1))],'ylim',[0 1.2])
hold on
plot(handles.t1(:,1),handles.mn,'-ro','linewidth',0.5,'MarkerSize',2);
xlabel('time (sec)');
ylabel('Normalized Fluorescence Intensity');
title(['Mean Normalized +/- Standard Deviation - ',handles.exp_name]);
end
guidata(hObject, handles);

% --------------------------------------------------------------------
function Save_2_Callback(hObject, eventdata, handles)
if handles.flagNorm~=0
[file,path] = uiputfile('*.xls','Save Normalized Data');
    if isequal(file,0) | isequal(path,0)
        return
    else
        files=dir;
        for i=1:size(files,1)
            if(isequal(files(i).name, file))
                delete(file);
            end
        end
    cd(path);
    xlswrite(file ,[handles.t1(:,1) handles.mn handles.stdev handles.norm1],1,'A2')
    xlswrite(file,{'time','mean','std'},1,'A1')
    xlswrite(file,handles.FRAP_names',1,'D1')
    end
else
    errordlg('Please normalize the data first','Error 48','modal')
    return
end
guidata(hObject, handles);

% --------------------------------------------------------------------
function New_Exp_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function New_Exp_S_Callback(hObject, eventdata, handles)

button = questdlg('Do you want to close the current experiment?','Close easyFRAP');
switch button
case {'No'}
	% take no action
    FRAP_tool
case 'Yes'
	% Prepare to close GUI application window    
 	delete(handles.figure1)
    FRAP_tool
case 'Cancel'
    return
end



% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Manual_Callback(hObject, eventdata, handles)

msgbox(sprintf('%s \n\n %s \n %s \n\n %s \n\n %s %s \n\n %s %s %s \n\n %s \n\n %s \n\n %s \n\n%s \n\n%s \n\n',...
'In order to use easyFRAP you must follow the following steps:', ...
'1. Give a name to the current experiment (optional), select the directory containing the .csv files and press Upload.',...
'Attention: Each file should contain 4 columns: time, ROI1, ROI2 and ROI3 Intensity values.',...
'2. The raw intensities in ROI1, ROI2 and ROI3 are visualized for data assesment.',...
'3. The user can optionally chose to delete certain samples, if their quality is not satisfactory.',...
'The reset button allows the user to bring back the deleted samples.',...
'4. Enter the bleaching parameters and optionally the number of initial values to discard.',...
'By pressing the Compute button, the Bleaching Depth and the Gap Ratio values are estimated.',...
'The Reset button sets the initial values to zero and repeats the computation.',...
'5. Select method and press Normalize to normalize and plot the data.',...
'6. Select sample, then select fitting equation and press fit to fit the data. Press save to save the results.',...
'For additional information and extended documentation please visit ccl.med.upatras.gr'),'Instructions')


% --------------------------------------------------------------------
function Credits_Callback(hObject, eventdata, handles)

msgbox(sprintf('%s \n %s \n %s',...
'easyFRAP was developed by the Cell Cycle Lab, Medical School, University of Patras', ...
'It is free software, distributed under the GNU General Public License (GPL)',...
'For any comments or bugs please contact rapsoman@upatras.gr'),'Credits')
guidata(hObject, handles);


% --------------------------------------------------------------------
function SCFR_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Save_3_Callback(hObject, eventdata, handles)

Save_pushbutton29_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Exp_CF_Callback(hObject, eventdata, handles)

if handles.flagFitM==1
figure(6)
plot(handles.res,'r',handles.tfm,handles.cdatam,'.b');
set(gca,'ylim',[0 1.2],'xlim',[-1 max(handles.tfm)])
title('Curve Fit Results (mean curve)')
xlabel('time (sec)');
ylabel('Relative Fluorescent Intensity');
legend('data','fitted curve','location','southeast');

elseif handles.flagFit==1
figure(6)
plot(handles.res,'r',handles.tf(:,handles.d),handles.cdata(:,handles.d),'.b');
set(gca,'ylim',[0 1.2],'xlim',[-1 max(handles.tf(:,handles.d))])
title('Curve Fit Results')
xlabel('time (sec)');
ylabel('Relative Fluorescent Intensity');
legend('data','fitted curve','location','southeast');
else
    return
end


% --------------------------------------------------------------------
function batch_analysis_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Batch_Callback(hObject, eventdata, handles)

batch_easyFRAP();

guidata(hObject, handles);
