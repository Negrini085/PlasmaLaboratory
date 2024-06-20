%---------------------------------------------------%
%          Testo spettri & minimi/massimi           %
%---------------------------------------------------%

close all
clear all
clc


%--------------------------------------------------%
%        Function to compute FFT amplitudes        %
%--------------------------------------------------%
function power = offset_SpectrumAnalysis(segnale)
    % Calcolo le dimensioni del campione preso in considerazione per l'
    % analisi in FFT e faccio la FFT
    M = 2 * ceil(length(segnale)/2);
    fou = fft(segnale, M);
    
    % Normalizzo e considero il modulo
    fou = fou/M;
    power = fou.*conj(fou);
end



%------------------------------------------------------%
%     Function to test FFT interval we want to use     %
%------------------------------------------------------%
function freqMax = testIntervalFFT(t, segnale)
    % Calcolo il tempo di sampling
    dt = (t(160)-t(150))/10;

    % Valuto le frequenze caratteristiche di campionamento
    fprintf('PUNTO 1:\n')
    fprintf('Frequenza di Nyquist-Shannon: %e\n', 1/(2*dt))
    fprintf('Frequenza di risoluzione: %e\n', 1/(length(t)*dt))
    fprintf('\n')

    % Computing test spectrum analysis
    power = offset_SpectrumAnalysis(segnale);
    
    % Computing valuable variables to study spectrum behaviour
    frequenze = 0:1/(length(t)*dt):1/(2*dt);
    ampiezze = sqrt(power(1:length(frequenze)));

    [maxSign, ind] = max(ampiezze);

    % Primo subplot --> grafico il segnale considerato
    figure; subplot(2, 1, 1);
    plot(t, segnale, 'r-', 'LineWidth',2); hold on; grid on;
    title('Segnale originale'); xlabel('Tempo'); ylabel('Ampiezza');

    % Secondo subplot --> grafico in scala log-log la FFT Analysis
    subplot(2, 1, 2);
    loglog(frequenze, ampiezze, 'b-', 'LineWidth', 2); hold on; grid on;
    title('Analisi FFT'); xlabel('Frequenze (Hz)'); ylabel('Ampiezza');

    freqMax = frequenze(ind);
end


% Per effettuare l'analisi con FFT vogliamo utilizzare i seguenti limiti
% all'intervallo temporale preso in considerazione. Abbiamo che:
%           ---> 100ms      min:  74.9 ms   max:  99.9 ms
%           ---> 125ms      min:  99.9 ms   max: 124.9 ms
%           ---> 150ms      min: 129.9 ms   max: 149.9 ms
%           ---> 175ms      min: 154.9 ms   max: 174.9 ms
%           ---> 200ms      min: 179.9 ms   max: 199.9 ms
%           ---> 225ms      min: 204.9 ms   max: 224.9 ms
%           ---> 250ms      min: 229.9 ms   max: 249.9 ms
%           ---> 275ms      min: 249.9 ms   max: 274.9 ms
%           ---> 300ms      min: 269.9 ms   max: 299.9 ms

% Parametri per lettura del segnale
udmv = 0.001; udmt = 0.001;
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/Signals/series6_125ms/segnale06.txt';

% Apertura del canale di comunicazione con il file in questione
%tfour = 0:1e-6:1; w1 = 8e3; w2 = 12e3;
%vfour = sin(2*pi*w1*tfour) + 0.5*sin(2*pi*w2*tfour);
data = fopen(path, 'rt'); N = 3; 
filescan = textscan(data,'%f %f','HeaderLines',N);
t = filescan {1,1}; v = filescan {1,2};

% Testo il segnale preso in considerazione
tmin = 99.9; tmax = 124.9;
tfour = t((t>tmin) & (t<tmax));
vfour = v((t>tmin) & (t<tmax));
tfour = tfour * udmt; vfour = vfour * udmv;


fMax = testIntervalFFT(tfour, vfour);
disp(["La frequenza di picco dell'analisi in FFT è pari a:" num2str(fMax)])


% Variazione della frequenza di massimo al cambiare dell'ampiezza dell
% intervallo di campionamento (per evoluzione libera pari a 200 ms):
%               --->    Ampiezza:  2 ms     Risoluzione: 500.0 Hz     Picco: 17000 Hz
%               --->    Ampiezza:  3 ms     Risoluzione: 333.0 Hz     Picco: 17333 Hz
%               --->    Ampiezza:  5 ms     Risoluzione: 200.0 Hz     Picco: 17200 Hz
%               --->    Ampiezza: 10 ms     Risoluzione: 100.0 Hz     Picco: 17200 Hz
%               --->    Ampiezza: 15 ms     Risoluzione:  75.0 Hz     Picco: 17200 Hz
%               --->    Ampiezza: 20 ms     Risoluzione:  50.0 Hz     Picco: 17200 Hz
%               --->    Ampiezza: 30 ms     Risoluzione:  33.3 Hz     Picco: 17200 Hz
%               --->    Ampiezza: 40 ms     Risoluzione:  25.0 Hz     Picco: 17175 Hz