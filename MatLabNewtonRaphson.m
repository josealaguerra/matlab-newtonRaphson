function varargout = MatLabNewtonRaphson(varargin)
% MATLABNEWTONRAPHSON MATLAB code for MatLabNewtonRaphson.fig
%      MATLABNEWTONRAPHSON, by itself, creates a new MATLABNEWTONRAPHSON or raises the existing
%      singleton*.
%
%      H = MATLABNEWTONRAPHSON returns the handle to a new MATLABNEWTONRAPHSON or the handle to
%      the existing singleton*.
%
%      MATLABNEWTONRAPHSON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATLABNEWTONRAPHSON.M with the given input arguments.
%
%      MATLABNEWTONRAPHSON('Property','Value',...) creates a new MATLABNEWTONRAPHSON or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MatLabNewtonRaphson_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MatLabNewtonRaphson_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MatLabNewtonRaphson

% Last Modified by GUIDE v2.5 26-May-2021 20:27:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MatLabNewtonRaphson_OpeningFcn, ...
                   'gui_OutputFcn',  @MatLabNewtonRaphson_OutputFcn, ...
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

% --- Executes just before MatLabNewtonRaphson is made visible.
function MatLabNewtonRaphson_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MatLabNewtonRaphson (see VARARGIN)

% Choose default command line output for MatLabNewtonRaphson
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);
% UIWAIT makes MatLabNewtonRaphson wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MatLabNewtonRaphson_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    %Obtenemos los valores de lo ingresado en pantalla
    %Funcion f(x)
    funcion  = get(handles.txtFx, 'String');
    %X inicial X0
    x0 = str2double( get(handles.txtX0, 'String') );
    %Tolerancia
    porcentajeError= str2double( get(handles.txtTolerance, 'String') );
    %Damos de alta la variable simbólica X
    syms x
    iteracion=0;
    errorCalculado=100;
    %La funcion enviada como string se convierte en una función simbolica
    %de x
    f=sym(funcion);
    %Se obtiene la primer derivada con respecto a x
    derivada=diff(f,x);
    %Se limpia la tabla
    set(handles.tabla,'Data',{})
    %Si hubo error al obtener la derivada mostrar error
    if derivada==0
        set(handles.txtResultado, 'String', '\nNo fue posible calcular la raiz, esta función no tiene derivada.');
    else
        while errorCalculado>porcentajeError
            fx=subs(f,x0);
            dx=subs(derivada,x0);
            x1=double( vpa( x0-(fx/dx) ));
            errorCalculado=double( vpa( abs(((x1-x0)/x1)*100) ));
            %mostrar datos en tabla
            newRow ={iteracion x0 errorCalculado};
            oldData = get(handles.tabla,'Data');
            newData=[oldData; newRow];
            set(handles.tabla,'Data',newData);

            x0=x1;
            iteracion=iteracion+1;
        end

        respuesta = sprintf('%0.16f',x1);
        set(handles.txtResultado, 'String', strcat('La raiz es: ', respuesta));

    end
catch 
  msgbox('Error al procesar datos !', 'Error', 'error')
end
    
    
    
% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(gcbf, handles, true);


% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

%limpiar tabla
set(handles.tabla,'Data',{});
%Inicializa tolerancia
handles.metricdata.tolerance = '1e-7';
set(handles.txtTolerance, 'String', handles.metricdata.tolerance);
%Inicializa X0
handles.metricdata.x0  = '1.4';
set(handles.txtX0,  'String', handles.metricdata.x0);
%Inicializa resultado
set(handles.txtResultado, 'String', 'Aquí aparecera el resultado');
% Update handles structure
guidata(handles.figure1, handles);



function txtFx_Callback(hObject, eventdata, handles)
% hObject    handle to txtFx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtFx as text
%        str2double(get(hObject,'String')) returns contents of txtFx as a double


% --- Executes during object creation, after setting all properties.
function txtFx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtFx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function txtTolerance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtTolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txtTolerance_Callback(hObject, eventdata, handles)
% hObject    handle to txtTolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtTolerance as text
%        str2double(get(hObject,'String')) returns contents of txtTolerance as a double
tolerance = str2double(get(hObject, 'String'));
if isnan(tolerance)
    set(hObject, 'String', '1e-7');
    errordlg('Tolerancia debe ser un numero','Error');
end

% Save the new txtTolerance value
handles.metricdata.tolerance = tolerance;
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function txtX0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtX0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txtX0_Callback(hObject, eventdata, handles)
% hObject    handle to txtX0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtX0 as text
%        str2double(get(hObject,'String')) returns contents of txtX0 as a double
x0 = str2double(get(hObject, 'String'));
if isnan(x0)
    set(hObject, 'String', '1.4');
    errordlg('X0 debe ser un numero','Error');
end

% Save the new txtX0 value
handles.metricdata.x0 = x0;
guidata(hObject,handles)
