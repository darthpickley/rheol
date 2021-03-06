function varargout = layeredit(varargin)
% LAYEREDIT MATLAB code for layeredit.fig

% Last Modified by GUIDE v2.5 18-Apr-2018 14:28:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @layeredit_OpeningFcn, ...
                   'gui_OutputFcn',  @layeredit_OutputFcn, ...
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


%% handles
% --- handles

% layerbox
% addbutton1
% rembutton1
%
% rocksbox
% addbutton2
% rembutton2
% 
% changebutton1
% rockmenu
% thickbox
% 
% pcheckbox
% ptextbox
% 
% togglebutton1
% rheolcheckbox
% rheolbox
% 
% gdepmenu
% gsizebox
%
% strainbox
%
% fnamebox
% savebutton
% fileselectbox
% readbutton


%% notes

% read function
% dir 
% list of .txt file types

%% gui functions
    %ICRaTH
% --- Executes just before layeredit is made visible.
function layeredit_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to layeredit (see VARARGIN)

    indef = 'input_file.txt';       % default input file
    handles = readfile(indef, handles);
    
    xfiles = struct2cell(dir);
    xfls1 = xfiles(1,:)';
    ixvalid = find(contains(xfls1,".txt"));
    fileNames = xfls1(ixvalid);
    handles.flNames = fileNames;
    set(handles.fileselectbox,'String',fileNames);
    outdef = handles.fnamebox.String;        % default output file
    defix = find(contains(fileNames,indef));
    set(handles.fileselectbox,'Value',defix);
    
    plotbutton_Callback(handles.plotbutton, eventdata, handles);

% Choose default command line output for layeredit
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes layeredit wait for user response (see UIRESUME)
% uiwait(handles.fnamebox);


% global parameters
% temperature
% strain rate, deformation style


% --- Outputs from this function are returned to the command line.
function varargout = layeredit_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in layerbox.
function layerbox_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns layerbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from layerbox
ilay = handles.layerbox.Value;
model = handles.model;
set(handles.rockmenu,'Value',model(ilay).irock);
set(handles.thickbox,'String',model(ilay).thick);

load rock;
set(handles.pcheckbox,'Value',1*(model(ilay).pf=='p'));
if (handles.pcheckbox.Value)
    set(handles.ptextbox,'String',' ');
    set(handles.ptextbox,'Enable','off');
else
    set(handles.ptextbox,'String',model(ilay).pf);
    set(handles.ptextbox,'Enable','on');
end

irk = model(ilay).irock(1);
nrhl = size(rock(irk).rheol,2);

for i = 1:nrhl
    rhlnom(i) = i+"- "+rock(irk).rheol(i).ref;
    contained = ~isempty(find(model(ilay).rock(1).irheol==i));
    rhlchk(i) = "O";
    if (contained)
        rhlchk(i) = "X";
    end
end
handles.rheolX = rhlchk;
set(handles.rheolbox,'String',rhlnom);
%uicontrol
set(handles.rheolcheckbox,'String',rhlchk);
set(handles.togglebutton1,'Value',(rhlchk(1)=="X"));
if (size(rock(irk).piezo) == 0)
    set(handles.gdepmenu,'String',"input");
else
    set(handles.gdepmenu,'String',["input",{rock(irk).piezo.ref}]);
end
set(handles.gdepmenu,'Value',model(ilay).rock(1).gc+1);
if( model(ilay).rock(1).gc == 0 )
    set(handles.gsizebox,'String',model(ilay).rock(1).gs);
    set(handles.gsizebox,'Enable','on');
else
    set(handles.gsizebox,'String',0);
    set(handles.gsizebox,'Enable','off');
end


set(handles.changebutton1,'String','Change');
set(handles.changebutton1,'Enable','off');
handles.unsaved = 0;

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function layerbox_CreateFcn(hObject, eventdata, handles)
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in rockmenu.
function rockmenu_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns rockmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rockmenu

