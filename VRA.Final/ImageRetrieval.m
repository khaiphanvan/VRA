% VRA - Khai Phan Van CH1601029
function varargout = ImageRetrieval(varargin)
%IMAGERETRIEVAL MATLAB code file for ImageRetrieval.fig
%      IMAGERETRIEVAL, by itself, creates a new IMAGERETRIEVAL or raises the existing
%      singleton*.
%
%      H = IMAGERETRIEVAL returns the handle to a new IMAGERETRIEVAL or the handle to
%      the existing singleton*.
%
%      IMAGERETRIEVAL('Property','Value',...) creates a new IMAGERETRIEVAL using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to ImageRetrieval_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      IMAGERETRIEVAL('CALLBACK') and IMAGERETRIEVAL('CALLBACK',hObject,...) call the
%      local function named CALLBACK in IMAGERETRIEVAL.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageRetrieval

% Last Modified by GUIDE v2.5 04-Jan-2018 21:20:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageRetrieval_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageRetrieval_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before ImageRetrieval is made visible.
function ImageRetrieval_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for ImageRetrieval
global imageSearchDir;
global imagefiles;
global h;
global axs;
global index;
global pos;
global imgName;
global imgPath;
global isBrowse;

imageSearchDir = 'ImageSearch';
imagefiles = dir(fullfile(imageSearchDir, '*.jpg'));
axs = [handles.axImageShow,handles.axImageThumb1,handles.axImageThumb2,handles.axImageThumb3,handles.axImageThumb4,handles.axImageThumb5];

for i=1:length(axs)
    axes(axs(i));
    ax = get(axs(i), 'ButtonDownFcn');
    k=i-1;
    if i==1 
        k=1;
    end
    hImage = imshow(fullfile(imagefiles(k).folder,imagefiles(k).name));
    hImage.HitTest = 'off';
    hImage.PickableParts = 'none';
    set(axs(i),'PickableParts','all')
    set(axs(i), 'ButtonDownFcn', ax);
end
isBrowse = false;
index =1;
imgName = imagefiles(index).name;

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = ImageRetrieval_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnSearch.
function btnSearch_Callback(hObject, eventdata, handles)
global pos;
global imagefiles;
global index;
global imgName;
global imgPath;
global isBrowse;

if isBrowse
    fullImgSearch = fullfile(imgPath,imgName);
    imgSearch = imgName;
else
    fullImgSearch = fullfile(imagefiles(index).folder,imagefiles(index).name);
    imgSearch = imagefiles(index).name;
end

if isempty(pos)
    imgInfo = imfinfo(fullImgSearch);
    pos=[1 1 imgInfo.Width imgInfo.Height];
end
global lstResult;

[numImg,isNumeric] = str2num(get(handles.txtNumImg,'String'));
if ~isNumeric || numImg <1 || numImg > 5063
    uiwait(msgbox('Please input numeric and value in [1 5063]','Error','Error'));
    uicontrol(handles.txtNumImg);
else
    if pos(3)==0 || pos(4)==0
        uiwait(msgbox({'Please select a section !';'You has chosen a line or a point on image'},'Image section','warn'));
        return;
    end

    lstResult= searchImageOxfordBuilding(imgSearch,pos,numImg);
    if length(lstResult) == 0
        uiwait(msgbox('No result found.','Result','warn'));
        return;
    end
    run ImageResult.m;
end

% --- Executes on button press in btnClose.
function btnClose_Callback(hObject, eventdata, handles)
choice = questdlg('Do you want exit ?', ...
	'Close', ...
	'Yes','No','No');
% Handle response
switch choice
    case 'Yes'
        close;
    otherwise
end

% --- Executes on mouse press over axes background.
function axImageShow_ButtonDownFcn(hObject, eventdata, handles)
global h;
global imagefiles;
global index;
global pos;

if exist('h','var')== 1
    delete(h);
end

try
    h= imrect(gca);
    h.setColor('g');
    setResizable(h,0);
    pos = getPosition(h);
    handles.axImageShow;
    img = imfinfo(fullfile(imagefiles(index).folder,imagefiles(index).name));
    %x
    if pos(1)<0
        pos(3)=pos(3)+pos(1);
        pos(1)=1;
    end
    %y
    if pos(2)<0
        pos(4)=pos(4)+pos(2);
        pos(2)=1;
    end
    %width
    if pos(1)+pos(3)>img.Width
        pos(3)=img.Width-pos(1);
    end
    %heigth
    if pos(2)+pos(4)>img.Height
        pos(4)=img.Height-pos(2);
    end
    setPosition(h,pos);
