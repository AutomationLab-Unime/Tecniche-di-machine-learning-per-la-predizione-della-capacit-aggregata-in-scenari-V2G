root=pwd+"\Data\Rome\Codice_Data_Raw\Other Rome zones_invio\";



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



figure('Position', screenSize);
gx = geoaxes;
% Set the desired base map
%gx.Basemap = 'satellite'; % Options include 'satellite', 'topographic', 'streets', etc.
%gx.Basemap='street';
gx.Basemap='topographic';
for i=1:size(zoneFolderFileName,2)
    ZoneLabel = strrep(zoneFolderFileName{i},'_',' ');
    shapefilePath = root+zoneFolderFileName{i}+'\shapefile\'+zoneFolderFileName{i}+'.shp';
    shapeData = shaperead(shapefilePath);

    hold on
    y=[];
    x=[];
    % Extract Latitude and Longitude from the shapefile data
    for i = 1:length(shapeData)
        lat = shapeData(i).Y;
        y=[y lat];
        lon = shapeData(i).X;
        x=[x lon];
        geoplot(gx, lat, lon, 'LineWidth', 3, DisplayName=ZoneLabel); % Customize as needed
    end
    % Find the midpoint of the line (ignoring NaN breaks in the shapefile)
    
    x_mid = mean(x);
    y_mid = mean(y);
    
    % Add a label at the midpoint
    text(x_mid, y_mid, ZoneLabel, 'FontSize', 12, 'HorizontalAlignment', 'center');

end
h = legend('Location','northeast');


% Optional: Add a title
title(gx, 'Rome V2G Zones');