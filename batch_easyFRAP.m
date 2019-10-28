function varargout = batch_easyFRAP(varargin)
% BATCH_EASYFRAP M-file for batch_easyFRAP.fig
%      BATCH_EASYFRAP, by itself, creates a new BATCH_EASYFRAP or raises the existing
%      singleton*.
%
%      H = BATCH_EASYFRAP returns the handle to a new BATCH_EASYFRAP or the handle to
%      the existing singleton*.
%
%      BATCH_EASYFRAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BATCH_EASYFRAP.M with the given input arguments.
%
%      BATCH_EASYFRAP('Property','Value',...) creates a new BATCH_EASYFRAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before batch_easyFRAP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to batch_easyFRAP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help batch_easyFRAP

% Last Modified by GUIDE v2.5 28-Nov-2011 18:51:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @batch_easyFRAP_OpeningFcn, ...
                   'gui_OutputFcn',  @batch_easyFRAP_OutputFcn, ...
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


% --- Executes just before batch_easyFRAP is made visible.
function batch_easyFRAP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to batch_easyFRAP (see VARARGIN)

% Choose default command line output for batch_easyFRAP
handles.output = hObject;
handles.dir_name=0;
handles.val = 1; %file format - csv,xls,txt
handles.flagUpload=0;
handles.header=0;
handles.flagSelFit=0;
handles.flagSelNorm=0;
handles.flagNorm=0;
handles.flagFit=0;
set(handles.uipanel12,'SelectionChangeFcn',@uipanel12_SelectionChangeFcn);
set(handles.uipanel13,'SelectionChangeFcn',@uipanel13_SelectionChangeFcn);
handles.norm_method='double';
handles.fit_eq='single';
guidata(hObject, handles);
set(hObject,'toolbar','figure');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes batch_easyFRAP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = batch_easyFRAP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function directory_edit1_Callback(hObject, eventdata, handles)
handles.dir_name = get(hObject,'String');
if isdir(handles.dir_name)== 0
	errordlg('You must enter a valid directory','Error','modal')
    handles.dir_name=0;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function directory_edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Browse_pushbutton3.
function Browse_pushbutton3_Callback(hObject, eventdata, handles)
handles.dir_name = uigetdir;
set(handles.directory_edit1, 'String', handles.dir_name);
if isempty(handles.dir_name)| handles.dir_name==0
	errordlg('You must select a directory first','Error','modal')
	return
end
cd (handles.dir_name)
dir_struct = dir(handles.dir_name);
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
handles.file_names = sorted_names;
handles.is_dir = [dir_struct.isdir];
handles.sorted_index = sorted_index;
set(handles.listbox1,'String',handles.file_names(handles.is_dir),...
	'Value',1)
guidata(hObject, handles);

% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
handles.val = get(hObject,'Value');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Upload_pushbutton1.
function Upload_pushbutton1_Callback(hObject, eventdata, handles)

if isempty(handles.dir_name) | handles.dir_name==0
	errordlg('You must select a directory first','Error','modal')
	return
end
%get selected datasets
handles.d2 = get(handles.listbox1,'Value');
handles.selected = get(handles.listbox1,'String');
handles.folders=handles.selected(handles.d2);
[handles.m,n]=size(handles.folders);
handles.val = get(handles.popupmenu4,'Value');
%get header lines number
prompt = {'How many header lines are there in your files?'};
dlg_title = 'Input files information';
num_lines = 1;
def = {'2'};
options.Resize='on';
answer = inputdlg(prompt,dlg_title,num_lines,def,options);
if isempty(answer)
    errordlg('Please define header lines','Error','modal')
    return
end
handles.header=str2num(answer{1});

switch handles.val %file format
case 1
for i=1:handles.m
    cd(handles.folders{i})
    handles.FRAP_files{i} = dir('*.csv');
    [handles.m1(i),handles.n1(i)]=size(handles.FRAP_files{i});
    
   %check if there is any data
    if handles.m1(i)==0
      errordlg('File format inconsistency, check your data','Error','modal')
      cd ..
        return
    end   
    %read the data
    for j=1:handles.m1(i)
        handles.data{i}{j,1}= csvread(handles.FRAP_files{i}(j).name,handles.header,0);
    end
    cd ..
end

