function rx_ofdmSymbols = ofdm_demodulator(AWGNbits)
    % Подгружаем данные с Tx
    indexNrs = getappdata(0,'indexNrs');
    Nz = getappdata(0,'Nz');
    PilotValue = getappdata(0,'PilotValue');
    C = getappdata(0,'C');
    T = getappdata(0,'T');

    AWGNbits = AWGNbits(floor(T * length(AWGNbits)) : end); % Удалил защитный интервал
    dpf = fft(AWGNbits);
    disp(length(dpf));
    signal_without_zeros = dpf(Nz + 1 : end - Nz); % Удалил нулевые поднесущие
    disp(length(signal_without_zeros))
    Rrx = PilotValue;
    Rtx = signal_without_zeros(indexNrs);
    H = Rrx ./ Rtx;
    signal_correct = signal_without_zeros ./ H;
    signal_correct(indexNrs) = [];
    rx_ofdmSymbols = signal_correct;
end                         

% function rx_ofdmSymbols = ofdm_demodulator(AWGNbits)
%     indexNrs = getappdata(0, 'indexNrs');   % Индексы опорных поднесущих
%     Nz = getappdata(0, 'Nz');               % Длина защитных интервалов
%     PilotValue = getappdata(0, 'PilotValue'); % Опорные символы
%     C = getappdata(0, 'C');                 % Число поднесущих
%     signal_no_prefix = AWGNbits(Nz + 1 : end); 
%     spectrum = fft(signal_no_prefix);
%     signal_without_zeros = spectrum(Nz + 1 : end - Nz);
%     Rrx = signal_without_zeros(indexNrs);  
%     Rtx = PilotValue;
%     H = Rrx ./ Rtx;
%     subcarrier_indices = linspace(1, length(signal_without_zeros), length(H));
%     H_interp = interp1(subcarrier_indices, H, 1:length(signal_without_zeros), 'linear', 'extrap');
%     CEQ = signal_without_zeros ./ H_interp;
%     data_subcarriers = setdiff(1:length(CEQ), indexNrs);  % Убираем опорные поднесущие
%     rx_ofdmSymbols = CEQ(data_subcarriers);
% end