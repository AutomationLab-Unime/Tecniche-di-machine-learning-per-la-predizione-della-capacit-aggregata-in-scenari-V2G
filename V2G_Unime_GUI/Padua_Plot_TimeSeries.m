function Padua_Plot_TimeSeries(fig)
%load(fig.UserData.meteo_data_filepath)
%load('C:\Users\franc\OneDrive - unime.it\General\02_2024_CNR_V2G\Dati Comi\Analisi e Modelli V2G\Modelli\Dati per sim modelli\Dati per R.D. new\Traffico_dati_nuovi_Padova.mat')
%load(fig.UserData.rowdata_filepath);
load(pwd+"\Data\Padua\Dati per sim modelli\"+"Regression Dataset full days new.mat")
load(pwd+"\Data\Padua\Dati per sim modelli\Dati per R.D. new\"+"Traffico_dati_nuovi_Padova.mat")

%array orario per input modello (per interval_time = 30 avremo 48 punti)
interval_time = 30;
num_regressori=0;
interval = interval_time/60;
num_intervals = (60/interval_time) * 24;
array_time = (0:interval:23.5)';


% Impostazione orario per plot
start_time = datetime('00:00', 'InputFormat', 'HH:mm');
time_vector = start_time + minutes(0:interval_time :(num_intervals*interval_time-1));
time = datestr(time_vector(1:end,1:2:end), 'HH:MM');

tabGroup = findobj(fig, 'Tag', 'tabGroup');
%% plot AAC
tab = uitab(tabGroup, 'Title','Zone-24 AAC');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
day_block_samples=48;
regressors=3;
plot(ax,[zeros(regressors,1) ; Regression_Dataset_full_days.AAC24_k(1:day_block_samples-regressors)], 'DisplayName','Day 1 - 19-03-2018', 'LineWidth',2)
hold(ax), plot(ax,Regression_Dataset_full_days.AAC24_k(day_block_samples-regressors+1:2*day_block_samples-regressors), 'DisplayName','Day 2 - 26-03-2018', 'LineWidth',2)
plot(ax,Regression_Dataset_full_days.AAC24_k(2*day_block_samples-regressors+1:3*day_block_samples-regressors), 'DisplayName','Day 3 - 28-03-2018', 'LineWidth',2)
plot(ax,Regression_Dataset_full_days.AAC24_k(3*day_block_samples-regressors+1:4*day_block_samples-regressors), 'DisplayName','Day 4 - 10-05-2018', 'LineWidth',2)
plot(ax,Regression_Dataset_full_days.AAC24_k(4*day_block_samples-regressors+1:5*day_block_samples-regressors), 'DisplayName','Day 5 - 9-03-2018', 'LineWidth',2)
title(ax,'Zone-24 AAC')
xticks(ax,1:2:num_intervals);
xticklabels(ax,time((num_regressori / 2) + 1 : end, :));
ylabel(ax,"AAC(kWh)")
legend(ax)

tab = uitab(tabGroup, 'Title','Zone-56 AAC');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
day_block_samples=48;
regressors=3;
plot(ax,[zeros(regressors,1) ; Regression_Dataset_full_days.AAC56_k(1:day_block_samples-regressors)], 'DisplayName','Day 1 - 19-03-2018', 'LineWidth',2)
hold(ax), plot(ax,Regression_Dataset_full_days.AAC56_k(day_block_samples-regressors+1:2*day_block_samples-regressors), 'DisplayName','Day 2 - 26-03-2018', 'LineWidth',2)
plot(ax,Regression_Dataset_full_days.AAC56_k(2*day_block_samples-regressors+1:3*day_block_samples-regressors), 'DisplayName','Day 3 - 28-03-2018', 'LineWidth',2)
plot(ax,Regression_Dataset_full_days.AAC56_k(3*day_block_samples-regressors+1:4*day_block_samples-regressors), 'DisplayName','Day 4 - 10-05-2018', 'LineWidth',2)
plot(ax,Regression_Dataset_full_days.AAC56_k(4*day_block_samples-regressors+1:5*day_block_samples-regressors), 'DisplayName','Day 5 - 9-03-2018', 'LineWidth',2)
title(ax,'Zone-56 AAC')
ylabel(ax,"AAC(kWh)")
xticks(ax,1:2:num_intervals);
xticklabels(ax,time((num_regressori / 2) + 1 : end, :));
legend(ax)
%% Traffic plots

tab = uitab(tabGroup, 'Title','Zone-56 Traffic Po IN');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
plot(ax,zona56_V1_PO_19_03_2018, 'DisplayName','Day 1 - 19-03-2018', 'LineWidth',2)
hold(ax), plot(ax,zona56_V1_PO_26_03_2018, 'DisplayName','Day 2 - 26-03-2018', 'LineWidth',2)
plot(ax,zona56_V1_PO_28_03_2018, 'DisplayName','Day 3 - 28-03-2018', 'LineWidth',2)
plot(ax,zona56_V1_PO_10_05_2018, 'DisplayName','Day 4 - 10-05-2018', 'LineWidth',2)
plot(ax,zona56_V1_PO_09_03_2018, 'DisplayName','Day 5 - 9-03-2018', 'LineWidth',2)
title(ax,'Zone-56 Traffic Po IN')
xticks(ax,1:2:num_intervals);
xticklabels(ax,time((num_regressori / 2) + 1 : end, :));
ylabel(ax,"Vehicles")
legend(ax)

tab = uitab(tabGroup, 'Title','Zone-24 Traffic Navigazione IN');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
plot(ax, zona24_V1_NAVIGAZIONE_IN1_19_03_2018, 'DisplayName','Day 1 - 19-03-2018', 'LineWidth',2)
hold(ax), plot(ax,zona24_V1_NAVIGAZIONE_IN1_26_03_2018, 'DisplayName','Day 2 - 26-03-2018', 'LineWidth',2)
plot(ax,zona24_V1_NAVIGAZIONE_IN1_28_03_2018, 'DisplayName','Day 3 - 28-03-2018', 'LineWidth',2)
plot(ax,zona24_V1_NAVIGAZIONE_IN1_10_05_2018, 'DisplayName','Day 4 - 10-05-2018', 'LineWidth',2)
plot(ax,zona24_V1_NAVIGAZIONE_IN1_09_03_2018, 'DisplayName','Day 5 - 9-03-2018', 'LineWidth',2)
title(ax,'Zone-24 Traffic Navigazione IN')
xticks(ax,1:2:num_intervals);
xticklabels(ax,time((num_regressori / 2) + 1 : end, :));
ylabel(ax,"Vehicles")
legend(ax)



%% Correlation Analysis
%CORRELATION ANALYSIS
tab = uitab(tabGroup, 'Title',"Zone 24"+" - Correlation Traffic");
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
crosscorr(ax,Regression_Dataset_full_days.AAC24_k, Regression_Dataset_full_days.Traffic_k_24,"NumLags",30); title(ax,"Crossocorrelation AAC - Traffic")
xlabel(ax,'Lags',FontWeight='bold'),ylabel(ax,'xcorr',FontWeight='bold')
tab = uitab(tabGroup, 'Title',"Zone 56"+" - Correlation Traffic");
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
crosscorr(ax,Regression_Dataset_full_days.AAC56_k, Regression_Dataset_full_days.Traffic_k_56,"NumLags",30); title(ax,"Crossocorrelation AAC - Traffic")
xlabel(ax,'Lags',FontWeight='bold'),ylabel(ax,'xcorr',FontWeight='bold')

tab = uitab(tabGroup, 'Title',"Zone 24"+" - Correlation Datetime");
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
crosscorr(ax,Regression_Dataset_full_days.AAC24_k, Regression_Dataset_full_days.Time,"NumLags",30); title(ax,"Crossocorrelation AAC - Datetime")
xlabel(ax,'Lags',FontWeight='bold'),ylabel(ax,'xcorr',FontWeight='bold')
tab = uitab(tabGroup, 'Title',"Zone 56"+" - Correlation Datetime");
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
crosscorr(ax,Regression_Dataset_full_days.AAC56_k, Regression_Dataset_full_days.Time,"NumLags",30); title(ax,"Crossocorrelation AAC - Datetime")
xlabel(ax,'Lags',FontWeight='bold'),ylabel(ax,'xcorr',FontWeight='bold')

end

