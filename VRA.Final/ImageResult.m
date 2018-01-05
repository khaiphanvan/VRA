% VRA - Khai Phan Van CH1601029
function varargout = ImageResult(varargin)
% IMAGERESULT MATLAB code for ImageResult.fig
%      IMAGERESULT, by itself, creates a new IMAGERESULT or raises the existing
%      singleton*.
%
%      H = IMAGERESULT returns the handle to a new IMAGERESULT or the handle to
%      the existing singleton*.
%
%      IMAGERESULT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGERESULT.M with the given input arguments.
%
%      IMAGERESULT('Property','Value',...) creates a new IMAGERESULT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageResult_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageResult_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageResult

% Last Modified by GUIDE v2.5 03-Jan-2018 17:09:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageResult_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageResult_OutputFcn, ...
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


% --- Executes just before ImageResult is made visible.
function ImageResult_OpeningFcn(hObject, eventdata, handles, varargin)
global lstResult;
global currPage;

for i=1:10
    if i > length(lstResult)
        break;
    end
    subplot(2,5,i);
    imshow(imread(fullfile('oxford\images',lstResult{i})))
    title({lstResult{i} ; num2str(i)},'Interpreter', 'none');
end

set(handles.perImg,'String',[num2str(i) ' / ' num2str(length(lstResult))]);
if i>length(lstResult)
    set(handles.perImg,'String',[num2str(i-1) ' / ' num2str(length(lstResult))]);
end

set(handles.btnNext,'Enable','off');
set(handles.btnPre,'Enable','off');
if length(lstResult) > 10
    set(handles.btnNext,'Enable','on');
end
currPage = 1;

% Choose default command line output for ImageResult
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImageResult wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ImageResult_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnClose.
function btnClose_Callback(hObject, eventdata, handles)
close;

% --- Executes on button press in btnPre.
function btnPre_Callback(hObject, eventdata, handles)
global lstResult;
global currPage;

obj = findobj(gcf,'type','axes');
delete(obj);

currPage = currPage - 1;
for i=(currPage-1)*10+1:currPage*10
    if i > length(lstResult)
        break;
    end
    subplot(2,5,i-((currPage-1)*10));
    imshow(imread(fullfile('oxford\images',lstResult{i})));
    title({lstResult{i} ; num2str(i)},'Interpreter', 'none');
end

set(handles.perImg,'String',[num2str(i) ' / ' num2str(length(lstResult))]);
if i>length(lstResult)
    set(handles.perImg,'String',[num2str(i) ' / ' num2str(length(lstResult))]);
end

set(handles.btnNext,'Enable','on');
if i<=10
    set(handles.btnPre,'Enable','off');
end


% --- Executes on button press in btnNext.
function btnNext_Callback(hObject, eventdata, handles)
global lstResult;
global currPage;

obj = findobj(gcf,'type','axes');
delete(obj);
currPage = currPage + 1;
for i=(currPage-1)*10+1:currPage*10
    if i > length(lstResult)
        break;
    end
    subplot(2,5,i-((currPage-1)*10));
    imshow(imread(fullfile('oxford\images',lstResult{i})));
    title({lstResult{i} ; num2str(i)},'Interpreter', 'none');
end

set(handles.perImg,'String',[num2str(i) ' / ' num2str(length(lstResult))]);
if i>length(lstResult)
    set(handles.perImg,'String',[num2str(i-1) ' / ' num2str(length(lstResult))]);
end

set(handles.btnPre,'Enable','on');
if i>=length(lstResult)
    set(handles.btnNext,'Enable','off');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
clearvars -global currPage;
delete(hObject);
