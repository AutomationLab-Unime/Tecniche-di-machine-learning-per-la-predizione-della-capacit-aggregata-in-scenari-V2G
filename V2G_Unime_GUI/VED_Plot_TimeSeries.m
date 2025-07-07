function VED_Plot_TimeSeries(fig)
load(fig.UserData.meteo_data_filepath)
inputs_sys_ident=fig.UserData.YearDataProcessedTable;

tabGroup = findobj(fig, 'Tag', 'tabGroup');
tab = uitab(tabGroup, 'Title',fig.UserData.ZoneName+' - Time-Series - AAC - Exogenous Inputs');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
plot(ax,inputs_sys_ident.start,inputs_sys_ident.V_cc_h1kWh_t, "DisplayName","AAC(kWh)", LineWidth=2)
ylabel(ax,'AAC(kWh)',FontSize=12,FontWeight='bold') %BUG +caldays(1)
hold(ax), yyaxis(ax,'right'),  plot(ax,inputs_sys_ident.start,inputs_sys_ident.holiday_index_t, "DisplayName", "Holiday Index", LineWidth=2)
yyaxis(ax,'right'), plot(ax,inputs_sys_ident.start,normalize(inputs_sys_ident.prcp_t,"zscore"),"DisplayName", "Precipitation (ZScore)", LineWidth=2, Color="g");
yyaxis(ax,'right'), plot(ax,inputs_sys_ident.start,normalize(inputs_sys_ident.temp_t,"zscore"),"DisplayName", "Temperature (ZScore)", LineWidth=2, Color="c");
yyaxis(ax,'right'), plot(ax,inputs_sys_ident.start,normalize(inputs_sys_ident.wspd_t,"zscore"),"DisplayName", "Windspeed (ZScore)", LineWidth=2, Color="m");
legend(ax),




%%remove the categorical column and the one not selected for "feature
%%selection" criteria, correlation, variability
columns_to_delete={'sum_stop_h1h_t','mean_distance_tot_h1km_t'};
inputs_sys_ident(:, columns_to_delete) = [];




% Step size in minutes
step_minutes = 30;







SI_IN_TABLE=inputs_sys_ident(:,3:end);
SI_IN=table2array(SI_IN_TABLE);
SI_OUT=table2array(inputs_sys_ident(:,2));
variable_name=SI_IN_TABLE.Properties.VariableNames;
%Correlation Study
corr_matrix_in=corr(SI_IN,SI_IN);

corr_matrix_in_out=corr(SI_IN,SI_OUT);
% figure,
% imagesc(corr_matrix_in_out),colormap turbo, colorbar, caxis([-1, 1])
% xticks(1:1); % Set x-tick positions (1 to the number of columns in T)
% xticklabels("AAC"); % Set x-tick labels to column names
% % Add y-tick labels if needed (e.g., row labels)
% yticks(1:width(variable_name)); % Set x-tick positions (1 to the number of columns in T)
% yticklabels(variable_name); % Set x-tick labels to column names
% set(gca, 'FontSize', 13, 'FontWeight', 'bold');

tab = uitab(tabGroup, 'Title',fig.UserData.ZoneName+' - Correlation Matrix');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
combined_corr = [corr_matrix_in, corr_matrix_in_out];
imagesc(ax, combined_corr);

% Set colormap, color range, and axis settings
colormap(ax, turbo);              % Apply 'turbo' colormap
colorbar(ax);                     % Add colorbar linked to this axes
caxis(ax, [-1, 1]);               % Fix color scale

% Improve axis ticks and labels
axis(ax, 'tight');                % Fit image tightly
axis(ax, 'xy');                   % Set y increasing from top to bottom if needed
ax.DataAspectRatio = [1 1 1];     % Optional: preserve square cells
xticks(ax,1:width(variable_name)+1); % Set x-tick positions (1 to the number of columns in T)
xticklabels(ax,[variable_name "AAC"]); % Set x-tick labels to column names
% Add y-tick labels if needed (e.g., row labels)
yticks(ax,1:width(variable_name)); % Set x-tick positions (1 to the number of columns in T)
yticklabels(ax,variable_name); % Set x-tick labels to column names
set(ax, 'FontSize', 13, 'FontWeight', 'bold');imagesc(ax, combined_corr);

% Set colormap, color range, and axis settings
colormap(ax, turbo);              % Apply 'turbo' colormap
colorbar(ax);                     % Add colorbar linked to this axes
caxis(ax, [-1, 1]);               % Fix color scale

% Improve axis ticks and labels
axis(ax, 'tight');                % Fit image tightly
axis(ax, 'xy');                   % Set y increasing from top to bottom if needed
ax.DataAspectRatio = [1 1 1];     % Optional: preserve square cells
xticks(ax,1:width(variable_name)+1); % Set x-tick positions (1 to the number of columns in T)
xticklabels(ax,[variable_name "AAC"]); % Set x-tick labels to column names
% Add y-tick labels if needed (e.g., row labels)
yticks(ax,1:width(variable_name)); % Set x-tick positions (1 to the number of columns in T)
yticklabels(ax,variable_name); % Set x-tick labels to column names
set(ax, 'FontSize', 13, 'FontWeight', 'bold');

%CORRELATION ANALYSIS

tab = uitab(tabGroup, 'Title',fig.UserData.ZoneName+' - Correlation Holidays');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
crosscorr(ax,SI_OUT, SI_IN_TABLE.holiday_index_t,"NumLags",30);title(ax,"Crossocorrelation AAC - Holiday Index")
xlabel(ax,'Lags',FontWeight='bold'),ylabel(ax,'xcorr',FontWeight='bold')
tab = uitab(tabGroup, 'Title',fig.UserData.ZoneName+' - Correlation Humidity');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
crosscorr(ax,SI_OUT, SI_IN_TABLE.rhum_t,"NumLags",30);title(ax,"Crossocorrelation AAC - Humidity")
xlabel(ax,'Lags',FontWeight='bold'),ylabel(ax,'xcorr',FontWeight='bold')
tab = uitab(tabGroup, 'Title',fig.UserData.ZoneName+' - Correlation Precipitation');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
crosscorr(ax,SI_OUT, SI_IN_TABLE.prcp_t,"NumLags",30);title(ax,"Crossocorrelation AAC - Precipitation")
xlabel(ax,'Lags',FontWeight='bold'),ylabel(ax,'xcorr',FontWeight='bold')
tab = uitab(tabGroup, 'Title',fig.UserData.ZoneName+' - Correlation Wind Direction');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
crosscorr(ax,SI_OUT, SI_IN_TABLE.wspd_t,"NumLags",30);title(ax,"Crossocorrelation AAC - Wind Speed")
xlabel(ax,'Lags',FontWeight='bold'),ylabel(ax,'xcorr',FontWeight='bold')

tab = uitab(tabGroup, 'Title',fig.UserData.ZoneName+' - Correlation Temperature');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
crosscorr(ax,SI_OUT, SI_IN_TABLE.temp_t,"NumLags",30);title(ax,"Crossocorrelation AAC - Temperature")
xlabel(ax,'Lags',FontWeight='bold'),ylabel(ax,'xcorr',FontWeight='bold')
end


