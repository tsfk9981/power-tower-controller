%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CLOSE_CONTROLLER(HANDLE)
%
% takes: 
%   HANDLE is the serial-port ID from OPEN_CONTROLLER.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function stop_controller_PT(Handle_arr)

unit = 0;

for i = 1: length(Handle_arr)
    handle = Handle_arr(i);

    % pause data streaming
    tx(handle, unit, 'P');

    % Turn off h-bridge
    tx(handle, unit, 'S', 0);

    % Turn off output control
    tx(handle, unit, 'X');


end