case 2
for i=1:handles.m
    cd(handles.folders{i})
    handles.FRAP_files{i} = dir('*.txt');
    [handles.m1(i),handles.n1(i)]=size(handles.FRAP_files{i});
    
   %check if there is any data
    if handles.m1(i)==0
      errordlg('File format inconsistency, check your data','Error','modal')
      cd ..
        return
    end  
    %read the data
    for j=1:handles.m1(i)
        handles.data{i}{j,1}= dlmread(handles.FRAP_files{i}(j).name,'\t',handles.header,0);
    end
    cd ..
end
case 3
for i=1:handles.m
    cd(handles.folders{i})
    handles.FRAP_files{i} = dir('*.xls');
    [handles.m1(i),handles.n1(i)]=size(handles.FRAP_files{i});
    
   %check if there is any data
    if handles.m1(i)==0
      errordlg('File format inconsistency, check your data','Error','modal')
        return
    end
    %read the data
    for j=1:handles.m1(i)
        handles.data{i}{j,1}= xlsread(handles.FRAP_files{i}(j).name);
        %handles.data{i}{j,1}(1:handles.header,:)= [];
    end
    cd ..
end
end

prompt = {'Column corresponding to time:','Column corresponding to ROI1:','Column corresponding to ROI2:','Column corresponding to ROI3:'};
dlg_title = 'Input files information';
num_lines = 1;
def = {'1','2','3','4'};
options.Resize='on';
answer = inputdlg(prompt,dlg_title,num_lines,def,options);
if isempty(answer)
    errordlg('Please insert the parameters','Error','modal')
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

prompt = {'Prebleach Values:','Bleach Values:','Postbleach values:','Initial values to discard'};
dlg_title = 'Bleaching parameters';
num_lines = 1;
def = {'50','2','250','10'};
options.Resize='on';
answer2 = inputdlg(prompt,dlg_title,num_lines,def,options);
if isempty(answer)
    errordlg('Please insert the parameters','Error','modal')
    return
end
handles.prebleach=str2num(answer2{1});
handles.bleach=str2num(answer2{2});
handles.postbleach=str2num(answer2{3});
handles.del_values=str2num(answer2{4});
if handles.bleach<0 || handles.prebleach<0 || handles.postbleach<0
    errordlg('You entered a negative value','Error','modal')   
elseif isempty(handles.bleach) || isempty(handles.prebleach) || isempty(handles.postbleach)
    errordlg('Please enter a real number','Error','modal')     
elseif numel(handles.bleach)~= 1 || numel(handles.prebleach)~= 1 || numel(handles.postbleach)~= 1
    errordlg('Please enter only one number','Error','modal')
end

for k=1:handles.m %every dataset
    [m1,n1]=size(handles.data{1,k});
    for l=1:m1 %number of samples in every dataset
        handles.r{k}(l,:)=size(handles.data{1,k}{l});
        handles.numlines(k)=handles.r{k}(1);
        if numel(unique(handles.r{k}(:,1)))~=1
            errordlg(sprintf('Different number of rows in dataset %d, check your data',handles.m))
            return
%           elseif any(handles.r{k}(:,2)~= 4)
%           errordlg('Wrong number of columns in dataset %d, data must contain 4 columns',handles.m)
%           return
        elseif numel(unique(handles.numlines))~=1
            errordlg('The datasets have different experimental parameters. Please upload experiment with the same bleaching values','Error','modal')
            return
        elseif handles.prebleach+handles.bleach+handles.postbleach ~= handles.numlines(1)
            errordlg('The experimental parameters are wrong!','Error','modal')
            return
        end
    end
end


for k=1:handles.m %for every folder
%    check input files
    [m1,n1]=size(handles.data{1,k});
    
    %time results
    for p=1:m1
        handles.t{k}(:,p)=handles.data{1,k}{p,1}(:,handles.tidx);
    end
    %ROI1 results
    for p=1:m1
        handles.ROI1{k}(:,p)=handles.data{1,k}{p,1}(:,handles.r1idx);
    end
    %ROI2 results
    for p=1:m1
        handles.ROI2{k}(:,p)=handles.data{1,k}{p,1}(:,handles.r2idx);
    end
    %ROI3 results
    for p=1:m1
        handles.ROI3{k}(:,p)=handles.data{1,k}{p,1}(:,handles.r3idx);
    end

    %datafiles names
    for p=1:m1
        handles.FRAP_names{k}{p,1}=handles.FRAP_files{1,k}(p,1).name;
    end
end

