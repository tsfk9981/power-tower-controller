function write_pt_v1(handle, unit, output_vector, sample_rate)

    flush(handle(1))
    flush(handle(2))
    period = 1/sample_rate;
    t = 0;

    tic
    % Execute timed operation on switch board
    for i = 1:length(output_vector(:, 1))

        % Write sequentially to both boards
        fwrite(handle(1), [int8(unit), int8('O'),typecast(int16(output_vector(i, 1)),'int8')], 'int8');
        fwrite(handle(2), [int8(unit), int8('O'),typecast(int16(output_vector(i, 1)),'int8')], 'int8');
            % Currently not reading voltage
        % Use empty while loop to control timing
        t = t + period;
        while toc < t
        end
    end

    % Turn off h-bridge
    fwrite(handle(1), [int8(unit), int8('S'),typecast(int16(0),'int8')], 'int8');
    fwrite(handle(2), [int8(unit), int8('S'),typecast(int16(0),'int8')], 'int8');
    % Turn off output control
    fwrite(handle(1), [int8(unit), int8('X')], 'int8');
    fwrite(handle(2), [int8(unit), int8('X')], 'int8');

end