function InterleavedBits = QPSK_demapper(QPSKsymbols)
    numSymbols = length(QPSKsymbols);
    InterleavedBits = zeros(1,numSymbols*2);
    for i = 1:numSymbols
        realpart = real(QPSKsymbols(i));
        imagpart = imag(QPSKsymbols(i));
        if realpart >= 0 && imagpart >= 0
            InterleavedBits(2*i-1:2*i) = [0 0];
        elseif realpart >= 0 && imagpart < 0
            InterleavedBits(2*i-1:2*i) = [0 1];
        elseif realpart < 0 && imagpart >= 0
            InterleavedBits(2*i-1:2*i) = [1 0];
        elseif realpart < 0 && imagpart < 0
            InterleavedBits(2*i-1:2*i) = [1 1];
        end
    end
end