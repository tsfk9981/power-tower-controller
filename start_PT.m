function start_PT(Handle_arr)

% Port_arr = ["COM16", "COM4"];
unit = 0; % 0: direct communication to the unit without the SLID

for i = 1: length(Handle_arr)
    handle = Handle_arr(i);

    % start data streaming
    tx_PT(handle, unit, 'V', 1);
end

disp("PT: started data streaming")
end