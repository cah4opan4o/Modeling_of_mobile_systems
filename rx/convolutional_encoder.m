function data = convolutional_encoder(input)
    k = 7;
    trellis = poly2trellis(k,[171 133]);
    data = convenc(input, trellis);
end