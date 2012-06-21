clear all; %close all;
load ../Messwerte/100kHz_sin.mat
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



% kreuzkorrelation um das Delay zu bestimmen

[c,lag]=xcorr(Aneu,Bmeanfrei);
[mx,max_ind]=max(abs(c));
delay=lag(max_ind)


t = t(1:end-delay);
A = Aneu(delay+1:end);
B = Bmeanfrei(1:end-delay);


 
figure(2)
clf(2)

hold on
    plot(t,A)
    plot(t,B,'r')
hold off
 
 
 
figure(3);
clf(3);

plot(t, A - B)







%Quantisierungsfehler bestimmen
QuantErr=A - B;

figure(4);
clf(4);
hist(QuantErr);


%Plot Quantisierungsfehler-LDS





%% noch nicht fertig

% figure(1);
% print -painters -dpdf -r600 ../Bilder/Signal_Re.pdf
% figure(2);
% print -painters -dpdf -r600 ../Bilder/PCM_Test.pdf
% figure(3);
% print -painters -dpdf -r600 ../Bilder/PCM_Test.pdf
% figure(4);
% print -painters -dpdf -r600 ../Bilder/PCM_Test.pdf










