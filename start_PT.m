function start_controller_PT(Handle_arr)

% Port_arr = ["COM16", "COM4"];
unit = 0; % 0: direct communication to the unit without the SLID

% Handle_arr = nan(1, length(Port_arr));
for i = 1: length(Handle_arr)
    handle = Handle_arr(i);

    % start data streaming
    tx(handle, unit, 'V', 1);
end

disp("start to stream")
end