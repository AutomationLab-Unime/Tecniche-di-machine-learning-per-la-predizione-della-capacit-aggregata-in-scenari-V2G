function V2G_Unime_GUI_rev1()

    % Get screen size
    screenSize = get(0, 'ScreenSize')*0.9;
    headingHeight = 100;
    panelWidth = 400;
    fig.UserData.save_file=true;

    % Create main UI figure
    fig = uifigure('Name', 'V2G Modeling Framework', ...
                   'Position', screenSize-10);

    %% 1. Heading Section (Top Banner)
    headingPanel = uipanel(fig, ...
        'Position', [0, screenSize(4)-headingHeight, screenSize(3), headingHeight], ...
        'BackgroundColor', [0.95 0.95 0.95], ...
        'BorderType', 'none');

    % Left Logo
    uiimage(headingPanel, ...
        'ImageSource', 'logos\Unime_DI.png', ...
        'Position', [0, 0, 160, 120]);

    % Title
    uilabel(headingPanel, ...
        'Text', 'V2G Modeling Framework', ...
        'FontSize', 24, ...
        'FontWeight', 'bold', ...
        'HorizontalAlignment', 'center', ...
        'Position', [screenSize(3)/2 - 150, 30, 300, 40]);

    % Right Logo
    uiimage(headingPanel, ...
        'ImageSource', 'logos\Project_Funding_Logo.jpg', ...
        'Position', [screenSize(3)-160, 0, 160, 120]);

    %% 2. Command Panel (Left)
    panelCommand = uipanel(fig, ...
        'Title', 'Command Panel', ...
        'FontWeight', 'bold', ...
        'FontSize', 16, ...
        'Position', [10, 10, panelWidth, screenSize(4)-headingHeight-20]);

    % Internal Panel Heights
    panelDataLoadHeight=110;
    panelDataExplorationHeight=110;
    panelModelLibraryHeight = 200;
    padding = 40;

    % Data Panel
    panelLoadData = uipanel(panelCommand, ...
        'Title', 'Load Data', ...
        'FontWeight', 'bold', ...
        'FontSize', 14, ...
        'BackgroundColor', [0.9 0.95 1], ...
        'Position', [10, panelCommand.Position(4)-panelDataLoadHeight-padding, ...
                     panelWidth-20, panelDataLoadHeight]);

    btnRawVehicle= uibutton(panelLoadData, ...
        'Text', 'Raw Vehicle Data', ...
        'FontWeight', 'bold', ...
        'FontSize', 13, ...
        'Position', [20, panelDataLoadHeight-60, 200, 30], ...
        'ButtonPushedFcn', @(btn, event) onLoadData_RawVehicle(fig));
btnX = btnRawVehicle.Position(1); 
btnY = btnRawVehicle.Position(2); 
btnW = btnRawVehicle.Position(3); 
btnH = btnRawVehicle.Position(4);

% Define position for the radio button group
radioMargin = 5;
radioGroupWidth = 150;
radioGroupHeight = btnH;

% Create the radio button group beside the button
bgDataset = uibuttongroup(panelLoadData, ...
    'Title', '', ...
    'Units', 'pixels', ...
    'Position', [btnX + btnW + radioMargin, btnY, radioGroupWidth, radioGroupHeight], ...
    'BorderType', 'none', ...
    'SelectionChangedFcn', @(src,event) datasetSelectionCallback(fig, event));

% Create radio buttons
uicontrol(bgDataset, ...
    'Style', 'radiobutton', ...
    'String', 'Rome', ...
    'Units', 'pixels', ...
    'Position', [5, 5, 45, btnH - 5]);

uicontrol(bgDataset, ...
    'Style', 'radiobutton', ...
    'String', 'Padua', ...
    'Units', 'pixels', ...
    'Position', [55, 5, 50, btnH - 5]);

uicontrol(bgDataset, ...
    'Style', 'radiobutton', ...
    'String', 'VED', ...
    'Units', 'pixels', ...
    'Position', [110, 5, 40, btnH - 5]);