if handles.del_values ~= 0
    for p=1:handles.m
    handles.t{p}=handles.t{p}(handles.del_values+1:end,:);
    handles.ROI1{p}=handles.ROI1{p}(handles.del_values+1:end,:);
    handles.ROI2{p}=handles.ROI2{p}(handles.del_values+1:end,:);
    handles.ROI3{p}=handles.ROI3{p}(handles.del_values+1:end,:);
    end
    msgbox(sprintf('You have successfully deleted %d initial values\n',handles.del_values),'Delete inital values');  
end    
handles.flagDelete = 1;
msgbox(sprintf('Succesfully uploaded %d FRAP experiments',size(handles.d2,2)));
handles.flagUpload=1;
guidata(hObject, handles);

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.flagUpload==0
    errordlg('Please upload data first')
    return
end
for i=1:handles.m
figure;
plot(handles.t{i},handles.ROI1{i},'b');
title(['Raw Curves - ROI1 - ',handles.folders{i}]);
xlabel('time (sec)');ylabel('Raw Fluorescence Intensity');
set(gca,'xlim',[0 max(handles.t{i}(:,1))])
figure;
plot(handles.t{i},handles.ROI2{i},'g');
title(['Raw Curves - ROI2 - ',handles.folders{i}]);
xlabel('time (sec)');ylabel('Raw Fluorescence Intensity');
set(gca,'xlim',[0 max(handles.t{i}(:,1))])
figure;
plot(handles.t{i},handles.ROI3{i},'m');
title(['Raw Curves - ROI3 - ',handles.folders{i}]);
xlabel('time (sec)');ylabel('Raw Fluorescence Intensity');
set(gca,'xlim',[0 max(handles.t{i}(:,1))])
end

% --- Executes when selected object is changed in uipanel12.
function uipanel12_SelectionChangeFcn(hObject, eventdata, handles)
handles = guidata(hObject); 
if handles.flagUpload ~=1
    errordlg('Please upload data first','Error','modal')
    return
end
handles.norm_method= get(eventdata.NewValue,'Tag');
handles.flagSelNorm=1;
guidata(hObject, handles);

function Normalize_pushbutton6_Callback(hObject, eventdata, handles)

if handles.flagUpload ~=1
    errordlg('Please upload data first','Error','modal')
elseif handles.flagSelNorm ~=1;
    errordlg('Please select normalization method','Error','modal')
    return
end
h = waitbar(0,'Please wait while normalization is performed...');
for i=1:handles.m %every dataset
switch handles.norm_method   % Get Tag of selected object
    case 'double'
    R1=handles.ROI1{i}-handles.ROI3{i};
    R1pre=mean(R1(1:handles.prebleach-handles.del_values,:));
    R2=handles.ROI2{i}-handles.ROI3{i};
    R2pre=mean(R2(1:handles.prebleach-handles.del_values,:));
    n11=R1./R2;
    n12=R2pre./R1pre;
    k=size(handles.ROI1{i},2);
    for l=1:k
        n1{i}(:,l)=n11(:,l)*n12(l);
    end

    handles.norm1{i}=n1{i};
    handles.norm1{i}(handles.prebleach-handles.del_values+1:handles.prebleach-handles.del_values+handles.bleach,:)=[];
    handles.t1{i}=handles.t{i};
    handles.t1{i}(handles.prebleach-handles.del_values+1:handles.prebleach-handles.del_values+handles.bleach,:)=[];
    handles.mn{i}=mean(handles.norm1{i},2);
    handles.stdev{i}=std(handles.norm1{i},0,2);
    
    case 'full_scale'    
    R1=handles.ROI1{i}-handles.ROI3{i};
    R1pre=mean(R1(1:handles.prebleach-handles.del_values,:));
    R2=handles.ROI2{i}-handles.ROI3{i};
    R2pre=mean(R2(1:handles.prebleach-handles.del_values,:));
    n11=R1./R2;
    n12=R2pre./R1pre;
    k=size(handles.ROI1{i},2);
    for j=1:k
        g{i}(:,j)=n11(:,j)*n12(j);
    end
    
    g1{i}=g{i}(handles.prebleach+handles.bleach-handles.del_values+1,:);
    for o=1:k
        n1{i}(:,o)=(g{i}(:,o) - g1{i}(o))./(1-g1{i}(o));
    end

    handles.norm1{i}=n1{i};
    handles.norm1{i}(handles.prebleach-handles.del_values+1:handles.prebleach-handles.del_values+handles.bleach,:)=[];
    handles.t1{i}=handles.t{i};
    handles.t1{i}(handles.prebleach-handles.del_values+1:handles.prebleach-handles.del_values+handles.bleach,:)=[];
    handles.mn{i}=mean(handles.norm1{i},2);
    handles.stdev{i}=std(handles.norm1{i},0,2);
    
    otherwise
      errordlg('Please select normalization method','Bad Input','modal')
    return
    
