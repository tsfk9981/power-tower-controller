%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% TX(HANDLE, UNIT, CMD, VAL)
%
% takes:
%   HANDLE	is the serial-port ID from OPEN_CONTROLLER
%   UNIT    is the integer UNIT designator (0=master, 1,2,3...)
%   CMD     is a single-letter ASCII character
%   VAL     is an option 16-bit int value to pass
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tx(handle, unit, cmd, val)

    if exist('val','var')
        fwrite(handle,[int8(unit), int8(cmd),typecast(int16(val),'int8')],'int8');
    else
        fwrite(handle,[int8(unit), int8(cmd)],'int8');
    end
return