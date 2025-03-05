clear;
close all;

max_voltage = 3000;
FS = 500;

Ports = ["COM5"];

Input = build_signal(max_voltage, FS, length(Ports));

h = open_controller_PT(Ports); % ready to use, but not yet streaming data from the device
pause(1)


start_controller_PT(h) % start to stream data from the device


write_controller_PT(h, Input, FS);
stop_controller_PT(h);

[Time, Voltage_out] = read_controller_PT(h, length(Input)/FS);
close_controller_PT(h);


figure(100)
hold on
for i = 1: length(h)
    plot(Time(:, i), Voltage_out(:, i)*1e-3, DisplayName=sprintf("unit %.0f", i))
end

legend(Location="best")