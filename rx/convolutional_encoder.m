function convEncodedBits = convolutional_encoder(encodedBits)
    k = 7;
    trellis = poly2trellis(k,[171 133]);
    convEncodedBits = convenc(encodedBits, trellis);
end