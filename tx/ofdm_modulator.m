function ofdmSymbols = ofdm_modulator(qpskSymbols, dRS, T)
    % Получаем количество QPSK-символов
    Nqpsk = numel(qpskSymbols); 

    % Вычисляем количество пилотных символов (опорных сигналов)
    Nrs = floor(Nqpsk / dRS); 

    % Коэффициент для расчёта нулевых поднесущих (обычно 25% от общего числа)
    C = 0.25;

    % Расчёт количества нулевых поднесущих
    Nz = round(C * (Nrs + Nqpsk)); 

    % Создаём массив, в который будут вставлены как QPSK-символы, так и пилоты
    SignalWithPilots = zeros(1, Nqpsk + Nrs); 

    % Счётчики для текущей позиции в qpskSymbols и числа вставленных пилотов
    qpskCounter = 1;
    nrsCounter = 0;

    % Массив для хранения индексов, где вставлены пилотные символы
    indexNrs = [];

    % Цикл по всем позициям в массиве с пилотами
    for i = 1:length(SignalWithPilots)
        % Если текущий индекс кратен dRS и ещё не вставили все пилоты
        if mod(i, dRS) == 0 && nrsCounter < Nrs
            SignalWithPilots(i) = 0.707 + 0.707i; % Вставляем пилот
            indexNrs(end + 1) = i;                % Сохраняем индекс
            nrsCounter = nrsCounter + 1;          % Увеличиваем счётчик пилотов
        else
            SignalWithPilots(i) = qpskSymbols(qpskCounter); % Вставляем QPSK-символ
            qpskCounter = qpskCounter + 1;                  % Переходим к следующему символу
        end
    end

    % Сохраняем важные параметры для демодулятора
    setappdata(0,'indexNrs',indexNrs);
    setappdata(0,'Nz',Nz);
    setappdata(0,'PilotValue',0.707 + 0.707i);
    setappdata(0,'C',C);
    setappdata(0,'T',T);
    setappdata(0,'dRS',dRS);

    % Добавляем нулевые поднесущие по краям (паддинг)
    SignalWithZeroPadding = zeros(1, Nqpsk + Nrs + 2 * Nz);
    SignalWithZeroPadding(Nz + 1 : end - Nz) = SignalWithPilots;

    % Преобразуем в частотную область (OFDM-модуляция)
    odpf = ifft(SignalWithZeroPadding);

    % Вычисляем длину защитного интервала (циклический префикс)
    Ncp = round(T * length(odpf));
    setappdata(0,'Ncp',Ncp);

    % Добавляем циклический префикс (копируем последние Ncp символов в начало)
    output = [odpf(end - Ncp + 1 : end), odpf];

    % Возвращаем итоговый OFDM-сигнал
    ofdmSymbols = output;
end
