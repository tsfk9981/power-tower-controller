%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CLOSE_CONTROLLER(HANDLE)
%
% takes: 
%   HANDLE is the serial-port ID from OPEN_CONTROLLER.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function stop_controller_v2(handle_array)
handle_1 = handle_array(1);
handle_2 = handle_array(2);

tx(handle_1,'P'); % pause data streaming
tx(handle_2,'P'); % pause data streaming
% tx(h,'S',0); % <- no need???
tx(handle_1,'X');
tx(handle_2,'X');

end