function deInterleavedBits = deinterleaving(interleavedBits)
    idX = getappdata(0,'idX');
    
    deInterleavedBits = zeros(size(interleavedBits));

    if length(idX) ~= length(interleavedBits)
        error('Размеры idX и interleavedBits не совпадают!');
    end

    deInterleavedBits(idX) = interleavedBits;
end