% Set default selected (Rome)
bgDataset.SelectedObject = bgDataset.Children(3);  % Rome is the last created, so index 3

% Set default UserData
fig.UserData.DatasetName = 'Rome';
panelRome.Enable='on';
panelPadua.Enable='off';
panelVED.Enable='off';



    uibutton(panelLoadData, ...
        'Text', 'Raw Exogenous Data', ...
        'FontWeight', 'bold', ...
        'FontSize', 13, ...
        'Position', [20, panelDataLoadHeight-100, 200, 30], ...
        'ButtonPushedFcn', @(btn, event) onLoadData_RawExogenous(fig));
%% Panel Data Exploration
    % Data Exploration Panel
    panelDataExploration = uipanel(panelCommand, ...
        'Title', 'Data Exploration', ...
        'FontWeight', 'bold', ...
        'FontSize', 14, ...
        'BackgroundColor', [0.95 0.95 0.8], ...
        'Position', [10, panelLoadData.Position(2)-panelDataExplorationHeight-10, ...
                     panelWidth-20, panelDataExplorationHeight]);

       uibutton(panelDataExploration, ...
        'Text', 'Timeseries Visualization', ...
        'FontWeight', 'bold', ...
        'FontSize', 13, ...
        'Position', [20, panelDataExplorationHeight-60, 200, 30], ...
        'ButtonPushedFcn', @(btn, event) onDataExploration_TimeSeries(fig));

        % --- Button to visualize stop maps ---
    btnStopMaps = uibutton(panelDataExploration, ...
        'Text', 'Stop Maps Visualization', ...
        'FontWeight', 'bold', ...
        'FontSize', 13, ...
        'Position', [20, panelDataExplorationHeight-100, 200, 30], ...
        'ButtonPushedFcn', @(btn, event) onVisualizeStopMaps(fig));


% Recupera posizione del bottone
btnPos = btnStopMaps.Position;
btnX = btnPos(1);
btnY = btnPos(2);
btnW = btnPos(3);
btnH = btnPos(4);

% Posizione del gruppo radio a destra del bottone, allineato verticalmente
bgX = btnX + btnW + 5;          % 10 pixel di distanza a destra
bgY = btnY;                      % stessa altezza del bottone
bgW = 150;                       % larghezza del gruppo
bgH = btnH;                      % stessa altezza del bottone

% Gruppo radio all'interno di panelData
bg = uibuttongroup(panelDataExploration, ...
    'Title', '', ...
    'Units', 'pixels', ...
    'Position', [bgX, bgY, bgW, bgH], ...
    'BorderType', 'none', ...
    'SelectionChangedFcn', @(src,event) updateBasemap(fig, event));

% Pulsante Satellite - metà sinistra del gruppo
uicontrol(bg, ...
    'Style', 'radiobutton', ...
    'String', 'Satellite', ...
    'Units', 'pixels', ...
    'Position', [10, 5, 70, btnH-5]);

% Pulsante Street - metà destra del gruppo
uicontrol(bg, ...
    'Style', 'radiobutton', ...
    'String', 'Topographic', ...
    'Units', 'pixels', ...
    'Position', [70, 5, 70, btnH-5]);
%--- Impostazione predefinita ---
bg.SelectedObject = bg.Children(2);  % Street come default
fig.UserData.Basemap = 'satellite';

function updateBasemap(fig, event)
    selected = event.NewValue.String;
    fig.UserData.Basemap = lower(selected);  % 'satellite' oppure 'street'
    disp(['Basemap selezionata: ' fig.UserData.Basemap]);
end




   % % --- Checkbox for saving processed data ---
   %  cbSave = uicheckbox(panelDataExploration, ...
   %      'Text', 'Save Processed Data', ...
   %      'FontSize', 13, ...
   %      'Position', [20, internalPanelHeight-100, 200, 30], ...
   %      'ValueChangedFcn', @(cb, event) onSaveCheckboxChanged(cb, fig));
   
