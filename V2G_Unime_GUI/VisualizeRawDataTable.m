function VisualizeRawDataTable(fig)
tabGroup = findobj(fig, 'Tag', 'tabGroup');
tab = uitab(tabGroup, 'Title',"Raw Data");
%load(fig.UserData.meteo_data_filepath)

if fig.UserData.DatasetName=="Padua"
    S = load(fig.UserData.rowdata_filepath);
    % Get all field names in the loaded structure
    varNames = fieldnames(S);
    % Find the variable whose name starts with the same file root
    matchIdx = contains(varNames, "Prenew");
    T = S.(varNames{1});

elseif fig.UserData.DatasetName=="Rome"
    load(fig.UserData.rowdata_filepath);
    T=V2G_table_pre;
elseif fig.UserData.DatasetName=="VED"
    T=importfile_VED_Raw(fig.UserData.rowdata_filepath);
end
uitable(tab, ...
    'Data', T, ...
    'ColumnName', T.Properties.VariableNames, ...
    'RowName', [], ...
    'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);  % <-- enables scrollbars
end