end
xlswrite((sprintf('Normalized data - %s',handles.folders{i})),...
    [handles.t1{i}(:,1) handles.norm1{i}],1,'A3')
xlswrite((sprintf('Normalized data - %s',handles.folders{i})),{handles.norm_method},1,'A1')
xlswrite((sprintf('Normalized data - %s',handles.folders{i})),{'time'},1,'A2')
xlswrite((sprintf('Normalized data - %s',handles.folders{i})),handles.FRAP_names{i}',1,'B2')
waitbar(i / size(handles.t,2));
end
close(h);
handles.flagNorm=1;
msgbox(sprintf('Saved normalized data for %d experiments in folder: %s ', handles.m, handles.dir_name))
guidata(hObject, handles);

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
if handles.flagUpload==0
    errordlg('Please upload data first')
elseif handles.flagNorm==0
    errordlg('Please normalize data first')
    return
end
for i=1:handles.m
figure;
plot(handles.t1{i}(:,1),handles.norm1{i},'-ob','MarkerSize',1);
title(['Normalized Curves - ',handles.folders{i}]);
xlabel('time (sec)');ylabel('Normalized Fluorescence Intensity');
set(gca,'xlim',[0 max(handles.t1{i}(:,1))],'ylim',[0 1.2])
figure;
hold on
errorbar(handles.t1{i}(:,1),handles.mn{i},handles.stdev{i},'color',[0.6 0.6 0.6],'linewidth',0.5)
plot(handles.t1{i}(:,1),handles.mn{i},'-ro','linewidth',0.5,'MarkerSize',2);
xlabel('time (sec)');ylabel('Normalized Fluorescence Intensity');
title(['Mean Normalized +/- Std - ',handles.folders{i}]);
set(gca,'xlim',[0 max(handles.t1{i}(:,1))],'ylim',[0 1.2])
end

% --- Executes when selected object is changed in uipanel13.
function uipanel13_SelectionChangeFcn(hObject, eventdata, handles)
handles = guidata(hObject); 
if handles.flagUpload ~=1
    errordlg('Please upload data first','Error','modal')
    return
elseif handles.flagNorm~=1
    errordlg('Please normalize data first','Error','modal')
    return
end
handles.fit_eq= get(eventdata.NewValue,'Tag');
switch handles.fit_eq   % Get Tag of selected object
    case 'single'
    handles.fe='yo - a*exp(-b*x)';
    handles.lower=[0 0 0];
    handles.upper=[100 100 1];
     handles.sp=[0.50 0.563 0.9]; %start point    
    case 'double'
    handles.fe='yo - a*exp(-b*x)- c*exp(-d*x)';
    handles.lower=[0 0 0 0 0];
    handles.upper=[100 100 100 100 1];
     handles.sp=[0.5 0.563 0.316 0.36 0.9];        
    otherwise
      errordlg('Please select fitting equation','Bad Input','modal')
    return
end
handles.flagSelFit=1;
guidata(hObject, handles);

function Fit_pushbutton7_Callback(hObject, eventdata, handles)

if handles.flagUpload ~=1
    errordlg('Please upload data first','Error','modal')
    return
elseif handles.flagNorm~=1
    errordlg('Please normalize data first','Error','modal')
    return
elseif handles.flagSelFit~=1
    errordlg('Please select fitting equation','Error','modal')
    return
end
%create data for fit
for i=1:handles.m
% if strcmp('double', handles.norm_method) == 1
    handles.tf{i} = handles.t1{i};
    handles.tf{i}(1:handles.prebleach-handles.del_values,:)=[];
    for u=1:size(handles.tf{i},2)
        handles.tf{i}(:,u)=handles.tf{i}(:,u)-handles.tf{i}(1,u);
    end
    handles.cdata{i} = handles.norm1{i};
    handles.cdata{i}(1:handles.prebleach -handles.del_values,:)=[];
% elseif strcmp('full_scale', handles.norm_method) == 1
%     handles.tf{i} = handles.t1{i};
%     for v=1:size(handles.tf{i},2)
%         handles.tf{i}(:,v)=handles.tf{i}(:,v)-handles.tf{i}(1,v);
%     end
%     handles.cdata{i} = handles.norm1{i};
% end
end
%fit the data
s = fitoptions('Method','NonlinearLeastSquares','Maxiter',1000,...
'maxfuneval',5000,'lower',handles.lower,'upper',handles.upper,'startpoint',handles.sp);
f = fittype(handles.fe,'options',s);
h = waitbar(0,'Please wait while fitting is performed...');
for j=1:handles.m %for every dataset
k=size(handles.cdata{j},2);
    for g=1:k %for every sample
    [y,gof2,out] = fit(handles.tf{j}(:,1),handles.cdata{j}(:,g),f,s);
    handles.res{j}{g}=y;
    %compute mobile fraction
    if strcmp('full_scale', handles.norm_method) == 1
        handles.mf{j}(g,1)=roundn(y.yo,-2);
    elseif strcmp('double', handles.norm_method) == 1
        if strcmp('single', handles.fit_eq) == 1
            handles.mf{j}(g,1)=roundn((y.a)/(1-y.yo+y.a),-2);
        elseif strcmp('double', handles.fit_eq) == 1
            handles.mf{j}(g,1)=roundn((y.a+y.c)/(1-y.yo+y.a+y.c),-2);
        else
            return
        end
    end
%     if strcmp('full_scale', handles.norm_method) == 1
%         handles.mf{j}(g,1)=roundn(y.yo,-2);
%     elseif strcmp('double', handles.norm_method) == 1
%         x=0:0.01:max(handles.tf{j}(:,1));
%         fe2=y.yo - y.a*exp(-y.b*x);
%         handles.mf{j}(g,1)=roundn((y.yo-fe2(1))/(1-fe2(1)),-2);
%     end
    %compute thalf
   if strcmp('single', handles.fit_eq) == 1
        handles.th{j}(g,1)=roundn((log(2)/y.b),-2);  
   elseif strcmp('double', handles.fit_eq) == 1
        x=0:0.01:max(handles.tf{j}(:,1));
        fe2=y.yo - y.a*exp(-y.b*x)- y.c*exp(-y.d*x);
        hm=(y.yo+fe2(1))/2;
        yy=find(fe2<hm);
            if isempty(yy)
                handles.th{j}(g,1)=0;
            else
                ind=yy(end);
                handles.th{j}(g,1)=roundn((x(ind)),-2);
            end
   end
    handles.rsquare{j}(g,1)=roundn(gof2.rsquare,-2);
    handles.resid{j}(:,g)=out.residuals;
    end
    waitbar(j / handles.m);
xlswrite((sprintf('Fitting results - %s',handles.folders{j})),handles.th{j},1,'B3');
xlswrite((sprintf('Fitting results - %s',handles.folders{j})),...
    [roundn(mean(handles.th{j}),-2) roundn(std(handles.th{j}),-2)] ,1,'C3');
xlswrite((sprintf('Fitting results - %s',handles.folders{j})),handles.mf{j},1,'E3');
xlswrite((sprintf('Fitting results - %s',handles.folders{j})),...
    [roundn(mean(handles.mf{j}),-2) roundn(std(handles.mf{j}),-2)] ,1,'F3');
xlswrite((sprintf('Fitting results - %s',handles.folders{j})),handles.rsquare{j},1,'H3');
xlswrite((sprintf('Fitting results - %s',handles.folders{j})),...
    handles.FRAP_names{j},1,'A3');
xlswrite((sprintf('Fitting results - %s',handles.folders{j})),...
    {'sample','t-half','mean','std','mobile fraction','mean','std','R-square'},1,'A2');    
xlswrite((sprintf('Fitting results - %s',handles.folders{j})),...
    {handles.norm_method handles.fit_eq},1,'A1');
end
close(h)
msgbox(sprintf('Saved curve fitting results  for %d experiments in folder: %s ', handles.m, handles.dir_name))
handles.flagFit=1;
guidata(hObject, handles);



% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)

if handles.flagFit~=1
    errordlg('Please fit data first','Error','modal')
    return    
end
for i=1:handles.m
    figure;
    for j=1:size(handles.cdata{i},2)
    hold on
    plot(handles.res{i}{j},'r',handles.tf{i}(:,1),handles.cdata{i}(:,j),'ob')
    title(['Fitted data - ',handles.folders{i}]);
    legend off;
    set(gca,'xlim',[-1 max(handles.tf{i}(:,1))],'ylim',[0 1.2])
    end
end


% --- Executes during object creation, after setting all properties.
function uipanel13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
