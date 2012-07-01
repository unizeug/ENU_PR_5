clear all; %close all;
% feature('DefaultCharacterSet','UTF-8');
load ../Messwerte/100kHz_dreieck.mat
%Mittelwertbefreiung


meanB=mean(B);
meanA=mean(A);

Bmeanfrei=B-meanB;
Ameanfrei=A-meanA;

MaxSende=max(Bmeanfrei);
MaxDeko=max(Ameanfrei);
%minimale zeitliche Verschiebung finden
%und Signale entsprechend zuschneiden

booost=MaxSende/MaxDeko;
Aneu=booost*Ameanfrei;


tend=Length*Tinterval;
t=linspace(0,tend,Length);


figure(1);
clf(1);

hold on
    plot(t,Bmeanfrei,'r');
    plot(t,Aneu);
hold off
xlim([0 0.05])
xlabel('Zeit [s]');
ylabel('Spannung [V]');


% kreuzkorrelation um das Delay zu bestimmen

[c,lag]=xcorr(Aneu,Bmeanfrei);
[mx,max_ind]=max(abs(c));
delay=lag(max_ind);


t = t(1:end-delay);
A = Aneu(delay+1:end);
B = Bmeanfrei(1:end-delay);


 
figure(2)
clf(2)

hold on
    %plot(t,A,'.') interpoliert die Kennlinie nicht, sondern macht punkte an jeden Messpunkt, auch + sind m�glich
    %plot(t,B,'r.')
     plot(t,A)
    plot(t,B,'r')
hold off
xlabel('Zeit [s]');
ylabel('Spannung [V]');
 
 
figure(3);
clf(3);

plot(t, A - B)
xlabel('Zeit [s]');
ylabel('Spannung [V]');






%Quantisierungsfehler bestimmen
QuantErr=A - B;

figure(4);
clf(4);
hist(QuantErr);
ylabel('H�ufigkeit');
xlabel('Spannung [V]');

%Plot Quantisierungsfehler-LDS

f_T=100000; % oder =8000
T_ges=Tinterval*Length;
[c,lag]=xcorr(QuantErr,QuantErr);

figure(5);
clf(5);
FFTshiftplotZP_autocorr(c, T_ges, f_T, 4, 'r', 5, 0, 750);



% PDFs erstellen

% figure(1);
% print -painters -dpdf -r600 ../Bilder/100kHz_dreieck_Signal_Rekonstuiert.pdf
% figure(2);
% print -painters -dpdf -r600 ../Bilder/100kHz_dreieck_Signal_Rekonstuiert_delayed.pdf
% figure(3);
% print -painters -dpdf -r600 ../Bilder/100kHz_dreieck_Quantisierungsfehler.pdf
figure(4);
print -painters -dpdf -r600 ../Bilder/100kHz_dreieck_Quant_Hist.pdf
% figure(5);
% print -painters -dpdf -r600 ../Bilder/100kHz_dreieck_LSD.pdf









