function [Time, Voltage] = read_PT(Handle_arr, time_length)

FS_MODULE = 7812.5;

disp("PT: started reading data")
points = round(time_length*FS_MODULE);

Voltage = zeros(points, length(Handle_arr));
Time = zeros(points, length(Handle_arr));
for device_num = 1: length(Handle_arr)
    handle = Handle_arr(device_num);
    Raw = zeros(points, 6);
    for i=1:points
        Raw(i,:) = fread(handle, 6, 'uint8'); % read out raw values from the device
    end
    
    % streamed byte array
    % 1 byte: delimiter(always 0)
    % 1 byte: timestamp (inclements up to 255 at 7812.5Hz)
    % 2 byte: V.L (measured left pin voltage (Volts))
    % 2 byte: V.R (measured right pin voltage (Volts))

    t = zeros(points, 1);
    l = zeros(points, 1);
    r = zeros(points, 1);

    t_init = Raw(1,2); % first number of time incrementation
    t_base = 0;
    for i=2:points
        if(Raw(i,2)==0)
            t_base = t_base + 255; % convert 0-255 to 0-inf
        end
        t(i) = Raw(i,2) - t_init + t_base;
        l(i) = Raw(i,3) + Raw(i,4)*255;
        r(i) = Raw(i,5) + Raw(i,6)*255;
    end
    Voltage(:, device_num) = l - r;
    Time(:, device_num) = t/FS_MODULE;


end

disp("PT: finished reading data")


end