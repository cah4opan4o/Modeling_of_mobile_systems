function data = symbolic_decoder(input)
    data = char([]);
    for i = 1:8:length(input)
        bits = input(i:i+7);
        byte = uint8(bin2dec(num2str(bits)));
        data = [data, char(byte)];
    end
end