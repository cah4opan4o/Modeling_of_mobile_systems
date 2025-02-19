function data = convolutional_encoder(input)
    k = 7;
    output = [];
    buffer = zeros(1,k);
    % input = flip(input);

    for i = 1:length(input)
        buffer(2:end) = buffer(1:end-1);
        buffer(1) = input(i);
        %buffer = [input(i), buffer(1:end-1)];
        %X = mod(sum(buffer([1,2,3,4,7])),2);
        X = mod(sum(buffer([1,3,5,6,7])),2); % 171 oct
        %Y = mod(sum(buffer([1,3,4,6,7])),2);
        Y = mod(sum(buffer([1,2,4,6,7])),2); % 133 oct
        output = [output, X, Y];
    end
    data = output;
end