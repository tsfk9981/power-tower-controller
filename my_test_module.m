clear;
close all;

max_voltage = 3000;
FS = 500;

Ports = ["COM5", "COM16"];

Input = build_signal(max_voltage, FS, length(Ports));

h = open_PT(Ports, ["F", "D", "G"], [700, 0, 60]); % ready to use, but not yet streaming data from the device
pause(1) % wait for 1s to stabilize the closed loop control

start_PT(h) % start to stream data from the device

write_PT(h, Input, FS); % write out the setpoints to PT

stop_PT(h);

[Time, Voltage_out] = read_PT(h, length(Input)/FS);
close_PT(h);


figure(100)
hold on
for i = 1: length(h)
    plot(Time(:, i), Voltage_out(:, i)*1e-3, DisplayName=sprintf("unit %.0f", i))
end

legend(Location="best")
