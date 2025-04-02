function AWGNbits = channel(ofdmSymbols,Nb, N0)
f0 = 1.7; % Частота несущей, Гц
c = 3 * 10^8; % Скорость света, м/с
B = 11; % Ширина полосы, Гц
Ts = 1 / B; % Временной интервал, сек
Di = randi([10, 500], Nb, 1);
D1 = min(Di); % Минимальное расстояние (прямой луч)
Smpy = zeros(size(ofdmSymbols));
    for i = 1:Nb
        signal = zeros(size(ofdmSymbols));
        tau = floor((Di(i) - D1) / (c * Ts));
        for k = 1:length(ofdmSymbols)
            if tau < length(ofdmSymbols)
                signal((tau+1):end) = ofdmSymbols(1:end-tau);
            end
        end
        Gi = c / (4 * pi * Di(i) * f0);
        Smpy = Smpy + Gi .* signal;
    end
    noise = wgn(size(Smpy, 1), size(Smpy, 2), N0);
    Srx = Smpy + noise;
    AWGNbits = Srx;
end