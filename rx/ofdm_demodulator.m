function rx_ofdmSymbols = ofdm_demodulator(AWGNbits)
    % Подгружаем данные с Tx
    indexNrs = getappdata(0,'indexNrs');
    Nz = getappdata(0,'Nz');
    PilotValue = getappdata(0,'PilotValue');
    T = getappdata(0,'T');
    Ncp = getappdata(0,'Ncp');

    % Удаляем циклический префикс
    AWGNbits = AWGNbits( Ncp + 1 : end);

    % Переход в частотную область
    dpf = fft(AWGNbits);

    % Удаляем нулевые поднесущие
    signal_without_zeros = dpf(Nz + 1 : end - Nz);

    % Извлекаем пилоты
    Rrx = PilotValue; % что было отправлено
    Rtx = signal_without_zeros(indexNrs); % что пришло

    % Оценка канала
    H_est = Rrx ./ Rtx;

    % Интерполяция
    all_indices = 1:length(signal_without_zeros);
    H_interp = interp1(indexNrs, H_est, all_indices, 'linear', 'extrap');

    % Коррекция канала
    signal_correct = signal_without_zeros ./ H_interp;

    % Удаление пилотов
    signal_correct(indexNrs) = [];
    rx_ofdmSymbols = signal_correct;
end