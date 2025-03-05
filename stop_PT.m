%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CLOSE_CONTROLLER(HANDLE)
%
% takes: 
%   HANDLE is the serial-port ID from OPEN_CONTROLLER.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function stop_PT(Handle_arr)

unit = 0;

for i = 1: length(Handle_arr)
    handle = Handle_arr(i);

    % pause data streaming
    tx_PT(handle, unit, 'P');

    % Turn off h-bridge
    tx_PT(handle, unit, 'S', 0); % actually changing into switch mode and both switch open

    % Turn off output control
    tx_PT(handle, unit, 'X');


end

disp("PT: finished data streaming")
disp("PT: HV OFF!!")