%% Model Library Panel
    
    panelModel = uipanel(panelCommand, ...
        'Title', 'Model Library', ...
        'FontWeight', 'bold', ...
        'FontSize', 14, ...
        'BackgroundColor', [0.9 1 0.9], ...
        'Position', [10, panelDataExploration.Position(2)-panelModelLibraryHeight - 10, ...
                     panelWidth-20, panelModelLibraryHeight]);
% Altezze e margini per sottopannelli
subPanelHeight = round(panelModelLibraryHeight / 3) - 15;
padding = 10;
buttonHeight = 25;
buttonWidth = 120;

%% --- Subpanel 1: Rome ---
panelRome = uipanel(panelModel, ...
    'Title', 'Rome', ...
    'FontWeight', 'bold', ...
    'BackgroundColor', 'white', ...
    'Position', [10, panelModelLibraryHeight-subPanelHeight - 30 , panelWidth-130, subPanelHeight]);

% Pulsanti orizzontali: Linear Models e Nonlinear Models
uibutton(panelRome, ...
    'Text', 'Linear Models', ...
    'Position', [10, subPanelHeight/2-10 - buttonHeight/2, buttonWidth, buttonHeight], ...
    'ButtonPushedFcn', @(btn, event) onRomeLinearModels(fig));

uibutton(panelRome, ...
    'Text', 'Nonlinear Models', ...
    'Position', [20 + buttonWidth, subPanelHeight/2-10 - buttonHeight/2, buttonWidth, buttonHeight], ...
    'ButtonPushedFcn', @(btn, event) onRomeNonlinearModels(fig));


%% --- Subpanel 2: Padua ---
panelPadua = uipanel(panelModel, ...
    'Title', 'Padua', ...
    'FontWeight', 'bold', ...
    'BackgroundColor', 'white', ...
    'Position', [10, panelRome.Position(2)-subPanelHeight-5, panelWidth-130, subPanelHeight]);

uibutton(panelPadua, ...
    'Text', 'LSTM', ...
    'Position', [10, subPanelHeight/2-10 - buttonHeight/2, buttonWidth, buttonHeight], ...
    'ButtonPushedFcn', @(btn, event) onPaduaLSTM(fig));


%% --- Subpanel 3: VED ---
panelVED = uipanel(panelModel, ...
    'Title', 'VED', ...
    'FontWeight', 'bold', ...
    'BackgroundColor', 'white', ...
    'Position', [10, 5, panelWidth-130, subPanelHeight]);

uibutton(panelVED, ...
    'Text', 'HDMDc', ...
    'Position', [10, subPanelHeight/2-10 - buttonHeight/2, buttonWidth, buttonHeight], ...
    'ButtonPushedFcn', @(btn, event) onVEDHDMDc(fig));

   % uibutton(panelModel, ...
   %      'Text', 'Load Model Input', ...
   %      'FontWeight', 'bold', ...
   %      'FontSize', 13, ...
   %      'Position', [20, internalPanelHeight-60, 200, 30], ...
   %      'ButtonPushedFcn', @(btn, event) onLoadData_ModelInput(fig));
   % 
   %  % Regression Button
   %  uibutton(panelModel, ...
   %      'Text', 'Regression Tool', ...
   %      'FontWeight', 'bold', ...
   %      'FontSize', 13, ...
   %      'Position', [20, internalPanelHeight-100, 200, 30], ...
   %      'ButtonPushedFcn', @(btn, event) onRegressionLearnerePlot());

    % Close Button
    uibutton(panelCommand, ...
        'Text', 'Close', ...
        'Position', [90, 10, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) close(fig));
