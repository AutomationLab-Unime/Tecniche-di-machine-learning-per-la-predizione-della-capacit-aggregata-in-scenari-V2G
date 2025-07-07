function Padua_visualize_stop_maps(fig)
    filePath1 = fullfile(pwd, 'Data', 'VED', '\RawData', '\stop_0_6_am_topographic_big.fig');
    uiopen(filePath1, 1);
    gx=gca;
    gx.Basemap=fig.UserData.Basemap;

    filePath2 = fullfile(pwd, 'Data', 'VED', '\RawData', '\stop_6_12_am_topographic_big.fig');
    uiopen(filePath2, 1);
    gx=gca;
    gx.Basemap=fig.UserData.Basemap;

    filePath3 = fullfile(pwd, 'Data', 'VED', '\RawData', '\stop_12_6_pm_topographic_big.fig');
    uiopen(filePath3, 1);
    gx=gca;
    gx.Basemap=fig.UserData.Basemap;

    filePath4 = fullfile(pwd, 'Data', 'VED', '\RawData', '\stop_6_12_pm_topographic_big.fig');
    uiopen(filePath4, 1);
    gx=gca;
    gx.Basemap=fig.UserData.Basemap;
end