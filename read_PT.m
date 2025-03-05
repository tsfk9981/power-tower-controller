function [Time, Voltage] = read_controller_PT(Handle_arr, time_length)

FS_MODULE = 7812.5;

disp("started reading data")
points = round(time_length*FS_MODULE);

Voltage = zeros(points, length(Handle_arr));
Time = zeros(points, length(Handle_arr));
for device_num = 1: length(Handle_arr)
    handle = Handle_arr(device_num);
    values = zeros(points, 6);
    for i=1:points
        values(i,:) = fread(handle, 6, 'uint8');
    end

    t_init = values(1,2); % first inclement number of time
    t_base = 0;
    for i=2:points
        if(values(i,2)==0)
            t_base = t_base + 255;
        end
        t(i) = values(i,2) - t_init + t_base;
        l(i) = values(i,3) + values(i,4)*255;
        r(i) = values(i,5) + values(i,6)*255;
    end
    Voltage(:, device_num) = l - r;
    Time(:, device_num) = t/FS_MODULE;


end

disp("finished reading data")


end