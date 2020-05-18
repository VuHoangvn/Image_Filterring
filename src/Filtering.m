function varargout = demo(varargin)
% DEMO MATLAB code for demo.fig
%      DEMO, by itself, creates a new DEMO or raises the existing
%      singleton*.
%
%      H = DEMO returns the handle to a new DEMO or the handle to
%      the existing singleton*.
%
%      DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEMO.M with the given input arguments.
%
%      DEMO('Property','Value',...) creates a new DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before demo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help demo

% Last Modified by GUIDE v2.5 30-Apr-2020 01:24:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @demo_OpeningFcn, ...
                   'gui_OutputFcn',  @demo_OutputFcn, ...
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


% --- Executes just before demo is made visible.
function demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to demo (see VARARGIN)

% Choose default command line output for demo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = demo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in buttonLoadimg.
function buttonLoadimg_Callback(hObject, eventdata, handles)
% hObject    handle to buttonLoadimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        img = imread('cameraman.tif');
    case 2
        img = imread('ngc6543a.jpg');
    case 3
        img = imread('corn.tif');
    case 4
        img = imread('rice.png');
    case 5
        img = imread('glass.png');
end
axes(handles.anh_goc);
if size(img, 3) == 3
    img = rgb2gray(img);
end
imshow(imresize(img, [size(img, 1) size(img, 1) * 3 / 2 ]));
handles.img = img;
handles.output=hObject;
guidata(hObject, handles);


% --- Executes on button press in buttonApply.
function buttonApply_Callback(hObject, eventdata, handles)
I = handles.img;
axes(handles.anh_chinh_sua);
kerner_type_index = get(handles.kernertype_popup, 'Value');
kerner_size_index = get(handles.kernersize_popup, 'Value');
switch kerner_type_index
    case 1
        kerner_type = 'average';
    case 2
        kerner_type = 'gaussian';
    case 3
        kerner_type = 'laplacian';
    case 4
        kerner_type = 'median';
end

switch kerner_size_index
    case 1
        kerner_size = [3 3];
    case 2
        kerner_size = [5 5];
    case 3
        kerner_size = [7 7];
    case 4
        kerner_size = [9 9];
    case 5
        kerner_size = [11 11];     
end
if strcmp(kerner_type, 'gaussian')
    disp(str2double(get(handles.sigma_text, 'string')));
    H = fspecial(kerner_type, kerner_size, str2double(get(handles.sigma_text, 'string')));
elseif strcmp(kerner_type, 'average')
    H = fspecial(kerner_type, kerner_size);
elseif strcmp(kerner_type, 'laplacian')
    H = fspecial(kerner_type, str2double(get(handles.alpha_text, 'string')));
end
if strcmp(kerner_type, 'median')
    disp(kerner_type);
    I = medfilt2(I, kerner_size);
    imshow(imresize(I, [size(I, 1) size(I, 1) * 3 / 2 ]));
else
    I = uint8(conv2(I, H, 'same'));
    imshow(imresize(I, [size(I, 1) size(I, 1) * 3 / 2 ]));
end
handles.img1 = I;
handles.output=hObject;
guidata(hObject, handles);

% hObject    handle to buttonApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'Img 1', 'Img 2', 'Img 3', 'Img 4', 'Img 5'});


% --- Executes on selection change in kernersize_popup.
function kernersize_popup_Callback(hObject, eventdata, handles)
% hObject    handle to kernersize_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns kernersize_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from kernersize_popup


% --- Executes during object creation, after setting all properties.
function kernersize_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kernersize_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'3x3', '5x5', '7x7', '9x9', '11x11'});


% --- Executes on selection change in kernertype_popup.
function kernertype_popup_Callback(hObject, eventdata, handles)
% hObject    handle to kernertype_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns kernertype_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from kernertype_popup


% --- Executes during object creation, after setting all properties.
function kernertype_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kernertype_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'average', 'gaussian', 'lapacian', 'median'});


% --- Executes on selection change in filtering_type.
function filtering_type_Callback(hObject, eventdata, handles)
% hObject    handle to filtering_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filtering_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filtering_type


% --- Executes during object creation, after setting all properties.
function filtering_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filtering_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'Pixel', 'Kernel', 'Frequency'});

function alpha_text_Callback(hObject, eventdata, handles)
% hObject    handle to alpha_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha_text as text
%        str2double(get(hObject,'String')) returns contents of alpha_text as a double


% --- Executes during object creation, after setting all properties.
function alpha_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sigma_text_Callback(hObject, eventdata, handles)
% hObject    handle to sigma_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sigma_text as text
%        str2double(get(hObject,'String')) returns contents of sigma_text as a double

% --- Executes during object creation, after setting all properties.
function sigma_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sigma_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.img = handles.img1;
handles.output=hObject;
guidata(hObject, handles);
axes(handles.anh_goc);
I = handles.img;
imshow(imresize(I, [size(I, 1) size(I, 1) * 3 / 2 ]));
