function [ vb ] = ConvDecoder(input_bits)
  
k = 7;
G1 = 171;
G2 = 133;

length_dibits = length( input_bits )/2;     %количество дибит, оно же количество бит до кодирования



% input_bits=conv_coder_universal(input_bits,k,G1,G2);

[yzli, ves,add_to_metr,pyt,in_delay_pipe] = genyzl( k,G1,G2);%формируем таблицы параметров, для реализации в железе можно сгенерить здесь
                                                            % и перенести таблицы в железо                                                          
                                                       
nves=length( ves); 
%% Вычисление метрик
vb=[];
pyti=[];
kb=1;

%формируем дибиты
for i=1:length_dibits
    dibits(i)={[input_bits(2*i-1),input_bits(2*i)]};
end

metk=[];

for n=1:length_dibits %последовательно рассматриваем дибиты
    
    met1=[];
    met2=[];
    
    
    %считаем метрики на каждом шаге
    for i=1:nves
        met1=[ met1 sum(xor(dibits{n}, ves{1,i}))];               %первая строка-первый возможный переход (0)
        met2=[ met2 sum(xor(dibits{n}, ves{2,i}))];               %вторая строка-второй возможный переход (1)
    end
    met=[met1;met2];
    metk=[metk; met];
    
    % считаем метрики путей
    for i=1:2
        for j=1:nves
            sw(i,j)=met(i,j)+add_to_metr(pyt(i,j));             %длина путей, в каждый узел по 2 пути-2 строки
        end
    end
    
    
    add_to_metr = min(sw);
    pyti=[pyti; pyt]; % добавляются все пути, потом чистятся
    
    
    
    %обнуляем путь, у которого больше метрика
    for k=1:nves
        if (sw(1,k) <= sw (2,k) )
            pyti(2*n,k)=0; %обнуляем один из путей
        else
            pyti(2*n-1,k)=0;
        end
    end
    
    
    kp=n;  %kp- этап(номер ветви) на котором находится декодер
%     удаляем ненужные хвосты путей
    while kp>kb                                                 % kb-количество декодированных бит, т.е. номер ветви, где устранена неоднозначность
        for k=1:nves                                            %для каждого узла
            if (sum([pyti(2*kp-1,:)==k pyti(2*kp,:)==k])==0)    %если к данному узлу (k) на в последних двух тактах не идут ветви
                pyti(2*kp-2,k)=0;                               % удаляем предыдущие
                pyti(2*kp-3,k)=0;                               % удаляем предыдущие
            end
        end
        kp=kp-1;                                                %спускаемся с текущего положения до того, где устранена неоднозначность
    end
  
    
    
    %проверяем единственность пути
    p1=length(find(pyti(2*kb-1,:))); % сколько ненулевых элементов
    p2=length(find(pyti(2*kb,:)));
    if ((p1==1) && (p2==0)) || ((p1==0) && (p2==1));    %если путь один - верхний или нижний
        nb1=find(pyti(2*kb-1,:)); nb2=find(pyti(2*kb,:));%проверет номера ненулевого элемента
        if(p1==1) && (p2==0); vb=[vb in_delay_pipe(1,nb1)]; kb=kb+1; end; %берем бит из сдвигового регистра в соответствии с тем, какой переход был осуществлен
        if(p1==0) && (p2==1); vb=[vb in_delay_pipe(2,nb2)]; kb=kb+1; end;
    end;
    

    
    %Добиваем конец вычисляя наименьшую метрику, по принципу максимального
    %правдоподобия-наименьшего хэммингого расстояния
    if (n == length_dibits)                     %если дошли до конца
        min_end_metr=min(min(sw));              %находим конечный  узел с наименьшей метрикой
        
        for i=1:2                               %находим какому пути он соответствует
            for j=1:nves
                if(sw(i,j))==min_end_metr
                    end_way=pyti(2*length_dibits,j)+pyti(2*length_dibits-1,j); %смотрим предыдущий узел
                    vb(length_dibits)=in_delay_pipe(i,j); %декидируем
                end
            end
        end
          delt=length_dibits - kb+1;        %сколько бит не декодировали  
            for d=delt:-1:2;                %идем с конца и декодируем неизвестные биты
                 vb(kb-2+d) = in_delay_pipe(1,end_way);
                 end_way = pyti(2*(kb-2)+2*d ,end_way ) + pyti(2*(kb-2)+2*d-1 ,end_way );   %смотрим из какого узла пришла ветка
            end
    end
                
               
        
end
