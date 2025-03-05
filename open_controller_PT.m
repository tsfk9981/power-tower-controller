function Handle_arr = open_controller_PT(Port_arr)

% Port_arr = ["COM16", "COM4"];
ADC_FILTER = 700;
DEAD_BAND = 0;
P_GAIN = 60; % 1/P_GAIN

unit = 0; % 0: direct communication to the unit without the SLID

% Handle_arr = nan(1, length(Port_arr));
for i = 1: length(Port_arr)
    port = Port_arr(i);

    % open device
    handle = serialport(port,9600);

    % Calibrate with no voltage
    tx(handle, unit, 'C')

    % Set ADC filtering
    tx(handle, unit, 'F', ADC_FILTER);

    % Set deadband
    tx(handle, unit, 'D', DEAD_BAND);

    % Set gain
    tx(handle, unit, 'G', P_GAIN);

    % Start close loop mode and set 0 volte
    tx(handle, unit, 'O', 0);

    Handle_arr(i) = handle;
end
end