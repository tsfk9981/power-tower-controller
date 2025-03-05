%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DATA = TXRX(HANDLE, TARGET)
%
% takes:
%   HANDLE	is the serial-port ID from OPEN_CONTROLLER
%   UNIT    is the integer UNIT designator (0=master, 1,2,3...)
%   CMD     is a single-letter ASCII character
%   SIZE    is the number of 16-bit values to be read
%   VAL     is an option 16-bit int value to pass
%
% returns:
%   DATA      is an N-element 16-bit int array
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = txrx(handle, unit, cmd, size, val)

    if exist('val','var')
        fwrite(handle,[int8(unit), int8(cmd),typecast(int16(val),'int8')],'int8');
    else
        fwrite(handle,[int8(unit), int8(cmd)],'int8');
    end
    data = fread(handle, size, 'int16');
return