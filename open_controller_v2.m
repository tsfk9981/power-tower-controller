function handle_arr = open_controller_v2(port1, port2)
    
    % For now, units all = 0
    unit = 0;

    % Open device 1
    handle1 = serialport(port1,9600);
    handle2 = serialport(port2,9600);
    % Calibrate with no voltage
    fwrite(handle1, [int8(unit), int8('C')], 'int8');
    fwrite(handle2, [int8(unit), int8('C')], 'int8');
    % Set ADC filtering
    fwrite(handle1, [int8(unit), int8('F'),typecast(int16(700),'int8')], 'int8');
    fwrite(handle2, [int8(unit), int8('F'),typecast(int16(700),'int8')], 'int8');
    % Set deadband
    fwrite(handle1, [int8(unit), int8('D'),typecast(int16(0),'int8')], 'int8');
    fwrite(handle2, [int8(unit), int8('D'),typecast(int16(0),'int8')], 'int8');
    % Set gain
    fwrite(handle1, [int8(unit), int8('G'),typecast(int16(60),'int8')], 'int8');
    fwrite(handle2, [int8(unit), int8('G'),typecast(int16(60),'int8')], 'int8');
    % Start data streaming
    tx(handle1,'V',1); % start data streaming
    tx(handle2,'V',1); % start data streaming




    handle_arr = [handle1 handle2];

end