function T_out = delayTableColumns(T_in, inDelays, array_out, outColName, outDelays, n_k_in_out_delay, in_columns_no_regressor)
    % Delays specified columns of a table, starting from n_k_in_out_delay,
    % while including certain columns without delays.
    %
    % T_in: Input table with columns to delay
    % inDelays: Number of delays to apply to T_in columns (after n_k_in_out_delay)
    % array_out: External column (array) to delay and add to the table
    % outColName: Name of the external column
    % outDelays: Number of delays to apply to the external column
    % n_k_in_out_delay: Starting delay for T_in columns
    % in_columns_no_regressor: Names of columns in T_in to include with no delays

    % Initialize the output table
    T_out = T_in(:, in_columns_no_regressor); % Include columns with no delay

    % Validate the columns to delay
    columns_to_delay = setdiff(T_in.Properties.VariableNames, in_columns_no_regressor);

    % Delay columns in T_in
    for colIdx = 1:numel(columns_to_delay)
        colName = columns_to_delay{colIdx};
        colData = T_in.(colName);

        % Apply delays starting from n_k_in_out_delay
        for delay = n_k_in_out_delay:(n_k_in_out_delay + inDelays - 1)
            delayedColName = sprintf('%s_%d', colName, delay); % Dynamic naming
            delayedCol = [zeros(delay, 1); colData(1:end-delay)]; % Create delay
            T_out.(delayedColName) = delayedCol; % Add delayed column
        end
    end

    % Add and delay the external column (array_out) if provided
    if nargin >= 3 && ~isempty(array_out) && ~isempty(outColName) && outDelays > 0
        % Ensure the external column has the correct length
        if length(array_out) ~= height(T_in)
            error('The external column must have the same number of rows as the table.');
        end

        % Apply delays for the external column
        for delay = 1:outDelays
            delayedExternalColName = sprintf('%s_%d', outColName, delay); % Dynamic naming
            delayedExternalCol = [zeros(delay, 1); array_out(1:end-delay)]; % Create delay
            T_out.(delayedExternalColName) = delayedExternalCol; % Add to the table
        end
    end
    % max_delay = max(n_k_in_out_delay + inDelays - 1, outDelays);
    % % Remove rows affected by padding (first max_delay rows)
    % if max_delay > 0
    %     T_out = T_out((max_delay + 1):end, :); % Retain rows starting after padding
    % end
end