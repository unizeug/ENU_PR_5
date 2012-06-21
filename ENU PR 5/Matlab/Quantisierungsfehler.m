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

a=MaxSende/MaxDeko;
Aneu=a*Ameanfrei;

figure(1);
length(B);
tend=Length*Tinterval;
t=linspace(Tstart,tend,Length);


plot(t,Bmeanfrei,'r');
hold on
plot(t,Aneu);
hold off

%xcor

%Quantisierungsfehler bestimmen
Quant=B-Aneu;
%Plot Quantisierungsfehler-Histogramm
figure(2);
hist(Quant);
%Plot Quantisierungsfehler-LDS





t1=0:0.2:15; 
y1=Aneu;%sin(t1); 
y2=Bmeanfrei;%cos(t1); 


[xr,lag]=xcorr(y1,y2);
[mx,mind]=max(abs(xr));
delay_eva=lag(mind)



[c,lags] = xcorr(y1,y2); 
index_center=(length(c)+1)./2; 
[c,index_max]=max(c); 
delay=index_max-index_center
        

 
 
figure(3)
clf(3)
hold on

t = t(1:end-delay_eva);
plot(t,y1(delay_eva+1:end))
plot(t,y2(1:end-delay_eva),'r')

hold off
 
 
 
 figure(4)
 clf(4)
 plot(xcorr(y1,y2))
        
        