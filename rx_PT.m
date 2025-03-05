%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DATA = RX(HANDLE, CMD, BYTES)
%
% takes:
%   HANDLE	is the serial-port ID from OPEN_CONTROLLER
%   UNIT    is the integer UNIT designator (0=master, 1,2,3...)
%   CMD     is a single-letter ASCII character
%   SIZE    is the number of 16-bit values to be read
%
% returns:
%   DATA    is an N-element 16-bit array 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = rx(handle, unit, cmd, size)
    fwrite(handle, [int8(unit), int8(cmd)]);
    data = fread(handle, size, 'int16');
return