function decodedBits = convolutional_decoder_viterbi(deShuffleBits)
    constraint_length = 7;
    trellis = poly2trellis(constraint_length, [171 133]);
    traceback_depth = max(1, min(5 * constraint_length, length(deShuffleBits) / 2));
    decodedBits = vitdec(deShuffleBits, trellis, traceback_depth, 'trunc', 'hard');
end