load rock;
irk = handles.rockmenu.Value;
nrhl = size(rock(irk).rheol,2);

% rheologies
rhlnom = string([]);
for i = 1:nrhl
    rhlnom(i) = i+"- "+rock(irk).rheol(i).ref;
end
rhlchk = string(handles.rheolcheckbox.String);
while ( size(rhlchk,1) < nrhl )
    rhlchk = [rhlchk;"O"];
end
val = handles.rheolbox.Value;
if (val > nrhl)
    set(handles.rheolbox,'Value',1);
    set(handles.rheolcheckbox,'Value',1);
end
set(handles.rheolbox,'ListboxTop',1);
set(handles.rheolcheckbox,'ListboxTop',1);
set(handles.rheolbox,'Value',1);
set(handles.rheolcheckbox,'Value',1);
rhlchk = rhlchk(1:nrhl);
set(handles.rheolbox,'String',rhlnom);
set(handles.rheolcheckbox,'String',rhlchk(1:nrhl));
handles.rheolX = rhlchk;
if (nrhl == 0)
    set(handles.togglebutton1,'Enable','off');
else
    set(handles.togglebutton1,'Enable','on');
    set(handles.togglebutton1,'Value',1*(rhlchk(1)=="X"));
end


% piezometers / grain dependences
if (size(rock(irk).piezo) == 0)
    set(handles.gdepmenu,'String',"input");
else
    set(handles.gdepmenu,'String',["input",{rock(irk).piezo.ref}]);
end
set(handles.gdepmenu,'Value',1);
set(handles.gsizebox,'Enable','on');

set(handles.changebutton1,'String','Change (changes unsaved)');
set(handles.changebutton1,'Enable','on');
handles.unsaved = 1;

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function rockmenu_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

    % CHANGE

% --- Executes on button press in changebutton1.
function changebutton1_Callback(hObject, eventdata, handles)
load rock;
ilay = handles.layerbox.Value;

disp("changing values");

model = handles.model;

% rock type,  thickness
model(ilay).irock = handles.rockmenu.Value;
model(ilay).thick = str2num(handles.thickbox.String);
% rheologies -> model form
rhlchk = handles.rheolX;
previR = model(ilay).rock(1).irheol;
newiR = [];
for i = 1:size(rhlchk,2)
    if (rhlchk(i) == "X")
        newiR(end+1) = i;
    end
end
for i = 1:size(previR,2)
    if (previR(i) < 0)
        newiR(end+1) = previR(i);
    end
end
model(ilay).rock(1).irheol = newiR;

% pressure
if (handles.pcheckbox.Value)
    model(ilay).pf = 'p';
else
    model(ilay).pf = str2double(handles.ptextbox.String);
end

% grain dependence
if (handles.gdepmenu.Value == 1)
    model(ilay).rock(1).gc = 0;
    model(ilay).rock(1).gs = str2double(handles.gsizebox.String);
else
    model(ilay).rock(1).gc = handles.gdepmenu.Value - 1;
    model(ilay).rock(1).gs = 0;
end

% global vars
mglobal = handles.modelglobal;

mglobal.e = str2double(handles.strainbox.String);
mglobal.G = str2double(handles.Tgradebox.String);
mglobal.Ti = str2double(handles.Tadiabox.String);
mglobal.Ts = str2double(handles.Tsurfbox.String);
mglobal.P0 = str2double(handles.P0box.String);
mglobal.g = str2double(handles.gravbox.String);

mglobal.thid = handles.tempmenu.Value;
mglobal.ip = handles.planetmenu.Value;

% recalculate model parameters
thid = mglobal.thid;
did = mglobal.did;
e = mglobal.e;
ip = mglobal.ip;
Ts = mglobal.Ts;
Ti = mglobal.Ti;
G = mglobal.G;
P0 = mglobal.P0;
g = mglobal.g;
recalc_model;
% /recalculated

