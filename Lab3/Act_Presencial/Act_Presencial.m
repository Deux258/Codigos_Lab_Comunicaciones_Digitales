%% Actividad Presencial - FSK Binario
% Este script genera:
% 1. La FT de la envolvente compleja g(t) para bits 0 y 1
% 2. La señal FSK en el dominio del tiempo (5 bits)
% 3. El espectro de la señal FSK (FFT)

clear; close all; clc;

%% Parámetros generales
T = 1e-3;           % Duración del bit (1 ms)
Rb = 1/T;           % Tasa de bits = 1 kbit/s
DeltaF = 2e3;       % Desviación de frecuencia (Hz)
fc = 100e3;         % Frecuencia central (Hz)
fs = 1e6;           % Frecuencia de muestreo (Hz)
bits = [1 0 1 1 0]; % Secuencia de bits
Nbits = length(bits);

%% -------------------------------
%% Figura 1: FT de la envolvente compleja g(t) (banda base)
%% -------------------------------
f = linspace(-10e3, 10e3, 10000);  % Eje de frecuencia en Hz
x1 = (f - DeltaF) * T;             % Desplazado a +2 kHz
x0 = (f + DeltaF) * T;             % Desplazado a -2 kHz

% Evitar división por cero manualmente
G1 = T * abs(sin(pi*x1) ./ (pi*x1));
G1(x1 == 0) = T;
G0 = T * abs(sin(pi*x0) ./ (pi*x0));
G0(x0 == 0) = T;

figure;
plot(f/1e3, G1, 'y', 'LineWidth', 2); hold on;
plot(f/1e3, G0, 'Color', [1 0.5 0], 'LineWidth', 2);
xline(DeltaF/1e3, '--k', 'f = +2 kHz');
xline(-DeltaF/1e3, '--k', 'f = -2 kHz');
xline((DeltaF+1/T)/1e3, ':', 'Color', [0.5 0.5 0.5]);
xline((DeltaF-1/T)/1e3, ':', 'Color', [0.5 0.5 0.5]);
xline(-(DeltaF+1/T)/1e3, ':', 'Color', [0.5 0.5 0.5]);
xline(-(DeltaF-1/T)/1e3, ':', 'Color', [0.5 0.5 0.5]);
title('Figura 1: |G(f)| de la envolvente compleja FSK');
xlabel('Frecuencia [kHz]');
ylabel('|G(f)|');
legend('Bit = 1 (centro en +2 kHz)', 'Bit = 0 (centro en -2 kHz)');
grid on;
xlim([-5 5]);

%% -------------------------------
%% Figura 2: Señal FSK en el dominio del tiempo
%% -------------------------------
t = 0 : 1/fs : Nbits*T - 1/fs;
samples_per_bit = round(T*fs);
baseband = repelem(bits, samples_per_bit);

% Definir portadoras
f1 = fc + DeltaF;
f0 = fc - DeltaF;
carrier1 = cos(2*pi*f1*t);
carrier0 = cos(2*pi*f0*t);

% Construcción de la señal FSK
fsk_signal = zeros(size(t));
for i = 1:length(t)
    if baseband(i) == 1
        fsk_signal(i) = carrier1(i);
    else
        fsk_signal(i) = carrier0(i);
    end
end

figure;
plot(t*1e3, fsk_signal, 'Color', [1 0.5 0], 'LineWidth', 1.2);
title('Figura 2: Señal FSK en el dominio del tiempo (5 bits)');
xlabel('Tiempo [ms]');
ylabel('Amplitud');
grid on;
xlim([0 Nbits*T*1e3]);

%% -------------------------------
%% Figura 3: Espectro de la señal FSK (FFT)
%% -------------------------------
N = length(fsk_signal);
Y = abs(fftshift(fft(fsk_signal)));
f_axis = (-N/2:N/2-1)*(fs/N); % eje de frecuencia

figure;
plot(f_axis/1e3, Y, 'LineWidth', 1.2, 'Color', [1 0.5 0]);
title('Figura 3: Espectro de la señal FSK (FFT)');
xlabel('Frecuencia [kHz]');
ylabel('|FFT|');
grid on;
xlim([90 110]);  % Mostrar ±10 kHz alrededor de fc = 100 kHz
