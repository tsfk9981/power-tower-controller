%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CLOSE_CONTROLLER(HANDLE)
%
% takes: 
%   HANDLE is the serial-port ID from OPEN_CONTROLLER.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function close_controller_v2(handle_array)
if verLessThan('matlab', '9.9')
    % Close serial communication for each element in handle_array
    for i = 1:length(handle_array)
        fclose(handle_array(i));  
    end
else
    for i = 1:length(handle_array)
    delete(handle_array(i));
    end 
end