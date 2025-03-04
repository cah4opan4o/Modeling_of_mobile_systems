function interleavedBits = interleaving(convEncodedBits)
    idX = randperm(length(convEncodedBits));
    interleavedBits = convEncodedBits(idX);

    setappdata(0,'idX',idX)
end