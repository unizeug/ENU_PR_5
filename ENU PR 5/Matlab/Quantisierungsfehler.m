clear; close all;
load 100kHz_sin.mat
%Mittelwertbefreiung


meanB=mean(B);
meanA=mean(A);

Bmeanfrei=B-meanB;
Ameanfrei=A-meanA;

MaxSende=max(Bmeanfrei);
MaxDeko=max(Ameanfrei);
%minimale zeitliche Verschiebung finden
%und Signale entsprechend zuschneiden

a=MaxSende/MaxDeko;
Aneu=a*Ameanfrei;

figure(1);
length(B);
tend=Tstart+Length*Tinterval;
t=linspace(Tstart,tend,Length);


plot(t,Bmeanfrei,'r');
hold on
plot(t,Aneu);
hold off

xcor

%Quantisierungsfehler bestimmen
Quant=B-Aneu;
%Plot Quantisierungsfehler-Histogramm
figure(2);
hist(Quant);
%Plot Quantisierungsfehler-LDS