handles.model = model;
handles.modelglobal = mglobal;

set(handles.changebutton1,'String','Change');
set(handles.changebutton1,'Enable','off');
handles.unsaved = 0;

plotbutton_Callback(handles.plotbutton, eventdata, handles);

guidata(hObject, handles);

% --- Executes on text changed in thickbox
function thickbox_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of thickbox as text
%        str2double(get(hObject,'String')) returns contents of thickbox as a double

set(handles.changebutton1,'String',"Change - changes unsaved");
set(handles.changebutton1,'Enable','on');
handles.unsaved = 1;

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function thickbox_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

guidata(hObject, handles);

% --- Executes on button press in addbutton1.
function addbutton1_Callback(hObject, eventdata, handles)
ix = handles.layerbox.Value;
lst = handles.layerbox.String;
n = size(lst,1);
disp(n);
set(handles.layerbox,'String',[lst;"NewLayer"+(n+1)]);
model = handles.model;
model(n+1) = model(ix);

% recalculate model parameters
mglobal = handles.modelglobal;
thid = mglobal.thid;
did = mglobal.did;
e = mglobal.e;
ip = mglobal.ip;
Ts = mglobal.Ts;
Ti = mglobal.Ti;
G = mglobal.G;
P0 = mglobal.P0;
g = mglobal.g;
recalc_model;
% /recalculated

handles.model = model;
plotbutton_Callback(handles.plotbutton, eventdata, handles);

guidata(hObject, handles);


% --- Executes on button press in rembutton1.
function rembutton1_Callback(hObject, eventdata, handles)
ix = handles.layerbox.Value;
lst = handles.layerbox.String;
n = size(lst,1);
%handles.layerbox.String = [lst(1:ix-1),lst(ix+1:end)];

set(handles.layerbox,'String',[lst(1:ix-1);lst(ix+1:end)]);
if (ix == n)
    set(handles.layerbox,'Value',n-1);
end
if (n == 1)
    set(handles.layerbox,'Value',1);
end

% remove model(ix) from model
model = handles.model;
for j = (ix:(n-1))
    model(j) = model(j+1);
end
model = model(1:n-1);

% recalculate model parameters
mglobal = handles.modelglobal;
thid = mglobal.thid;
did = mglobal.did;
e = mglobal.e;
ip = mglobal.ip;
Ts = mglobal.Ts;
Ti = mglobal.Ti;
G = mglobal.G;
P0 = mglobal.P0;
g = mglobal.g;
recalc_model;
% /recalculated
handles.model = model;
%update to show the new selected layer
layerbox_Callback(handles.layerbox, eventdata, handles);
plotbutton_Callback(handles.plotbutton, eventdata, handles);

guidata(hObject, handles);


% --- Executes on button press in pcheckbox.
function pcheckbox_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of pcheckbox
if( handles.pcheckbox.Value == 1 )
    set(handles.ptextbox,'Enable','off');
else
    set(handles.ptextbox,'Enable','on');
end

set(handles.changebutton1,'String','Change (changes unsaved)');
set(handles.changebutton1,'Enable','on');
handles.unsaved = 1;

guidata(hObject, handles);

function ptextbox_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of ptextbox as text
%  str2double(get(hObject,'String')) returns contents of ptextbox as a double
set(handles.changebutton1,'String','Change (changes unsaved)');
set(handles.changebutton1,'Enable','on');
handles.unsaved = 1;

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ptextbox_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in rocksbox.
function rocksbox_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns rocksbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rocksbox


