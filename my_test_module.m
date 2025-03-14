clear;
close all;

max_voltage = 3000;
FS = 500;
frequency = 0.5;

Time = [0: 1/FS: 10]';

Ports = ["COM5", "COM16"];

% createSignal(time, sampRate, frequency, triggerLevel,flag_rp, amp, method, dutyRatio, rampSpd, offset, phase, expo)
Input1 = createSignal(Time, FS, frequency/2, 0, 0, max_voltage, 'sine mod', 0, 0, 0, 0, 2);
Input2 = createSignal(Time, FS, frequency/2, 0, 0, max_voltage, 'sine mod', 0, 0, 0, 180/2, 2);

Input = [Input1, Input2];

figure(100)
hold on
plot(Time, Input1*1e-3, DisplayName="Ref 1")
plot(Time, Input2*1e-3, DisplayName="Ref 2")
legend(Location="best")
box on
grid on
xlabel("Time (s)")
ylabel("Voltage (kV)")


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


function voltageSignal = createSignal(time, sampRate, frequency, triggerLevel,flag_rp, amp, method, dutyRatio, rampSpd, offset, phase, expo)

time_total = time(end);
time_init = time(1);


phase_delay = deg2rad(mod(phase, 360));
time_delay = phase_delay/(2*pi*frequency);
ind_delay = floor(time_delay*sampRate);

signalBase = sin(2*pi*frequency*time);
voltageSignal = zeros(size(time));




switch method
    case 'sine'
        voltageSignal = abs(signalBase);

    case 'sine mod'
        voltageSignal = abs(signalBase.^expo);

    case 'triangle'
        voltageSignal = asin(sin(2*pi*frequency*time));
        voltageSignal = abs(voltageSignal/pi*2); % adujust for correct amplitude

    case 'sawtooth'
        voltageSignal = 2*frequency*time - floor(2*frequency*time);

    case 'step'
        voltageSignal = floor(dutyRatio - 2*frequency*time) - floor(-2*frequency*time);

    case 'ramped square'
        voltageSignal = floor(dutyRatio - 2*frequency*time) - floor(-2*frequency*time); % generate a step signal

        time_cycle = 1/frequency/2;
        time_rmp = amp/rampSpd;
        time_hold = 1/frequency/2*dutyRatio;

        if time_cycle < 2*time_rmp + time_hold
            uiwait(msgbox("'one cycle is longer than the set frequency: increase ramp speed or reduce duty ratio'", "Error", 'modal'));
        end

        ind_rmpTime = ceil(time_rmp*sampRate);
        ind_holdTime = ceil(time_hold*sampRate);


        voltageSignal = [zeros(ind_rmpTime, 1); voltageSignal(1: end - ind_rmpTime, 1)]; % shift the step signal


        for i = 1: ceil(time_total/time_cycle)
            ind_cycleStart = floor((time_init + (i-1)*time_cycle)*sampRate) + 1;
            ind_holdEnd = ind_cycleStart + ind_rmpTime + ind_holdTime;
            voltageSignal(ind_cycleStart: ind_cycleStart + ind_rmpTime) = linspace(0, 1, ind_rmpTime + 1);
            voltageSignal(ind_holdEnd: ind_holdEnd + ind_rmpTime) = linspace(1, 0, ind_rmpTime + 1);
        end

        voltageSignal = voltageSignal(1:length(time));
end

if flag_rp
    mask = sign(signalBase); % create a mask for reverse polarity
    voltageSignal = voltageSignal.*mask; % set direction for reversed polarity
end
voltageSignal = [zeros(ind_delay, 1); voltageSignal(1: end - ind_delay, 1)]; % shift phase
voltageSignal(time < time_delay) = 0;  % zero padding to avoid sudden ramp up from the phase shift

voltageSignal = amp*voltageSignal; % set amplitude
voltageSignal = voltageSignal + offset; % add offset

voltageSignal(time < 0) = 0; % zero padding for initializing time

if 1
    voltageSignal(time < -0.4) = triggerLevel;
    voltageSignal(time < -0.5) = 0;
end

end