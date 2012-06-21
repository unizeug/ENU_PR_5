% PCM_Analyse_auswertung.m
clear all;
%close all;
load('../Messwerte/dreieckflanken.mat')
% A... Spannungssignal
% B... Bitwörter+Rahmensynchronisationssignal

B = -B

%Filter Kanal B
B_filt=PerfectTP(B,1/Tinterval,200e3);
% Split gefilterten Kanal B
[Data Rahmen]=Split(B_filt);
% Data bereinigen:
Data(Data<2.5)=0;
Data(Data>=2.5)=1;


% die folgende routine würde das erste Bit ausgelassen wenn die Aufnahme der
% Messwerte bei einer fallenden Flanke startet

if Rahmen(1) == 1 && Rahmen(2) == 0
    display('Möööööööööp')
end

% Vektor erstellen, der eine 1 enthält wo ein neues Bit anfängt
WortStart = Rahmen(1:end-1) - Rahmen(2:end);

% entstandene negative Werte löschen
WortStart(WortStart<0) = 0;

% eine null am Anfang ist verloren gegangen
WortStart = [0; WortStart];

WortStart2 = WortStart;
Tasts = zeros(1,length(WortStart));
Wrong = zeros(1,length(WortStart));
A2 = A;
Ti = 1;

t = 1:1:length(Data);

% figure(2);
% clf(2)
% hold on;
% stem(t, Data)
% stem(t, WortStart2+0.02,'r')


% 
BitProWort = 8;

% Anzahl Worte:
% das erste und das letzte Wort ist nicht volständig. das erste gucken wir
% uns eh nicht an, das letzte darf aber nicht mehr bearbeitet werden.
AnzahlBitWorte = sum(WortStart) -1;

% Vektor für die Dezimalwerte der Bitworte
DecVal=ones(1,AnzahlBitWorte)*-7;
% Vektor für die zugehörigen Spannungspegel
VoltVal=ones(1,AnzahlBitWorte)*-8;

for i=1:AnzahlBitWorte
        
    % index der ersten 1 finden
    [Y,anf] = max(WortStart);
    
    Ti = Ti + anf-1;
    % führende nullen löschen (aus "end" macht Matlab "length(Daten)")
    WortStart = WortStart(anf:end);
    Data = Data(anf:end);
    A = A(anf:end);
    anf = 1;
    
    % erste 1 löschen um die zweite zu finden
    WortStart(anf) = 0;
    
    % das ende dieses Wortes
    [Y,ende]= max(WortStart);
    
    % die nächste 1 ist aber schon der anfang des nächsten wortes -> einen weniger
    ende = ende-1;
   
   % zweite 1 löschen weil sie bearbeitet wurde (bzw. für die Verarbeitung jetzt in ende steht)
   %%% !!!! Naaaaain, die nächste 1 ist doch schon der anfang des nächsten
   %%% Worts
  % WortStart(ende+1) = 0;

   
    % wie viele Abtastwerte hat das Wort
    TastWerte = ende-anf+1;
    
    % ein Wort hat 8 Bit
    Bits = ones(1,8)*-9;    
    
    % anzahl der verbleibenden Bits zum runterzählen
    j = 8;
    
    % k zum hochzählen der der Bits vom MSB zum LSB
    for k=1:8
    
        % wie viele Abtastwerte weisen wir diesem Bit zu
        AbtProBit = round(TastWerte/j);
        
        % der Durchschnitt der zugeteilten Abtastwerte für dieses Bit (unten wird < 0.5 mit 0 ersetzt und >0.5 mit 1)
        Bits(k) = double(sum(  Data( anf:anf+AbtProBit )  )/AbtProBit >= 0.5); %Data(anf + floor(AbtProBit/2));%
        Tasts(Ti+anf + round(AbtProBit/2)) = 1;
        
        if k==1 && Bits(k)==1
            Wrong(Ti+anf + round(AbtProBit/2)) = 1;
        end
        
        % Das Bit wurde abgearbeitet, deswegen kann beim nächsten durchgang mit dem zweiten angefangen werden
        anf = anf + AbtProBit;
        
        % verbleibende Abtastwerte für die restlichen Bits ( j Abtastwerte wurden ja schon gelesen und in Bits(k) geschrieben)
        TastWerte = TastWerte - AbtProBit;
        
        % Es ist ein Bit weniger übrig
        j = j - 1;
    end
  
    % Bits
    %length(Data)
    
    
    Bits(Bits<0.5)=0;
    Bits(Bits>=0.5)=1;
 

    
    % Bits
    %length(Data)
    
    % Quantisierungsstufe als Dezimalwert abspeichern (bin2dec kann nur mit Strings arbeiten -> Wort in String wandeln)
    DecVal(i)  = bin2dec(num2str(Bits')');
    
    % quantisierungsstufen zuückwandeln in den Spannungswert
    VoltVal(i) = A(anf);%(DecVal(i))*(4/256)-2;
    
    % Verarbeitete Daten löschen (wird oben ja schon gemacht wenn die führenden nullen weggeschnitten werden)
%      WortStart = WortStart(ende+1:end);
%      Data = Data(ende+1:end);
end


% stem(t,Tasts+0.01,'g')
% stem(t,Wrong+0.015,'c')
% %stem(t,A2,'b')
% hold off


figure(1)
clf(1)
stem(VoltVal,DecVal)
xlabel('Spannung [V]')
ylabel('Abtaststufe')

