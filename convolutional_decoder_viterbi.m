function data = convolutional_decoder_viterbi(input)
    constraint_length = 7;
    trellis = poly2trellis(constraint_length, [171 133]);
    traceback_depth = max(1, min(5 * constraint_length, length(input) / 2));
    decode_data = vitdec(input, trellis, traceback_depth, 'trunc', 'hard');
    % data = flip(decode_data);
    data = decode_data;
end