panelRome.Enable='on';
panelPadua.Enable='off';
panelVED.Enable='off';
    %% 3. Display Panel (Right Side)
    panelDisplay = uipanel(fig, ...
        'Title', 'Figure Display Panel', ...
        'FontWeight', 'bold', ...
        'Position', [panelWidth + 20, 10, ...
                     screenSize(3) - panelWidth - 30, ...
                     screenSize(4) - headingHeight - 20]);

            % Axes Preview
        % Tab Group in Display Panel
        % Margini
        top_margin = 30;     % spazio per i tab
        bottom_margin = 50;  % spazio per xlabel o altro contenuto in basso
        side_margin = 20;
        
        % Calcolo posizione tabGroup dentro panelDisplay
        tabGroup = uitabgroup(panelDisplay, ...
            'Units', 'pixels', ...
            'Position', [side_margin, ...
                         bottom_margin, ...
                         panelDisplay.Position(3) - 2*side_margin, ...
                         panelDisplay.Position(4) - top_margin - bottom_margin], ...
            'Tag', 'tabGroup');
        
        % Margini
        right_margin = 20;
        bottom_margin = 10;
        button_width = 120;
        button_height = 30;
        
        % Posizione del pulsante in basso a destra nel panelDisplay
        uibutton(panelDisplay, ...
            'Text', 'Close Tabs', ...
            'FontWeight', 'bold', ...
            'FontSize', 13, ...
            'Position', [panelDisplay.Position(3) - button_width - right_margin, ...
                         bottom_margin, ...
                         button_width, ...
                         button_height], ...
            'ButtonPushedFcn', @(btn, event) closeAllTabs(fig));

        %% --- Panel: Advanced Analysis ---

panelAdvancedHeight=60;
panelAdvanced = uipanel(panelCommand, ...
    'Title', 'Advanced Analysis', ...
    'FontWeight', 'bold', ...
    'FontSize', 14, ...
    'BackgroundColor', [1, 0.9, 0.9], ...  % Colore diverso
    'Position', [10, panelModel.Position(2)-panelAdvancedHeight-10, ...
                 panelWidth-20, panelAdvancedHeight]);

% Dimensioni relative

buttonWidth = 140;
buttonHeight = 30;
spacing = 20;
panelInnerWidth = panelAdvanced.Position(3);

% Calcola posizioni centrate orizzontalmente
totalWidth = 2*buttonWidth + spacing;
startX = (panelInnerWidth - totalWidth)/2;
yPos = 5;

% Bottone: Interpretability
uibutton(panelAdvanced, ...
    'Text', 'Interpretability', ...
    'FontWeight', 'bold', ...
    'FontSize', 13, ...
    'Position', [startX, yPos, buttonWidth, buttonHeight], ...
    'ButtonPushedFcn', @(btn, event) onInterpretability(fig));

% Bottone: Transferability
uibutton(panelAdvanced, ...
    'Text', 'Transferability', ...
    'FontWeight', 'bold', ...
    'FontSize', 13, ...
    'Position', [startX + buttonWidth + spacing, yPos, buttonWidth, buttonHeight], ...
    'ButtonPushedFcn', @(btn, event) onTransferability(fig));

% Altezza del nuovo pannello
panelDocumentationHeight = 60;
docY = panelAdvanced.Position(2) - panelDocumentationHeight - 10;

% Pannello "Documentation"
panelDocumentation = uipanel(panelCommand, ...
    'Title', 'Documentation', ...
    'FontWeight', 'bold', ...
    'FontSize', 14, ...
    'BackgroundColor', [0.95 0.9 1], ...  % viola molto chiaro
    'Position', [10, docY, ...
                 panelWidth - 20, panelDocumentationHeight]);

% Larghezza e margini per i 3 bottoni
buttonWidth = (panelDocumentation.Position(3) - 4 * 10) / 3;
buttonHeight = 30;
buttonY = panelDocumentationHeight - 55;

% Bottone 1: Dataset Doc
uibutton(panelDocumentation, ...
    'Text', 'Dataset Doc', ...
    'FontWeight', 'bold', ...
    'Position', [10, buttonY, buttonWidth, buttonHeight], ...
    'ButtonPushedFcn', @(btn, event) openDatasetDocFunctionFolder());

% Bottone 2: ReadMe
uibutton(panelDocumentation, ...
    'Text', 'ReadMe', ...
    'FontWeight', 'bold', ...
    'Position', [20 + buttonWidth, buttonY, buttonWidth, buttonHeight], ...
    'ButtonPushedFcn', @(btn, event) openReadMeFolder());

