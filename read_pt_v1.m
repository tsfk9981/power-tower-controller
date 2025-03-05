function Voltage = read_pt_v1(handle)

handle_1 = handle(1);
handle_2 = handle(2);


for i=1:50000 % TODO no hard coding!!
    values_1(i,:) = fread(handle_1, 6, 'uint8');
    values_2(i,:) = fread(handle_2, 6, 'uint8');
end



t_init_1 = values_1(1,2);
t_init_2 = values_2(1,2);

t_base_1 = 0;
t_base_2 = 0;

for i=2: 50000 % TODO no hard coding!!
    if(values_1(i,2)==0)
        t_base_1 = t_base_1 + 255;
    end
    if(values_2(i,2)==0)
        t_base_2 = t_base_2 + 255;
    end
    t_1(i) = values_1(i,2) - t_init_1 + t_base_1;
    l_1(i) = values_1(i,3) + values_1(i,4)*255;
    r_1(i) = values_1(i,5) + values_1(i,6)*255;

    t_2(i) = values_2(i,2) - t_init_2 + t_base_2;
    l_2(i) = values_2(i,3) + values_2(i,4)*255;
    r_2(i) = values_2(i,5) + values_2(i,6)*255;
end

Voltage_1 = (l_1 - r_1)';
Voltage_2 = (l_2 - r_2)';

Voltage = [Voltage_1 Voltage_2];


end