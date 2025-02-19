% word = input('Введите слово: ', 's');
% disp(word)

% word = symbolic_encoder(word);
% disp(word);

% word = symbolic_decoder(word);
% disp(word);

array = [1,0,1,0];
disp(['Изначальные данные: ', num2str(array)]);

output = convolutional_encoder(array);
disp(['После кодера: ', num2str(output)]);

output = convolutional_decoder_viterbi(output);
disp(['После декодера: ', num2str(output)]);