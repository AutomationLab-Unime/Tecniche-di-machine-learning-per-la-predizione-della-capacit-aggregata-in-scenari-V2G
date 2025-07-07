function VisualizeRawExogenousTable(fig)
tabGroup = findobj(fig, 'Tag', 'tabGroup');
tab = uitab(tabGroup, 'Title',"Exogenous Raw Data");
load(fig.UserData.meteo_data_filepath)

if fig.UserData.DatasetName=="Padua"
    [~, name, ~] = fileparts(fig.UserData.meteo_data_filepath);  % Get 'zona56_V1_PO'
    
    % Load the file into a structure
    S = load(fig.UserData.meteo_data_filepath);
    % Get all field names in the loaded structure
    varNames = fieldnames(S);
    % Find the variable whose name starts with the same file root
    matchIdx = startsWith(varNames, name);
    T = S.(varNames{matchIdx(1)});
    % load(pwd+"\Data\Padua\Traffico ingresso\zona56_V1_PO.mat");
    % T=zona56_V1_PO_28_03_2018;
elseif fig.UserData.DatasetName=="Rome"
    T=EUR_meteo_year_hh;
elseif fig.UserData.DatasetName=="VED"
    fig.UserData.YearDataProcessedTable=YearDataProcessedTable;
    T=YearDataProcessedTable(1:1000,:);
end
uitable(tab, ...
    'Data', T, ...
    'ColumnName', T.Properties.VariableNames, ...
    'RowName', [], ...
    'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);  % <-- enables scrollbars
end