% Bottone 3: Publications (apre cartella)
uibutton(panelDocumentation, ...
    'Text', 'Publications', ...
    'FontWeight', 'bold', ...
    'Position', [30 + 2 * buttonWidth, buttonY, buttonWidth, buttonHeight], ...
    'ButtonPushedFcn', @(btn, event) openPublicationsFolder());

%% Callback: Load Data
function onLoadData_RawVehicle(fig)
    folderPath=fullfile(pwd, 'Data', fig.UserData.DatasetName);
    [file, path] = uigetfile('*.mat;*.csv', 'MAT and CSV Files (*.mat, *.csv)', folderPath);
    if isequal(file, 0)
        uialert(fig, 'No file selected', 'Load Cancelled');
    else
        fullPath = fullfile(path, file);
        disp(['✅ Loaded: ', fullPath]);
        fig.UserData.rowdata_filepath=fullPath;
        [pathstr,name,ext] = fileparts(fullPath)
        fileNameParts=split(name,'_');
        fig.UserData.ZoneName=string(fileNameParts(1));
        disp(fieldnames(fig.UserData));
        VisualizeRawDataTable(fig);
    end
end

    % % --- Callback for checkbox ---
    % function onSaveCheckboxChanged(cb, fig)
    %     fig.UserData.save_file = cb.Value;
    %     disp(['Save Processed Data set to: ', mat2str(cb.Value)]);
    %     end
    



function onLoadData_RawExogenous(fig)
    folderPath=fullfile(pwd, 'Data', fig.UserData.DatasetName);
    [file, path] = uigetfile('*.mat', 'Select MAT File', folderPath);
    if isequal(file, 0)
        uialert(fig, 'No file selected', 'Load Cancelled');
    else
        fullPath = fullfile(path, file);
        disp(['✅ Loaded: ', fullPath]);
        fig.UserData.meteo_data_filepath=fullPath;
        disp(fieldnames(fig.UserData));
        VisualizeRawExogenousTable(fig);

    end
end

%%
    % --- Callback for stop maps visualization ---
function onVisualizeStopMaps(fig)
    if isfield(fig.UserData, 'rowdata_filepath')
    disp('📍 Visualizing stop maps...');
        if strcmp(fig.UserData.DatasetName, 'Rome')
            Rome_visualize_stop_maps(fig);
        elseif strcmp(fig.UserData.DatasetName, 'Padua')
            Padua_visualize_stop_maps(fig);
        elseif strcmp(fig.UserData.DatasetName, 'VED')
            VED_visualize_stop_maps(fig);
        end
    else
    uialert(fig, 'Please load Raw Vehicle Data first.', 'Missing Data');
    end
end

function onDataExploration_TimeSeries(fig)
    fig.UserData.save_file=true;
    if strcmp(fig.UserData.DatasetName, 'Rome')
        Rome_Generate_AAC_meteo_calendar_fnc(fig)
    elseif strcmp(fig.UserData.DatasetName, 'Padua')
        Padua_Plot_TimeSeries(fig)
    elseif strcmp(fig.UserData.DatasetName, 'VED')
        VED_Plot_TimeSeries(fig)
    end
end

function closeAllTabs(fig)
    tabGroup = findobj(fig, 'Type', 'uitabgroup', 'Tag', 'tabGroup');
    if isempty(tabGroup)
        uialert(fig, 'Nessun tabgroup trovato.', 'Errore');
        return;
    end

    tabs = tabGroup.Children;  % Children restituisce tutti i tab (uitab)
    for i = 1:numel(tabs)
        delete(tabs(i));
    end
end
%     function onLoadData_ModelInput(fig)
%     [file, path] = uigetfile('*.mat', 'Select MAT File');
%     if isequal(file, 0)
%         uialert(fig, 'No file selected', 'Load Cancelled');
%     else
%         fullPath = fullfile(path, file);
%         fig.UserData.regressors = load(fullPath);
%         disp(['✅ Loaded: ', fullPath]);
%         disp(fieldnames(fig.UserData));
%     end
% end

% %% Callback: Undock Plot
% function onRegressionLearnerePlot()
%     f = figure('Name', 'Undocked Plot');
%     x = linspace(0, 2*pi, 1000);
%     plot(f.CurrentAxes, x, sin(x));
%     title('Undocked Plot'); xlabel('Time'); ylabel('Amplitude');
% end

