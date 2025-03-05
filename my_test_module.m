clear all;

h = open_controller_v2("COM3", "COM4");

filter = 700;
adc_scale = 747;


%% Build output signal

% Build offset ramped square waves
sample_rate = 500; % [Hz]
max_voltage = 3000; % [V]

zero_time = 1; % [s]
ramp_time = 0.2; % [s]
hold_time = 1; % [s]
signal_offset = ramp_time+hold_time;

idx_end_ramp = ramp_time*sample_rate;
idx_end_hold = idx_end_ramp + 2*hold_time*sample_rate + ramp_time*sample_rate;
idx_end_ramp_down = idx_end_hold + ramp_time*sample_rate;

ramped_square = [];
ramped_square(1:idx_end_ramp, 1) = linspace(0, max_voltage, ramp_time*sample_rate)';
ramped_square(idx_end_ramp+1:idx_end_hold, 1) = max_voltage;
ramped_square(idx_end_hold+1:idx_end_ramp_down, 1) = linspace(max_voltage, 0, ramp_time*sample_rate)';

zero_pad = zeros(signal_offset*sample_rate, 1);
output_signal = [];

output_signal = [ramped_square; zero_pad; ramped_square];

temp1 = [zero_pad; zero_pad; ramped_square; zero_pad];

output_signal = [output_signal(:, 1); temp1];

% Build offset sine waves
frequency = 0.5; % [Hz]
num_cycles = 4;
zero_pad = zeros((sample_rate/frequency)/2, 1);

cycle_samples = sample_rate/frequency;
sine = (sin(linspace(-pi/2, (3*pi)/2, cycle_samples)) + 1)'*(max_voltage/2);

% Stack multiple cycles
single_sine = sine;
for i = 1:(num_cycles - 1)
    sine = [sine; single_sine];
end

sine_vector_1 = [zero_pad; sine];
sine_vector_2 = [sine; zero_pad];
% output_signal = [output_signal(:, 1); sine_vector_1];
output_signal = [output_signal(:, 1)];

figure(1)
hold on
plot(output_signal)




write_pt_v1(h, 0, output_signal, sample_rate);
stop_controller_v2(h);

Voltage_out = read_pt_v1(h);
close_controller_v2(h);


% clf;
% Voltage_out = l - r;
% hold on
% plot(t/7812.5, Voltage_out*1e-3)
% xlabel('Time (s)')
% ylabel('Voltage (kV)')
% grid on