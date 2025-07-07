function [] = Rome_Generate_AAC_meteo_calendar_fnc(fig)
%PARAMETERS
% continuous_discrete_weekday
% 1 continuous
% 2 discrete
continuous_discrete_weekday=1;
step_ahead=1;

%root="C:\Users\franc\OneDrive - unime.it\General\02_2024_CNR_V2G\V2G_Unime_GUI\";

%% Hub EUR
%meteo_data_filename="EUR_meteo_data.mat"
%load(rowdata_folder+"\Dati Estratti\Zone214_new.mat");
load(fig.UserData.rowdata_filepath);
%%-----
%'conditions','station','name' CATEGORIGAL - TO BE REMOVED
% DEW NON SIGNIFICATIVO
% FEELSLIKE ALTAMENTE CORRELATO CON TEMP
% HUMIDITY ALTAMENTE CORRELATO IN CONTROFASE CON TEMP
% preciprob ALTAMENTE CORRELATO CON PRECIP
%'sealevelpressure','visibility' POCA VARIABILITà PER ROMA, MAGARI
%VISIBILITY IN ALTRE ZONE LO SAREBBE
columns_to_delete={'conditions','stations','name','dew','feelslike','humidity','precipprob','sealevelpressure','visibility'};
in_columns_no_regressor={'datetime','cloudcover'};
% Define the window size for the moving average
% Fill NaN values with moving average for all columns, cloudcover unico con
% Nan, risolto usando conditions clear->couldcover zero, e il resto con
% moving average per togliere rumore
window_size = 3;

%save_file=false;

test_perc=0.15;
delay_output=24;
delay_inputs=24;
delay_inputs_output=1;
%step_ahead=1;
[pathstr,name,ext] = fileparts(fig.UserData.rowdata_filepath);
zone_file_name=name+"_"+string(delay_inputs)+"_"+string(delay_output)+"_"+string(delay_inputs_output);
modelInputFolder = strrep(pathstr, "RawData", "ModelInputData");
%%Create Holidays and Weekend data from the meteo data datetime
%% Create Week Day Vector
% Create a datetime vector for the entire year 2023 with a half-hour step
meteo_year_hh=load(fig.UserData.meteo_data_filepath);
datetime_vector=meteo_year_hh.EUR_meteo_year_hh.datetime;
%datetime_vector = datetime(2023, 1, 1, 0, 0, 0):minutes(30):datetime(2023, 12, 31, 23, 30, 0);

% Calculate the continuous weekday index
% Day of the week (Monday = 1, Sunday = 7)
weekday_indices = weekday(datetime_vector, 'long')-1; % Monday = 0, ..., Sunday = 6

% Add fractional part based on the time of day
hours_fraction = hour(datetime_vector) + minute(datetime_vector)/60; % Hours as decimal
continuous_weekday_index = weekday_indices + hours_fraction / 24; % Add time as a fraction of a day

% Display an example slice of the result
% tabGroup = findobj(fig, 'Tag', 'tabGroup');
% % Crea un nuovo tab
% tab = uitab(tabGroup, 'Title','Continuous Weekday Index');
% ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
% plot(ax,datetime_vector,continuous_weekday_index)
% xticks(ax,datetime_vector(1:48:end));  % Set ticks at the exact datetime points
% xticklabels(ax,cellstr(datetime_vector(1:48:end), 'eeee, dd-MMM-yyyy')); % Format with weekday and date
% xlabel(ax,"Datetime")
% ylabel(ax,"ContinuousWeekdayIndex")


dateStart=datetime(2023,1,1,"Format","dd-MMM-uuuu");
dateEnd=datetime(2023,12,31,"Format","dd-MMM-uuuu");
% dateStart=date_vector(1);
% dateEnd=date_vector(end);

year_days=dateStart:caldays(1):dateEnd;
year_days_datenum=datenum(year_days);
% year_days = dateshift(date_vector, 'start', 'day');
% year_days = unique(year_days);
% year_days=datenum(date_vector);
inputs(:,2)=datenum(datetime_vector);
if continuous_discrete_weekday==1
    %use a continuous weekday index from 
    % 0: 0:00 monday
    % 8: 24:00 sunday
    shiftedWeekdays=continuous_weekday_index;
