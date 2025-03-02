function data = symbolic_encoder(input)
    data = [];
    for c = input
        bits = bitget(uint8(c), 8:-1:1);
        data = [data, bits];
    end
end