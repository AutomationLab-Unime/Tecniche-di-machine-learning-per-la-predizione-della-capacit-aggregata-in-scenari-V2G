function Padua_visualize_stop_maps(fig)
    filePath = fullfile(pwd, 'Data', 'Padua', '\Dati per sim modelli', 'Tabelle dati Padova', '\Map_figure_opt1.fig');
    uiopen(filePath, 1);
    gx=gca;
    gx.Basemap=fig.UserData.Basemap;
end