else % continuous_discrete_weekday==2
    %or use a discrete weekday index from
    % 1: monday
    % 7: sunday
    shiftedWeekdays=weekday(date_vector,1);
end

inputs(:,1)=shiftedWeekdays;


fis = mamfis("Name","Holiday Rate");
fis = addInput(fis,[min(shiftedWeekdays) max(shiftedWeekdays)],"Name","weekday"); %1: mon, 2: tue, 3: wed, 4: thur, 5. fri, 6: sat, 7: sund
%fis = addInput(fis,[1 7],"Name","weekday"); %1: mon, 2: tue, 3: wed, 4: thur, 5. fri, 6: sat, 7: sund
fis = addInput(fis,[year_days_datenum(1) year_days_datenum(end)],"Name","year_day");

%fis = addMF(fis,"weekday","sigmf",[-2 5],"Name","wd: working day");
fis = addMF(fis,"weekday","trapmf",[4.5, 5, 7, 8],"Name","wd: weekend");
weekend_mf = fismf("trapmf",[4.5, 5, 7, 7.3]);

%3 Easter Monday(
fis = addMF(fis,"year_day","gbellmf",[1 4 datenum(datetime(2023,4,10))],"Name","Easter Monday");
EasterMonday_mf = fismf("gbellmf",[1 4 datenum(datetime(2023,4,10))]);
%4 Liberation Day(
fis = addMF(fis,"year_day","trapmf",[datenum(datetime(2023,4,25)) datenum(datetime(2023,4,26)) datenum(datetime(2023,4,26)) datenum(datetime(2023,4,27))],"Name","Liberation Day");
Liberation_mf = fismf("trapmf",[datenum(datetime(2023,4,25)) datenum(datetime(2023,4,26)) datenum(datetime(2023,4,26)) datenum(datetime(2023,4,27))]);
%6 LAbour Daydatenum(
fis = addMF(fis,"year_day","trapmf",[datenum(datetime(2023,5,25)) datenum(datetime(2023,5,27)) datenum(datetime(2023,5,28)) datenum(datetime(2023,5,29))],"Name","Labour Day");
Labour_mf = fismf("trapmf",[datenum(datetime(2023,5,25)) datenum(datetime(2023,5,27)) datenum(datetime(2023,5,28)) datenum(datetime(2023,5,29))]);
%8 Republic Day
fis = addMF(fis,"year_day","gbellmf",[1 4 datenum(datetime(2023,6,2))],"Name","Republic Day");
Republic_mf = fismf("gbellmf",[1 4 datenum(datetime(2023,6,2))]);
%9 Assumption Day
fis = addMF(fis,"year_day","gbellmf",[1 4 datenum(datetime(2023,8,15))],"Name","Assumption Day");
Assumption_mf = fismf("gbellmf",[1 4 datenum(datetime(2023,8,15))]);
%7 All Saint(
fis = addMF(fis,"year_day","gbellmf",[1 4 datenum(datetime(2023,9,1))],"Name","All Saints' Day");
AllSaints_mf = fismf("gbellmf",[1 4 datenum(datetime(2023,9,1))]);
%1 Immaculate Conception
fis = addMF(fis,"year_day","trapmf",[datenum(datetime(2023,12,7)) datenum(datetime(2023,12,8)) datenum(datetime(2023,12,9)) datenum(datetime(2023,12,10))],"Name","Immaculate Conception");
Immaculate_mf = fismf("trapmf",[datenum(datetime(2023,12,7)) datenum(datetime(2023,12,8)) datenum(datetime(2023,12,9)) datenum(datetime(2023,12,10))]);
%2 Christmas-New Yeardatenum(
fis = addMF(fis,"year_day","trapmf",[datenum(datetime(2023,12,21)) datenum(datetime(2023,12,23)) datenum(datetime(2023,1,1)) datenum(datetime(2023,1,7))],"Name","Christmas-New Year");
Christ_NY_mf = fismf("trapmf",[datenum(datetime(2023,12,21)) datenum(datetime(2023,12,23)) datenum(datetime(2024,1,1)) datenum(datetime(2024,1,7))]);
Christ_NY_mf1 = fismf("trapmf",[datenum(datetime(2022,12,21)) datenum(datetime(2022,12,23)) datenum(datetime(2023,1,1)) datenum(datetime(2023,1,7))]);




weekend_mf_value = evalmf(weekend_mf,inputs(:,1));
Immaculate_mf_value=evalmf(Immaculate_mf,(inputs(:,2)));
Christ_NY_mf_value=evalmf(Christ_NY_mf,(inputs(:,2)));
Christ_NY_mf1_value=evalmf(Christ_NY_mf1,(inputs(:,2)));
EasterMonday_mf_value=evalmf(EasterMonday_mf,(inputs(:,2)));
Liberation_mf_value=evalmf(Liberation_mf,(inputs(:,2)));
Labour_mf_value=evalmf(Labour_mf,(inputs(:,2)));
AllSaints_mf_value=evalmf(AllSaints_mf,(inputs(:,2)));
Republic_mf_value=evalmf(Republic_mf,(inputs(:,2)));
Assumption_mf_value=evalmf(Assumption_mf,(inputs(:,2)));

mfs_values=[weekend_mf_value Immaculate_mf_value Christ_NY_mf_value Christ_NY_mf1_value EasterMonday_mf_value Liberation_mf_value Labour_mf_value Republic_mf_value Assumption_mf_value AllSaints_mf_value];
holiday_smooth_rate=max(mfs_values');
t = datetime(inputs(:,2),'ConvertFrom','datenum');
% Display an example slice of the result
tabGroup = findobj(fig, 'Tag', 'tabGroup');
% Crea un nuovo tab
% tab = uitab(tabGroup, 'Title','Holiday Smooth Rate');
% ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
% plot(ax,holiday_smooth_rate);
% xticks(ax,(1:48:length(inputs)))
% xticklabels(ax,string(t(1:48:end)))

%Plot Membership Functions
% Define a range of dates for evaluation
date_range = datetime(2023, 1, 1):datetime(2023, 12, 31); % Full year 2023
date_range_num = datenum(date_range);  % Convert to datenum for evaluation

% Membership functions and their names
membership_functions = {
    EasterMonday_mf, 'Easter Monday';
    Liberation_mf, 'Liberation Day';
    Labour_mf, 'Labour Day';
    Republic_mf, 'Republic Day';
    Assumption_mf, 'Assumption Day';
    AllSaints_mf, 'All Saints'' Day';
    Immaculate_mf, 'Immaculate Conception';
    Christ_NY_mf, 'Christmas-New Year';
    Christ_NY_mf1, 'Christmas-New Year'
};

% Define custom distinguishable colors
colors = [
    0.9, 0.1, 0.1;   % Red
    0.1, 0.7, 0.2;   % Green
    0.1, 0.2, 0.8;   % Blue
    0.8, 0.7, 0.1;   % Yellow
    0.6, 0.1, 0.7;   % Purple
    0.1, 0.7, 0.7;   % Cyan
    0.9, 0.5, 0.1;   % Orange
    0.5, 0.5, 0.5;    % Gray
    0.5, 0.5, 0.5    % Gray Chrismas è a cavallo tra due anni, quindi ne ho dovuto fare 2
];

% Create a figure
tab = uitab(tabGroup, 'Title','Membership Function - National Holidays');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
hold(ax)

% Loop through membership functions to evaluate and plot
for i = 1:size(membership_functions, 1)
    mf = membership_functions{i, 1};  % Membership function object
    name = membership_functions{i, 2}; % Name of the membership function
    
    % Evaluate the membership function over the date range
    y = getMembershipValue(mf, date_range_num);
    
    % Plot the membership function
    if i<size(membership_functions, 1) 
        plot(ax,date_range, y, 'LineWidth', 2, 'Color', colors(i, :), 'DisplayName', name);
    else %% the last mf does not have label becaus is the double Christmas
        plot(ax,date_range, y, 'LineWidth', 2, 'Color', colors(i, :), 'DisplayName', name, 'HandleVisibility', 'off');
    end
end

% Customize the plot
title(ax,'Membership Functions for Holidays');
xlabel(ax,'Date');
ylabel(ax,'Membership Degree');
legend(ax,'show', 'Location', 'best');
% hold(ax),grid on;
% hold(ax),hold off;


%PLOT WEEKEND MF
% Weekday names for the x-axis
weekday_names = {'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday', 'Monday'};
weekdays = linspace(1, 8, 1000);  % Monday = 1, Sunday = 7, fine-grained values
weekend_mf = trapmf(weekdays, [5.5, 6, 8, 8.1]);  % Friday 12:00 (4.5), Monday 8:00 (8.0)
% Plot the membership function
tab = uitab(tabGroup, 'Title','Membership Function - Weekends');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
plot(ax,weekdays, weekend_mf, 'LineWidth', 2, 'Color', [0.2, 0.7, 0.9]);

% Customize the plot
xticks(ax,1:1:8);  % Tick positions for each day
xticklabels(ax,weekday_names);  % Set weekday names
xlabel(ax,'Weekday');
ylabel(ax,'Membership Degree');
title(ax,'Weekend Membership Function');
%hold(ax),grid on;
ylim(ax,[0, 1.1]);  % Set limits for better visibility


%Data Meteo + Holiday rate
meteo_year_hh.EUR_meteo_year_hh.holiday_index= holiday_smooth_rate';
meteo_holiday_hh=meteo_year_hh;
if fig.UserData.save_file==true
    save(fullfile(modelInputFolder, zone_file_name +"_AAC_meteo_holiday.mat"),"meteo_holiday_hh")
end
tab = uitab(tabGroup, 'Title',fig.UserData.ZoneName+' - Time-Series - AAC - Exogenous Inputs');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
plot(ax,meteo_holiday_hh.EUR_meteo_year_hh.datetime,AAC_energy{:,1}, "DisplayName","AAC(kWh)", LineWidth=2)
ylabel(ax,'AAC(kWh)',FontSize=12,FontWeight='bold') %BUG +caldays(1)
hold(ax), yyaxis(ax,'right'),  plot(ax,meteo_holiday_hh.EUR_meteo_year_hh.datetime+caldays(1),meteo_holiday_hh.EUR_meteo_year_hh.holiday_index, "DisplayName", "Holiday Index", LineWidth=2)
yyaxis(ax,'right'), plot(ax,meteo_holiday_hh.EUR_meteo_year_hh.datetime,normalize(meteo_holiday_hh.EUR_meteo_year_hh.precip,"zscore"),"DisplayName", "Precipitation (ZScore)", LineWidth=2, Color="g");
yyaxis(ax,'right'), plot(ax,meteo_holiday_hh.EUR_meteo_year_hh.datetime,normalize(meteo_holiday_hh.EUR_meteo_year_hh.temp,"zscore"),"DisplayName", "Temperature (ZScore)", LineWidth=2, Color="c");
yyaxis(ax,'right'), plot(ax,meteo_holiday_hh.EUR_meteo_year_hh.datetime,normalize(meteo_holiday_hh.EUR_meteo_year_hh.windspeed,"zscore"),"DisplayName", "Windspeed (ZScore)", LineWidth=2, Color="m");
legend(ax),


inputs_sys_ident=meteo_holiday_hh.EUR_meteo_year_hh;


%remove categorical column and fill missing


%% replace with zeros the column Nan with conditions='Clear', the rest replaced with filter moving average
rows_to_replace = isnan(inputs_sys_ident.cloudcover) & inputs_sys_ident.conditions == 'Clear';
inputs_sys_ident.cloudcover(rows_to_replace) = 0;
inputs_sys_ident.datetime=datenum(meteo_holiday_hh.EUR_meteo_year_hh.datetime);

%%remove the categorical column and the one not selected for "feature
%%selection" criteria, correlation, variability
inputs_sys_ident(:, columns_to_delete) = [];
% inputs_sys_ident.conditions=[];
% inputs_sys_ident.stations=[];
% inputs_sys_ident.name=[];

var_names=inputs_sys_ident.Properties.VariableNames;
inputs_sys_ident = varfun(@(col) fillmissing(col, 'movmean', window_size), ...
                          inputs_sys_ident);
inputs_sys_ident.Properties.VariableNames = var_names;
%% in caso di step ahead devo accorciare gli ingressi di 
inputs_sys_ident=inputs_sys_ident;


zone_struct = struct();
zone_struct.mean_inputs=mean(table2array(inputs_sys_ident));
zone_struct.std_inputs=std(table2array(inputs_sys_ident));
zone_struct.mean_out=mean(AAC_energy{:,1});
zone_struct.std_out=std(AAC_energy{:,1});
zone_struct.input_sys_ident_table=inputs_sys_ident;
zone_struct.input_sys_ident_array=table2array(inputs_sys_ident);
zone_struct.output_sys_ident=AAC_energy{:,1};


% Normalize all columns using zscore
var_names=inputs_sys_ident.Properties.VariableNames;
inputs_sys_ident_norm = varfun(@zscore, inputs_sys_ident, 'OutputFormat', 'table');
% Ensure the normalized columns retain their original names
inputs_sys_ident_norm.Properties.VariableNames = var_names;
zone_struct.input_sys_ident_table_norm=inputs_sys_ident_norm;
zone_struct.input_sys_ident_array_norm=table2array(inputs_sys_ident_norm);
zone_struct.output_sys_ident_norm=normalize(AAC_energy{:,1},"zscore");

%TEST VALIDATION TRAIN
%%DIVIDE TEST - TRAINVAL
% Define the intervals as datetime limits
T_in=zone_struct.input_sys_ident_table;
T_out=zone_struct.output_sys_ident;

start_dates = [
    datetime(2023, 2, 20, 0, 0, 0), ...
    datetime(2023, 5, 31, 0, 0, 0), ...
    datetime(2023, 7, 12, 0, 0, 0), ...
    datetime(2023, 9, 27, 0, 0, 0)];
end_dates = [
    datetime(2023, 2, 28, 23, 59, 59), ...
    datetime(2023, 6, 15, 23, 59, 59), ...
    datetime(2023, 7, 25, 23, 59, 59), ...
    datetime(2023, 10, 10, 23, 59, 59)];

% Step size in minutes
step_minutes = 30;

% % Generate the intervals and convert them to numeric (Unix timestamp)
% all_intervals_num = [];
% for i = 1:length(start_dates)
%     current_interval = start_dates(i):minutes(step_minutes):end_dates(i);
%     all_intervals_num = [all_intervals_num; posixtime(current_interval)]; % Append numeric intervals
% end


% Filter rows of the table based on the intervals
selected_rows = [];
test_rows=[];
trainval_rows=[];
test_indices=[];
trainval_indices=[];
for i = 1:length(start_dates)
    start_num = datenum(start_dates(i)); % Start of the interval
    end_num = datenum(end_dates(i)); % End of the interval
    
    % Find rows that fall in the current interval
    rows_in_interval = T_in(T_in.datetime >= start_num & T_in.datetime <= end_num, :);
    % Logical array indicating rows within the interval
    log_in_interval = (T_in.datetime >= start_num & T_in.datetime <= end_num);

    % Find indices of rows within the interval
    indices_in_interval = find(log_in_interval);
    
    trainval_limit=floor((1-test_perc)*size(rows_in_interval,1));
    trainval_rows_interval=rows_in_interval(1:trainval_limit,:);
    test_rows_interval=rows_in_interval(trainval_limit+1:end,:);
    trainval_indices_interval=indices_in_interval(1:trainval_limit);
    test_indices_interval=indices_in_interval(trainval_limit+1:end);
    selected_rows = [selected_rows; rows_in_interval]; % Append to selected rows
    test_rows = [test_rows; test_rows_interval]; 
    trainval_rows = [trainval_rows; trainval_rows_interval];
    test_indices=[test_indices; test_indices_interval];
    trainval_indices=[trainval_indices; trainval_indices_interval];
end
zone_struct.input_sys_ident_table_test=test_rows;
zone_struct.input_sys_ident_table_trainval=trainval_rows;
zone_struct.input_sys_ident_array_test=table2array(test_rows);
zone_struct.input_sys_ident_array_trainval=table2array(trainval_rows);
zone_struct.output_sys_ident_test=zone_struct.output_sys_ident(test_indices);
zone_struct.output_sys_ident_trainval=zone_struct.output_sys_ident(trainval_indices);

% figure, plot(trainval_rows.datetime,trainval_rows.temp)
% hold on, plot(test_rows.datetime,test_rows.temp), 
% hold on, plot(selected_rows.datetime,selected_rows.temp)
% hold on, plot(trainval_rows.datetime,zone_struct.output_sys_ident_trainval)
% hold on, plot(test_rows.datetime,zone_struct.output_sys_ident_test), 
% %hold on, plot(selected_rows.datetime,zone_struct.output_sys_ident)

zone_struct.input_sys_ident_table_norm_test=zone_struct.input_sys_ident_table_norm(test_indices,:);
zone_struct.input_sys_ident_table_norm_trainval=zone_struct.input_sys_ident_table_norm(trainval_indices,:);
zone_struct.input_sys_ident_array_norm_test=table2array(zone_struct.input_sys_ident_table_norm(test_indices,:));
zone_struct.input_sys_ident_array_norm_trainval=table2array(zone_struct.input_sys_ident_table_norm(trainval_indices,:));
zone_struct.output_sys_ident_norm_test=zone_struct.output_sys_ident_norm(test_indices);
zone_struct.output_sys_ident_norm_trainval=zone_struct.output_sys_ident_norm(trainval_indices);

% figure, plot(zone_struct.input_sys_ident_table_norm_trainval.datetime,zone_struct.input_sys_ident_table_norm_trainval.temp)
% hold on, plot(zone_struct.input_sys_ident_table_norm_test.datetime,zone_struct.input_sys_ident_table_norm_test.temp) 
% hold on, plot(zone_struct.input_sys_ident_table_norm.datetime,zone_struct.input_sys_ident_table_norm.temp)
% hold on, plot(zone_struct.input_sys_ident_table_norm_trainval.datetime,zone_struct.output_sys_ident_norm_trainval)
% hold on, plot(zone_struct.input_sys_ident_table_norm_test.datetime,zone_struct.output_sys_ident_norm_test), 
% %hold on, plot(zone_struct.input_sys_ident_table_norm.datetime,zone_struct.output_sys_ident_norm)

%REGRESSORS

% Iterate over all elements
for i = 1:numel(delay_output)
    % Extract current values
    current_delay_output = delay_output(i);
    current_delay_inputs = delay_inputs(i);
    current_delay_inputs_output = delay_inputs_output(i);
    
    % Generate the column name dynamically
    column_name = 'Regressors';
    column_name_norm=column_name+"_norm";
    
    % Apply the delayTableColumns function
    regressors = delayTableColumns(zone_struct.input_sys_ident_table, ...
                                   current_delay_inputs, ...
                                   zone_struct.output_sys_ident, ...
                                   "AAC", ...
                                   current_delay_output, ...
                                   current_delay_inputs_output,...
                                   in_columns_no_regressor);
    
    % Store the result in the structure dynamically
    zone_struct.(column_name) = regressors;

    test_indices = find(ismember(regressors.datetime, zone_struct.input_sys_ident_table_test.datetime));
    trainval_indices = find(ismember(regressors.datetime, zone_struct.input_sys_ident_table_trainval.datetime));
    zone_struct.(column_name+"_test")=regressors(test_indices,:);
    zone_struct.(column_name+"_trainval")=regressors(trainval_indices,:);

    % Apply the delayTableColumns function
    regressors_norm = delayTableColumns(zone_struct.input_sys_ident_table_norm, ...
                                   current_delay_inputs, ...
                                   zone_struct.output_sys_ident, ...
                                   "AAC", ...
                                   current_delay_output, ...
                                   current_delay_inputs_output,...
                                   in_columns_no_regressor);
    
    % Store the result in the structure dynamically
    zone_struct.(column_name_norm) = regressors_norm;

    zone_struct.(column_name_norm+"_test")=regressors_norm(test_indices,:);
    zone_struct.(column_name_norm+"_trainval")=regressors_norm(trainval_indices,:);

end






%%
SI_OUT=zone_struct.output_sys_ident(step_ahead:end);
SI_IN=zone_struct.input_sys_ident_array(1:end-step_ahead+1,:);
SI_IN_TRAIN=zone_struct.input_sys_ident_array_trainval(1:end-step_ahead+1,:); 
SI_IN_TEST=zone_struct.input_sys_ident_array_test(1:end-step_ahead+1,:);
SI_OUT_TRAIN=zone_struct.output_sys_ident_trainval(step_ahead:end);
SI_OUT_TEST=zone_struct.output_sys_ident_test(step_ahead:end);
SI_IN_TABLE=zone_struct.input_sys_ident_table(1:end-step_ahead+1,:);
variable_name=SI_IN_TABLE.Properties.VariableNames;
SI_OUT_NORM=zone_struct.output_sys_ident_norm(step_ahead:end);
SI_IN_NORM=zone_struct.input_sys_ident_array_norm(1:end-step_ahead+1,:);
SI_IN_TRAIN_NORM=zone_struct.input_sys_ident_array_norm_trainval(1:end-step_ahead+1,:); 
SI_IN_TEST_NORM=zone_struct.input_sys_ident_array_norm_test(1:end-step_ahead+1,:);
SI_OUT_TRAIN_NORM=zone_struct.output_sys_ident_norm_trainval(step_ahead:end);
SI_OUT_TEST_NORM=zone_struct.output_sys_ident_norm_test(step_ahead:end);
SI_IN_TABLE_NORM=zone_struct.input_sys_ident_table_norm(1:end-step_ahead+1,:);

%REGRESSION LEARNER NON NORM
RL_IN_TRAIN=zone_struct.Regressors_trainval(1:end-step_ahead+1,:); 
RL_IN_TEST=zone_struct.Regressors_test(1:end-step_ahead+1,:);
RL_OUT_TRAIN=zone_struct.output_sys_ident_trainval(step_ahead:end);
RL_OUT_TEST=zone_struct.output_sys_ident_test(step_ahead:end);
RL_TRAIN=RL_IN_TRAIN;
RL_TRAIN.AAC=RL_OUT_TRAIN;
RL_TEST=RL_IN_TEST;
RL_TEST.AAC=RL_OUT_TEST;

%REGRESSION LEARNERE NORM FOR FEATURE SELECTION
RL_IN_TRAIN_NORM=zone_struct.Regressors_norm_trainval(1:end-step_ahead+1,:); 
RL_IN_TEST_NORM=zone_struct.Regressors_norm_test(1:end-step_ahead+1,:);
RL_OUT_TRAIN_NORM=zone_struct.output_sys_ident_norm_trainval(step_ahead:end);
RL_OUT_TEST_NORM=zone_struct.output_sys_ident_norm_test(step_ahead:end);
RL_TRAIN_NORM=RL_IN_TRAIN_NORM;
RL_TRAIN_NORM.AAC=RL_OUT_TRAIN_NORM;
RL_TEST_NORM=RL_IN_TEST_NORM;
RL_TEST_NORM.AAC=RL_OUT_TEST_NORM;

if fig.UserData.save_file==true

    save(fullfile(modelInputFolder, zone_file_name +"_demo.mat"), "zone_struct");
    fileOut = fullfile(modelInputFolder, zone_file_name + "RL_TRAIN.csv");
    writetable(RL_TRAIN, fileOut);
    fileOut = fullfile(modelInputFolder, zone_file_name + "RL_TEST.csv");
    writetable(RL_TEST, fileOut);
    fileOut = fullfile(modelInputFolder, zone_file_name + "RL_TRAIN_NORM.csv");
    writetable(RL_TRAIN_NORM, fileOut);
    fileOut = fullfile(modelInputFolder, zone_file_name + "RL_TEST_NORM.csv");
    writetable(RL_TEST_NORM, fileOut);    
end
%Correlation Study
corr_matrix_in=corr(SI_IN,SI_IN);
% figure, 
% subplot(1, 2, 1); % 1 row, 2 columns, 1st plot
% imagesc(corr_matrix_in),colormap turbo, caxis([-1, 1])
% variable_name=strrep(variable_name, '_', ' ');
% xticks(1:width(variable_name)); % Set x-tick positions (1 to the number of columns in T)
% xticklabels(variable_name); % Set x-tick labels to column names
% 
% % Add y-tick labels if needed (e.g., row labels)
% yticks(1:width(variable_name)); % Set x-tick positions (1 to the number of columns in T)
% yticklabels(variable_name); % Set x-tick labels to column names
% set(gca, 'FontSize', 13, 'FontWeight', 'bold');
% 
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
tab = uitab(tabGroup, 'Title',fig.UserData.ZoneName+' - Correlation Datetime');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
crosscorr(ax,SI_OUT, SI_IN_TABLE.datetime,"NumLags",30); title(ax,"Crossocorrelation AAC - Datetime")
xlabel(ax,'Lags',FontWeight='bold'),ylabel(ax,'xcorr',FontWeight='bold')
tab = uitab(tabGroup, 'Title',fig.UserData.ZoneName+' - Correlation Holidays');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
crosscorr(ax,SI_OUT, SI_IN_TABLE.holiday_index,"NumLags",30);title(ax,"Crossocorrelation AAC - Holiday Index")
xlabel(ax,'Lags',FontWeight='bold'),ylabel(ax,'xcorr',FontWeight='bold')
tab = uitab(tabGroup, 'Title',fig.UserData.ZoneName+' - Correlation Cloudcover');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
crosscorr(ax,SI_OUT, SI_IN_TABLE.cloudcover,"NumLags",30);title(ax,"Crossocorrelation AAC -Cloud Cover")
xlabel(ax,'Lags',FontWeight='bold'),ylabel(ax,'xcorr',FontWeight='bold')
tab = uitab(tabGroup, 'Title',fig.UserData.ZoneName+' - Correlation Precipitation');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
crosscorr(ax,SI_OUT, SI_IN_TABLE.precip,"NumLags",30);title(ax,"Crossocorrelation AAC - Precipitation")
xlabel(ax,'Lags',FontWeight='bold'),ylabel(ax,'xcorr',FontWeight='bold')
tab = uitab(tabGroup, 'Title',fig.UserData.ZoneName+' - Correlation Wind Direction');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
crosscorr(ax,SI_OUT, SI_IN_TABLE.winddir,"NumLags",30);title(ax,"Crossocorrelation AAC - Wind Direction")
xlabel(ax,'Lags',FontWeight='bold'),ylabel(ax,'xcorr',FontWeight='bold')
tab = uitab(tabGroup, 'Title',fig.UserData.ZoneName+' - Correlation Wind Direction');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
crosscorr(ax,SI_OUT, SI_IN_TABLE.windspeed,"NumLags",30);title(ax,"Crossocorrelation AAC - Wind Speed")
xlabel(ax,'Lags',FontWeight='bold'),ylabel(ax,'xcorr',FontWeight='bold')
tab = uitab(tabGroup, 'Title',fig.UserData.ZoneName+' - Correlation Temperature');
ax = uiaxes(tab, 'Position', [10 10 tab.Position(3)-20 tab.Position(4)-20]);
crosscorr(ax,SI_OUT, SI_IN_TABLE.temp,"NumLags",30);title(ax,"Crossocorrelation AAC - Temperature")
xlabel(ax,'Lags',FontWeight='bold'),ylabel(ax,'xcorr',FontWeight='bold')
end