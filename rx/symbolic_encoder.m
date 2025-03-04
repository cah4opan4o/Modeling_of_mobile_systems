function encodedBits = symbolic_encoder(message)
    encodedBits = [];
    for c = message
        bits = bitget(uint8(c), 8:-1:1);
        encodedBits = [encodedBits, bits];
    end
end