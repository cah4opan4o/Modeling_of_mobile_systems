function decodeMessage = symbolic_decoder(encodedBits)
    decodeMessage = char([]);
    for i = 1:8:length(encodedBits)
        bits = encodedBits(i:i+7);
        byte = uint8(bin2dec(num2str(bits)));
        decodeMessage = [decodeMessage, char(byte)];
    end
end