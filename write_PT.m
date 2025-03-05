function write_PT(Handle_arr, output_vector, sample_rate)

unit = 0; % 0: direct communication to the unit without the SLID

for device_num = 1: length(Handle_arr)
    handle = Handle_arr(device_num);
    flush(handle); % flush remainning data from the previous session
end

period = 1/sample_rate;
t = 0;

disp("PT: started voltage control")

tic
% Execute timed operation on switch board
for sample_num = 1:length(output_vector(:, 1))
    for device_num = 1: length(Handle_arr)
        handle = Handle_arr(device_num);

        % Write sequentially
        tx_PT(handle, unit, 'O', output_vector(sample_num, device_num));
        
    end
    t = t + period;

    while(toc < t); end
end

disp("PT: finished voltage control")

end