%% Callback: Regression Learner
% function onRegressionLearnerePlot()
%      regressionLearner(fig.UserData.regressors.zone_struct.Regressors, 'AAC_1');
% end
function datasetSelectionCallback(fig, event)
    selectedDataset = event.NewValue.String;
    fig.UserData.DatasetName = selectedDataset;
    switch fig.UserData.DatasetName
        case 'Rome'
            panelRome.Enable='on';
            panelPadua.Enable='off';
            panelVED.Enable='off';        
        case 'Padua'
            panelRome.Enable='off';
            panelPadua.Enable='on';
            panelVED.Enable='off';
        case 'VED'
            panelRome.Enable='off';
            panelPadua.Enable='off';
            panelVED.Enable='on';
    end
    disp(['✅ Dataset selected: ', selectedDataset]);
end

function onRomeLinearModels(fig)
    disp('Opening Linear Models for Rome...');
    regressionLearner(fullfile(pwd,"Models/","Rome214_LinearRegressionLearnerSession.mat"));
end

function onRomeNonlinearModels(fig)
    disp('Opening Nonlinear Models for Rome...');
    regressionLearner(fullfile(pwd,"Models/","Rome214_NonLinearRegressionLearnerSession.mat"));
end

    function onInterpretability(fig)
    disp('Opening Nonlinear Models for Rome...');
    regressionLearner(fullfile(pwd,"Models/","Rome214_NonLinearRegressionLearnerSession.mat"));
end

function onPaduaLSTM(fig)
    disp('Opening LSTM for Padua...');
    notebookPath = fullfile(pwd, 'PythonCode','LSTM_Padua', 'v2g_v2_torch_Padova_scaler_corretto_transfer_training.ipynb');
    folderPath = fileparts(notebookPath);

    if isfile(notebookPath)
        % Apri Visual Studio Code nella cartella e apri il file
        system(['code "',folderPath,'" "',notebookPath,'"']);
    else
        uialert(gcf, 'Notebook non trovato', 'Errore');
    end
end

    function onTransferability(fig)
    disp('Opening LSTM for Padua...');
    notebookPath = fullfile(pwd, 'PythonCode','LSTM_Padua', 'v2g_v2_torch_Padova_scaler_corretto_transfer_training.ipynb');
    folderPath = fileparts(notebookPath);

    if isfile(notebookPath)
        % Apri Visual Studio Code nella cartella e apri il file
        system(['code "',folderPath,'" "',notebookPath,'"']);
    else
        uialert(gcf, 'Notebook non trovato', 'Errore');
    end
end

function onVEDHDMDc(fig)
    disp('Opening HDMDc for VED...');
    % Percorso relativo (modifica se necessario)
    notebookPath = fullfile(pwd, 'PythonCode','pydmd', 'DMDc_k_step_ahead.ipynb');
    folderPath = fileparts(notebookPath);

    if isfile(notebookPath)
        % Apri Visual Studio Code nella cartella e apri il file
        system(['code "',folderPath,'" "',notebookPath,'"']);
    else
        uialert(gcf, 'Notebook non trovato', 'Errore');
    end
end

function openDatasetDocFunctionFolder()
    fullPath = fullfile(pwd, 'Documentation\DatasetDocs\');
    if isfolder(fullPath)
        winopen(fullPath);
    else
        uialert(gcf, ['File non trovato: ', docPath], 'Errore');
    end
end

function openReadMeFolder()
    fullPath = fullfile(pwd, 'Documentation\ReadMe\');
    if isfolder(fullPath)
        winopen(fullPath);
    else
        uialert(gcf, ['File non trovato: ', docPath], 'Errore');
    end
end

function openPublicationsFolder()
    folderPath = fullfile(pwd, 'Documentation\Publications\');
    if isfolder(folderPath)
        winopen(folderPath);
    else
        uialert(gcf, ['Cartella non trovata: ', folderPath], 'Errore');
    end
end

end