function [out] = ConvCoder(bits)

k = 7;
G1 = 171;
G2 = 133;

yzli=[];
for i=0:2^k-1
    yzli=[yzli {dec2bin(i,k)}];
    
end

%переводим параметры из восьмеричных чисел в двоичные
G1=dec2bin(oct2dec(G1));
G1=str2num(reshape(G1,[],1))';
G2=dec2bin(oct2dec(G2));
G2=str2num(reshape(G2,[],1))';

% формируем код согласно структуре
delay_pipe=zeros(1,k);

for i=1:length(bits)
    delay_pipe(2:k) =   delay_pipe(1:k-1); %сдвиговый регистр
    delay_pipe(1)   =   bits(i);
 out_s1=0;
 out_s2=0; 
    for j=1:k %само кодирование
        out_s1  = out_s1 + G1(j)*delay_pipe(j); 
        out_s2  = out_s2 + G2(j)*delay_pipe(j);
    end       
    out(2*i-1)      =   mod(out_s1,2);
    out(2*i)        =   mod(out_s2,2);
end