% --- Executes during object creation, after setting all properties.
function rocksbox_CreateFcn(hObject, eventdata, handles)
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in rheolcheckbox.
function rheolcheckbox_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns rheolcheckbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rheolcheckbox
ix = handles.rheolcheckbox.Value;
set(handles.rheolbox,'Value',ix);
set(handles.rheolbox,'ListboxTop',handles.rheolcheckbox.ListboxTop);
rhlchk = handles.rheolX;
set(handles.togglebutton1,'Value',1*(rhlchk(ix)=="X"));

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function rheolcheckbox_CreateFcn(hObject, eventdata, handles)
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in rheolbox.
function rheolbox_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns rheolbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rheolbox
ix = handles.rheolbox.Value;
set(handles.rheolcheckbox,'Value',ix);
set(handles.rheolcheckbox,'ListboxTop',handles.rheolbox.ListboxTop);
rhlchk = handles.rheolX;
set(handles.togglebutton1,'Value',1*(rhlchk(ix)=="X"));

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function rheolbox_CreateFcn(hObject, eventdata, handles)
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
ix = handles.rheolbox.Value;
rhlchk = handles.rheolX;
if(rhlchk(ix)=="X")
    rhlchk(ix) = "O";
else
    rhlchk(ix) = "X";
end
set(handles.rheolcheckbox,'String',rhlchk);
handles.rheolX = rhlchk;

set(handles.changebutton1,'String','Change (changes unsaved)');
set(handles.changebutton1,'Enable','on');
handles.unsaved = 1;

guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on button press in addbutton2.
function addbutton2_Callback(hObject, eventdata, handles)
% ADD TO ROCKS

% --- Executes on button press in rembutton2.
function rembutton2_Callback(hObject, eventdata, handles)
% REMOVE ROCK

% --- Executes on selection change in gdepmenu.
function gdepmenu_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns gdepmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from gdepmenu

% GRAIN DEPENDENCES
if( handles.gdepmenu.Value == 1 )
    set(handles.gsizebox,'Enable','on');
else
    set(handles.gsizebox,'Enable','off');
end

set(handles.changebutton1,'String','Change (changes unsaved)');
set(handles.changebutton1,'Enable','on');
handles.unsaved = 1;

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function gdepmenu_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gsizebox_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of gsizebox as text
%        str2double(get(hObject,'String')) returns contents of gsizebox as a double

set(handles.changebutton1,'String','Change (changes unsaved)');
set(handles.changebutton1,'Enable','on');
handles.unsaved = 1;

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function gsizebox_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function strainbox_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of strainbox as text
%        str2double(get(hObject,'String')) returns contents of strainbox as a double

set(handles.changebutton1,'String','Change (changes unsaved)');
set(handles.changebutton1,'Enable','on');
handles.unsaved = 1;

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function strainbox_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% handles

%gsizebox       #
%gdepmenu       #
%addbutton1
%rembutton1
%addbutton2
%rembutton2
%changebutton1  **
%togglebutton1  #
%rheolbox
%rheolcheckbox
%pcheckbox      #
%ptextbox       #
%layerbox
%rockmenu       #
%rocksbox
%thickbox       #
%strainbox      #
%fnamebox
%savebutton
%fileselectbox
%readbutton



function fnamebox_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of fnamebox as text
%        str2double(get(hObject,'String')) returns contents of fnamebox as a double


% --- Executes during object creation, after setting all properties.
function fnamebox_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
model = handles.model;
mglobal = handles.modelglobal;
thid = mglobal.thid;
did = mglobal.did;
e = mglobal.e;
ip = mglobal.ip;

Ts = mglobal.Ts;
Ti = mglobal.Ti;
G = mglobal.G;
P0 = mglobal.P0;
g = mglobal.g;
load planet;

Celsius=273.15;

fileName = handles.fnamebox.String;
save_script;

guidata(hObject, handles);


% --- Executes on selection change in fileselectbox.
function fileselectbox_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns fileselectbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fileselectbox


% --- Executes during object creation, after setting all properties.
function fileselectbox_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in readbutton.
function readbutton_Callback(hObject, eventdata, handles)
fsb_ix = get(handles.fileselectbox,'Value');
fsb_fls = string(get(handles.fileselectbox,'String'));
fileName = fsb_fls(fsb_ix)
handles = readfile(char(fileName), handles);

