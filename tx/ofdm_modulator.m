function ofdmSymbols = ofdm_modulator(qpskSymbols, dRS, T)
    Nqpsk = numel(qpskSymbols); % Используем numel() для получения числа элементов
    Nrs = floor(Nqpsk / dRS); % Количество опорных сигналов
    C = 0.25;
    Nz = round(C * (Nrs + Nqpsk)); % Количество нулевых поднесущих

    SignalWithPilots = zeros(1, Nqpsk + Nrs); 

    indexNrs = [];
    for i = 1:numel(SignalWithPilots)
        if mod(i, dRS) == 0
            SignalWithPilots(i) = 0.707 + 0.707i;
            indexNrs = [indexNrs, i];
        else
            qpskElement = qpskSymbols(1);
            qpskSymbols(1) = []; % Удаляем первый элемент
            SignalWithPilots(i) = qpskElement;
        end
    end
    setappdata(0,'indexNrs',indexNrs);
    setappdata(0,'Nz',Nz);
    setappdata(0,'PilotValue',0.707 + 0.707i);
    setappdata(0,'C',C);
    setappdata(0,'T',T);
    setappdata(0,'dRS',dRS);

    SignalWithZeroPadding = zeros(1, Nqpsk + Nrs + 2 * Nz);
    SignalWithZeroPadding(Nz + 1 : end - Nz) = SignalWithPilots;

    odpf = ifft(SignalWithZeroPadding);
    output = [odpf(end - T * Nqpsk + 1 : end), odpf];
    ofdmSymbols = output;
end
