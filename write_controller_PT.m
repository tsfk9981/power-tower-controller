function write_controller_PT(Handle_arr, output_vector, sample_rate)

disp("started control")

unit = 0;

for device_num = 1: length(Handle_arr)
    handle = Handle_arr(device_num);
    flush(handle);
end

period = 1/sample_rate;
t = 0;

tic
% Execute timed operation on switch board
for sample_num = 1:length(output_vector(:, 1))
    for device_num = 1: length(Handle_arr)
        handle = Handle_arr(device_num);

        % Write sequentially
        tx(handle, unit, 'O', output_vector(sample_num, device_num));
        
    end
    t = t + period;

    while(toc < t); end
end

disp("finished control")

end