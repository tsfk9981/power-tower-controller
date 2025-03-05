function Handle_arr = open_PT(Port_arr, Option_arr, Parameter_arr)


unit = 0; % 0: direct communication to the unit without the SLID

% Handle_arr = nan(1, length(Port_arr));
for i = 1: length(Port_arr)
    port = Port_arr(i);

    % open device
    handle = serialport(port,9600);

    % Calibrate with no voltage
    tx_PT(handle, unit, 'C')
    
    if exist("Option_arr", "var")
        for j = 1: length(Option_arr)
            option_char = char(Option_arr(j));
            parameter_value = Parameter_arr(j);

            tx_PT(handle, unit, option_char, parameter_value);
        end
    end
    
    % Start close loop mode and set 0 volte
    tx_PT(handle, unit, 'O', 0);

    Handle_arr(i) = handle;
end

disp("PT: connected")
disp("PT: HV ON !!")
end