catch
end
% --- Executes on mouse press over axes background.
function axImageThumb1_ButtonDownFcn(hObject, eventdata, handles)
global axs;
global imagefiles;
global index;
global isBrowse;
isBrowse = false;

index=find(axs==handles.axImageThumb1);
index =index-1;
if index==0
    index=1;
end

img = fullfile(imagefiles(index).folder,imagefiles(index).name);
axes(handles.axImageShow);
ax = get(handles.axImageShow, 'ButtonDownFcn');
hImage = imshow(img);
hImage.HitTest = 'off';
hImage.PickableParts = 'none';
set(handles.axImageShow,'PickableParts','all')
set(handles.axImageShow, 'ButtonDownFcn', ax);

% --- Executes on mouse press over axes background.
function axImageThumb2_ButtonDownFcn(hObject, eventdata, handles)
global axs;
global imagefiles;
global index;
global isBrowse;
isBrowse = false;

index=find(axs==handles.axImageThumb2);
index =index-1;
if index==0
    index=1;
end

img = fullfile(imagefiles(index).folder,imagefiles(index).name);
axes(handles.axImageShow);
ax = get(handles.axImageShow, 'ButtonDownFcn');
hImage = imshow(img);
hImage.HitTest = 'off';
hImage.PickableParts = 'none';
set(handles.axImageShow,'PickableParts','all')
set(handles.axImageShow, 'ButtonDownFcn', ax);


% --- Executes on mouse press over axes background.
function axImageThumb3_ButtonDownFcn(hObject, eventdata, handles)
global axs;
global imagefiles;
global index;
global isBrowse;
isBrowse = false;

index=find(axs==handles.axImageThumb3);
index =index-1;
if index==0
    index=1;
end

img = fullfile(imagefiles(index).folder,imagefiles(index).name);
axes(handles.axImageShow);
ax = get(handles.axImageShow, 'ButtonDownFcn');
hImage = imshow(img);
hImage.HitTest = 'off';
hImage.PickableParts = 'none';
set(handles.axImageShow,'PickableParts','all')
set(handles.axImageShow, 'ButtonDownFcn', ax);


% --- Executes on mouse press over axes background.
function axImageThumb4_ButtonDownFcn(hObject, eventdata, handles)
global axs;
global imagefiles;
global index;
global isBrowse;
isBrowse = false;

index=find(axs==handles.axImageThumb4);
index =index-1;
if index==0
    index=1;
end

img = fullfile(imagefiles(index).folder,imagefiles(index).name);
axes(handles.axImageShow);
ax = get(handles.axImageShow, 'ButtonDownFcn');
hImage = imshow(img);
hImage.HitTest = 'off';
hImage.PickableParts = 'none';
set(handles.axImageShow,'PickableParts','all')
set(handles.axImageShow, 'ButtonDownFcn', ax);


% --- Executes on mouse press over axes background.
function axImageThumb5_ButtonDownFcn(hObject, eventdata, handles)
global axs;
global imagefiles;
global index;
global isBrowse;
isBrowse = false;

index=find(axs==handles.axImageThumb5);
index =index-1;
if index==0
    index=1;
end

img = fullfile(imagefiles(index).folder,imagefiles(index).name);
axes(handles.axImageShow);
ax = get(handles.axImageShow, 'ButtonDownFcn');
hImage = imshow(img);
hImage.HitTest = 'off';
hImage.PickableParts = 'none';
set(handles.axImageShow,'PickableParts','all')
set(handles.axImageShow, 'ButtonDownFcn', ax);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
clearvars -global;
delete(hObject);


% --- Executes on button press in btnBrowse.
function btnBrowse_Callback(hObject, eventdata, handles)
global isBrowse;
global imgName;
global imgPath;

[FileName,PathName] = uigetfile({'*.jpg;*.tif;*.png;*.gif','Image Files'},'Image Search','oxford\images');
if FileName == 0
	% User clicked the Cancel button.
	return;
end

isBrowse = true;
imgName = FileName;
imgPath = PathName;

axes(handles.axImageShow);
ax = get(handles.axImageShow, 'ButtonDownFcn');
hImage = imshow(imread([PathName, FileName]));
hImage.HitTest = 'off';
hImage.PickableParts = 'none';
set(handles.axImageShow,'PickableParts','all')
set(handles.axImageShow, 'ButtonDownFcn', ax);
