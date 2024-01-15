function varargout = Multiplayer(varargin)
% MULTIPLAYER MATLAB code for Multiplayer.fig
%      MULTIPLAYER, by itself, creates a new MULTIPLAYER or raises the existing
%      singleton*.
%
%      H = MULTIPLAYER returns the handle to a new MULTIPLAYER or the handle to
%      the existing singleton*.
%
%      MULTIPLAYER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MULTIPLAYER.M with the given input arguments.
%
%      MULTIPLAYER('Property','Value',...) creates a new MULTIPLAYER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Multiplayer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Multiplayer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Multiplayer

% Last Modified by GUIDE v2.5 09-Jun-2019 13:35:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Multiplayer_OpeningFcn, ...
                   'gui_OutputFcn',  @Multiplayer_OutputFcn, ...
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


% --- Executes just before Multiplayer is made visible.
function Multiplayer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Multiplayer (see VARARGIN)

% Choose default command line output for Multiplayer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Multiplayer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Multiplayer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%Load function(파일 로드)
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xin;
global Fs;

[file, path] = uigetfile('*.wav');
[xin,Fs]=audioread([path file]);
handles.edit1.String=[path file];
Len=Fs*10;
xin= xin(1:Len,1);

%Load된 파일경로 표시
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%HRTF rendering 버튼
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xin;
global Fs;

angle = str2double(handles.edit2.String);

load small_pinna_final.mat;

ai = right(:,fix(angle/5)+1);     % Ipsi-lateral path impulse response
ac = left(:,fix(angle/5)+1);      % contra-lateral path impulse response

%% % Extract minimum-phase components using Ceptrum-based method
N = 200;        % order of the FIR filter
ai = ai(1:N,1);
ac = ac(1:N,1);

%% filtering
x_r = zeros(N,1);
x_l = zeros(N,1);
x_r_output = zeros(length(xin),1);
x_l_output = zeros(length(xin),1);

for i = 1:length(xin)
    x_r = [ xin(i); x_r(1:end-1) ];
    x_r_output(i)=ai'*x_r;
    
    x_l = [ xin(i); x_l(1:end-1) ];
    x_l_output(i)=ac'*x_l;
end


output = [x_l_output,x_r_output];

figure,plot(ai);
hold on,plot(ac);
legend('left','right');
grid on;

audiowrite('output HRTF.wav',output,Fs);

sound(output,Fs);

%Reverberator 버튼
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xin;
global Fs;

xin=xin(:,1);
xin=0.5*xin(1:Fs*10);

tau1=0.030;
tau2=0.037;
tau3=0.041;
tau4=0.044;

gs=1.0;
gr=0.25;
tau_allpass = 1.7/1000;

M1=floor(tau1*Fs);
M2=floor(tau2*Fs);
M3=floor(tau3*Fs);
M4=floor(tau4*Fs);


Lc1= floor(0.030*Fs);
Lc2= floor(0.037*Fs);
Lc3= floor(0.041*Fs);
Lc4= floor(0.044*Fs);

g1 = 10^(-3*tau1/1.2);
g2 = 10^(-3*tau2/1.2);
g3 = 10^(-3*tau3/1.2);
g4 = 10^(-3*tau4/1.2);

m1 = zeros(Lc1,1);
m2 = zeros(Lc2,1);
m3 = zeros(Lc3,1);
m4 = zeros(Lc4,1);

y1=comb_filter(xin,tau1,Fs);
y2=comb_filter(xin,tau2,Fs);
y3=comb_filter(xin,tau3,Fs);
y4=comb_filter(xin,tau4,Fs);

comb_combined = y1+y2+y3+y4;

tau=1.7/1000;
y5=all_pass_filter(comb_combined,tau_allpass,Fs);
y6=all_pass_filter(y5,tau_allpass,Fs);

y6=y6.';

output=gs.*xin+gr.*y6

audiowrite('output Rever.wav',output,Fs);

figure,plot(xin);
hold on,plot(output,'--');

sound(output,Fs);

%Amplitude(left->right) 버튼
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xin;
global Fs;
 
xin=xin(:,1);
v=-100:100;
x=v/200+0.5;
rightGain1=x;
leftGain1=1-x;
rightGain2=sin(x*(3.14/2));
leftGain2=sin((1-x)*(3.14/2));
figure,plot(v,leftGain1,v,rightGain1,v,leftGain2,v,rightGain2);

rightGain=(1:length(xin))/length(xin);
leftGain=1-rightGain;

outLeft=xin.* leftGain';
outRight=xin.* rightGain';

yo=[outLeft outRight];
sound(yo,44100);

audiowrite('output left right.wav',yo,Fs);

%Amplitude(around) 버튼
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xin;
global Fs;

xin = xin(:,1);
 
v = -100:100;
x = v/200 + 0.5;
rightGain1 = x;
leftGain1 = 1-x;
rightGain2 = sin( x * (2*pi/2) );
leftGain2 = sin( (1 - x) * (2*pi/2) );
 
figure,plot(v,leftGain1,v,rightGain1,v,leftGain2,v,rightGain2);
 
rightGain=(1:length(xin)/2)/(length(xin)/2);
rightGain = [rightGain,rightGain(end:-1:1)];
 
leftGain=1 - rightGain;
 
outLeft=xin .*leftGain';
outRight=xin .* rightGain';
 
yo = [outLeft outRight];
 
sound(yo,44100);   
audiowrite('output round.wav',yo,Fs);


% --- Executes on button press in pushbutton6.
%-- 필터링
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xin;
global Fs;

xin=xin;
Fs=200;
n=5;
Wn=10;
Fn=Fs/2;
ftype='high'
[b,a]=butter(n,Wn/Fn,ftype);
y=filter(b,a,xin);
sound(y,44100);
audiowrite('output h_filter.wav',y,Fs);
figure,plot(y);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xin;
global Fs;

xin=xin;
Fs=200;
n=5;
Wn=30;
Fn=Fs/2
ftype='low'
[b,a]=butter(n,Wn/Fn,ftype);
y=filter(b,a,xin);
sound(y,44100);
audiowrite('output L_filter.wav',y,Fs);
figure,plot(y);
