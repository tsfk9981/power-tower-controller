clear all;

h = open_controller("COM4");

switch_l = 1;
switch_r = 2;
control = 3;

mode = control;

filter = 700;
adc_scale = 747;
points = 5000;
step_lead = 0.1;
step_width = 0.2;
step_target = 4000;

tx(h,'F',filter);
tx(h,'A',adc_scale);
tx(h,'G',60);
tx(h,'D',0);

tx(h,'V',1); % start data streaming

switch mode
    case switch_l
        tx(h,'S',3);
    case switch_r
        tx(h,'S',5);
    case control
        tx(h,'O',0);
end
tic;

while(toc < step_lead); end

switch mode
    case switch_l
        tx(h,'S',1);
    case switch_r
        tx(h,'S',2);
    case control
        tx(h,'O',step_target);
end

while(toc < (step_lead + step_width)); end

switch mode
    case switch_l
        tx(h,'S',4);
    case switch_r
        tx(h,'S',4);
    case control
        tx(h,'O',0);
end

for i=1:points
    values(i,:) = fread(h, 6, 'uint8');
end
tx(h,'P'); % pause data streaming
tx(h,'S',0);
tx(h,'X');

close_controller(h);

t_init = values(1,2);
t_base = 0;
for i=2:points
    if(values(i,2)==0)
        t_base = t_base + 255;
    end
    t(i) = values(i,2) - t_init + t_base;
    l(i) = values(i,3) + values(i,4)*255;
    r(i) = values(i,5) + values(i,6)*255;
end
% clf;
Voltage_out = l - r;
hold on
plot(t/7812.5, Voltage_out*1e-3)
xlabel('Time (s)')
ylabel('Voltage (kV)')
grid on