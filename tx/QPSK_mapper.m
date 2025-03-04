function QPSKsymbols = QPSK_mapper(InterleavedBits)
    numSymbols = length(InterleavedBits)/2;
    QPSKsymbols = zeros(1,numSymbols);
    for i = 1:numSymbols
        bit1 = InterleavedBits(2*i-1);
        bit2 = InterleavedBits(2*i);
        if bit1 == 0 && bit2 == 0
            QPSKsymbols(i) = 0.707 + 0.707i;
        elseif bit1 == 0 && bit2 == 1
            QPSKsymbols(i) = 0.707 - 0.707i;
        elseif bit1 == 1 && bit2 == 0
            QPSKsymbols(i) = -0.707 + 0.707i;
        elseif bit1 == 1 && bit2 == 1
            QPSKsymbols(i) = -0.707 - 0.707i;
        end
    end
end