plotbutton_Callback(handles.plotbutton, eventdata, handles);

guidata(hObject, handles);


% --- Executes on button press in plotbutton.
function plotbutton_Callback(hObject, eventdata, handles)

model = handles.model;

cla;
rectangle('Position',[0,-model(length(model)).zbot,1,model(length(model)).zbot]);
colmap = colorcube;
for j = 1:length(model)
    rectangle('Position',[0.25,-model(j).zbot,0.5,model(j).thick],...
    'FaceColor',colmap(model(j).irock,:),'Curvature',[0.1,0.2]);
    
end




% READ FILE
function newhandles = readfile(filename, handles)

load rock;
load planet;

fname = filename;

parse_script;
    
% model in memory
% modelglobal.e, modelglobal.ip, etc.
mglobal.ip = ip;
mglobal.thid = thid;
mglobal.did = did;
mglobal.e = e;

mglobal.Ts = Ts;
mglobal.Ti = Ti;
mglobal.G = G;
mglobal.P0 = P0;
mglobal.g = g;

handles.model = model;
handles.modelglobal = mglobal;

model = handles.model;
mglobal = handles.modelglobal;
thid = mglobal.thid;    % thermal id
did = mglobal.did;      % deformation id
e = mglobal.e;          % strain rate
ip = mglobal.ip;        % planet id

Ts = mglobal.Ts;        % surface temp
Ti = mglobal.Ti;        % adiabatic temp
G = mglobal.G;          % thermal gradient
P0 = mglobal.P0;        % surface pressure
g = mglobal.g;          % gravity
load planet;
load rock;

Celsius=273.15;


nlay = size(model,2);
for i = 1:nlay
    lyrnom(i) = "Layer " + i;
end

set(handles.layerbox,'String',lyrnom);
set(handles.rockmenu,'String',{rock.name});

% initialize
set(handles.rockmenu,'Value',model(1).irock);
set(handles.thickbox,'String',model(1).thick);
set(handles.gsizebox,'Value',model(1).rock(1).gs);
set(handles.pcheckbox,'Value',(model(1).pf=='p'));
if( handles.pcheckbox.Value == 1 )
    set(handles.ptextbox,'Enable','off');
else
    set(handles.ptextbox,'Enable','on');
end

ibrit = []; iduct = []; nbrit = 0; nduct = 0;

irk = model(1).irock(1);    % irock = irk
nrhl = size(rock(irk).rheol,2); % nrhl = numrheols
% active rheologies
for ia = 1:model(1).rock(1).nrheol
    rhla = model(1).rock(1).irheol(ia);
    if (rhla < 0)
        ibrit = [ibrit,-rhla];
        nbrit = nbrit+1;
    else
        iduct = [iduct,rhla];
        nduct = nduct+1;
    end
end         % add rheologies for rock to ibrit, nbrit

for i = 1:nrhl
    rhlnom(i) = i+"- "+rock(irk).rheol(i).ref;
    contained = ~isempty(find(model(1).rock(1).irheol==i));
    rhlchk(i) = "O";
    if (contained)
        rhlchk(i) = "X";
    end
end         % populate rheolcheckbox, rheolbox names

handles.rheolX = rhlchk;    % String array
set(handles.rheolbox,'String',rhlnom);
set(handles.rheolcheckbox,'String',rhlchk);
set(handles.togglebutton1,'Value',(rhlchk(1)=="X"));
if (~isempty(rock(irk).piezo))
    set(handles.gdepmenu,'String',["input",{rock(irk).piezo.ref}]);
else
    set(handles.gdepmenu,'String',"input");
end
set(handles.gdepmenu,'Value',model(1).rock(1).gc+1);
if( model(1).rock(1).gc == 0 )
    set(handles.gsizebox,'String',model(1).rock(1).gs);
    set(handles.gsizebox,'Enable','on');
