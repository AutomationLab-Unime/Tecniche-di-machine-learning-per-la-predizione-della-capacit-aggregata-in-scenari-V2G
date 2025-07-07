function [] = Rome_visualize_stop_maps(fig)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
load(fig.UserData.rowdata_filepath);

shape_files_path=pwd+"\Data\Rome\Codice_Data_Raw\Other Rome zones_invio\";



zoneFolderFileName{1}="Zone_509_Ponte Mammolo";
zoneFolderFileName{2}="Zone_116_Trastevere";
zoneFolderFileName{3}="Zone_125_centroplus tiburtina";
zoneFolderFileName{4}="Zone_705_Prenestino-Centocelle";
zoneFolderFileName{5}="Zone_1201_Eur";
zoneFolderFileName{6}="Zone_906_Arco_Di_Travertino";
zoneFolderFileName{7}="Zone_1611_Cornelia_Aurelia";
zoneFolderFileName{8}="Zone_1016_Anagnina";
zoneFolderFileName{9}="Zone_214_Trieste";
zoneFolderFileName{10}="Zone_2004_Della Vittoria,Tomba di Nerone,Tor di Quinto2";
zoneFolderFileName{11}="Zone2002_Tor di Quinto6";
zoneFolderFileName{12}="Zone_RSM_v19_Cav_zoneUNITOV";

screenSize = get(0, 'ScreenSize')*0.9;
figure('Position', screenSize);
gx = geoaxes;
%gx.Position = [10, 10, tab.Position(3)-20, tab.Position(4)-20];
%gx.Basemap = 'topographic';  % Optional
drawnow;
% Set the desired base map
gx.Basemap = fig.UserData.Basemap; % Options include 'satellite', 'topographic', 'streets', etc.
%gx.Basemap='street';

for i=1:size(zoneFolderFileName,2)
    ZoneLabel = strrep(zoneFolderFileName{i},'_',' ');
    shapefilePath = shape_files_path+zoneFolderFileName{i}+'\shapefile\'+zoneFolderFileName{i}+'.shp';
    shapeData = shaperead(shapefilePath);

    hold(gx, 'on');
    y=[];
    x=[];
    % Extract Latitude and Longitude from the shapefile data
    for i = 1:length(shapeData)
        lat = shapeData(i).Y;
        y=[y lat];
        lon = shapeData(i).X;
        x=[x lon];
        geoplot(gx, lat, lon, 'LineWidth', 3, DisplayName=ZoneLabel); % Customize as needed
        drawnow;
    end
    % Find the midpoint of the line (ignoring NaN breaks in the shapefile)
    
    x_mid = mean(x);
    y_mid = mean(y);
    
    % Add a label at the midpoint
    text(x_mid, y_mid, ZoneLabel, 'FontSize', 12, 'HorizontalAlignment', 'center');

end
h = legend(gx,'Location','northeast');


% Optional: Add a title
title(gx, "Rome V2G Zones - "+fig.UserData.ZoneName);

%% PLot the zone maps
%is_target_zone = ismember(V2G_table_pre.Final_Zone_NO, hub_nodi);
has_valid_sosta_min = ~isnan(V2G_table_pre.stopping_time_check);

% Combina le condizioni usando AND logico
final_condition = has_valid_sosta_min;

% Filtra le righe che soddisfano la sosta in una zona e che quella sia una sosta V2G
V2G_table_soste = V2G_table_pre(final_condition, :);



%set(gcf, 'Position', get(0, 'Screensize'));
% Colori per le diverse zone
zone_colors = lines(1);

% Traccia punti per ciascuna zona


    %inserimento in un array delle soste nella zona data dall'indice i
    
    %is_target_zone = ismember(V2G_table_soste.Final_Zone_NO, hub_nodi(i));
    soste_zona = V2G_table_soste;

    %inserimento nella mappa
    geoscatter(gx, ...
    soste_zona.LatitudineFineViaggio, ...
    soste_zona.LongitudineFineViaggio, ...
    '*', ...
    'DisplayName', fig.UserData.ZoneName);    
    



% Traccia punti di hub e rilevatori
%geoscatter(hub_lat, hub_long, 100, '*', 'k', 'DisplayName', 'Hubs');
%geoscatter(lat_rilev, long_rilev, 1000, '.', 'r', 'DisplayName', 'Traffic Detector');

% Imposta il basemap e altre proprietà

legend(gx, 'show')


end