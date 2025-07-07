function addPlotToDisplay(fig, x, y, tabName)
    % Recupera il gruppo di tab
    tabGroup = findobj(fig, 'Tag', 'tabGroup');
    
    % Crea un nuovo tab
    t = uitab(tabGroup, 'Title', tabName);

    % Aggiungi assi nel tab
    ax = uiaxes(t, 'Position', [10 10 t.Position(3)-20 t.Position(4)-20]);
    plot(ax, x, y, 'LineWidth', 1.5);
    title(ax, tabName);
    xlabel(ax, 'Time');
    ylabel(ax, 'Y');
    grid(ax, 'on');
end