else
    set(handles.gsizebox,'String',0);
    set(handles.gsizebox,'Enable','off');
end

% global vars
set(handles.strainbox,'String',e);
set(handles.Tgradebox,'String',G);
set(handles.Tadiabox,'String',Ti);
set(handles.Tsurfbox,'String',Ts);
set(handles.P0box,'String',P0);
set(handles.gravbox,'String',g);

set(handles.tempmenu,'String',["linear","error fn"]);
set(handles.tempmenu,'Value',thid);

set(handles.planetmenu,'String',{planet.name});
set(handles.planetmenu,'Value',ip);


set(handles.changebutton1,'String','Change');
set(handles.changebutton1,'Enable','off');
handles.unsaved = 0;

newhandles = handles;


% Tgradebox
% Tsurfbox
% Tadiabox
% planetmenu
% tempmenu
% P0box
% gravbox


function Tsurfbox_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of Tsurfbox as text
%        str2double(get(hObject,'String')) returns contents of Tsurfbox as a double

set(handles.changebutton1,'String','Change (changes unsaved)');
set(handles.changebutton1,'Enable','on');
handles.unsaved = 1;


% --- Executes during object creation, after setting all properties.
function Tsurfbox_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Tgradebox_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of Tgradebox as text
%        str2double(get(hObject,'String')) returns contents of Tgradebox as a double

set(handles.changebutton1,'String','Change (changes unsaved)');
set(handles.changebutton1,'Enable','on');
handles.unsaved = 1;

% --- Executes during object creation, after setting all properties.
function Tgradebox_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Tadiabox_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of Tadiabox as text
%        str2double(get(hObject,'String')) returns contents of Tadiabox as a double

set(handles.changebutton1,'String','Change (changes unsaved)');
set(handles.changebutton1,'Enable','on');
handles.unsaved = 1;

% --- Executes during object creation, after setting all properties.
function Tadiabox_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in tempmenu.
function tempmenu_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns tempmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tempmenu

set(handles.changebutton1,'String','Change (changes unsaved)');
set(handles.changebutton1,'Enable','on');
handles.unsaved = 1;

% --- Executes during object creation, after setting all properties.
function tempmenu_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function P0box_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of P0box as text
%        str2double(get(hObject,'String')) returns contents of P0box as a double

set(handles.changebutton1,'String','Change (changes unsaved)');
set(handles.changebutton1,'Enable','on');
handles.unsaved = 1;

% --- Executes during object creation, after setting all properties.
function P0box_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function gravbox_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of gravbox as text
%        str2double(get(hObject,'String')) returns contents of gravbox as a double
set(handles.changebutton1,'String','Change (changes unsaved)');
set(handles.changebutton1,'Enable','on');
handles.unsaved = 1;

% --- Executes during object creation, after setting all properties.
function gravbox_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in planetmenu.
function planetmenu_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns planetmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from planetmenu

set(handles.changebutton1,'String','Change (changes unsaved)');
set(handles.changebutton1,'Enable','on');
handles.unsaved = 1;

% --- Executes during object creation, after setting all properties.
function planetmenu_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in defaultbutton.
function defaultbutton_Callback(hObject, eventdata, handles)

load planet;

ip = handles.planetmenu.Value;

Ts=planet(ip).env.Ts;
Ti=planet(ip).env.Ti;
G=planet(ip).env.G;
P0=planet(ip).env.P0;
g=planet(ip).global.gravity;

set(handles.Tgradebox,'String',G);
set(handles.Tadiabox,'String',Ti);
set(handles.Tsurfbox,'String',Ts);
set(handles.P0box,'String',P0);
set(handles.gravbox,'String',g);

set(handles.changebutton1,'String','Change (changes unsaved)');
set(handles.changebutton1,'Enable','on');
handles.unsaved = 1;


