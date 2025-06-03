%% Actividad Previa OOK - MATLAB
% Este script genera:
% 1. La transformada de Fourier de un pulso rectangular.
% 2. La señal OOK en el dominio del tiempo para 5 bits.
% 3. El espectro de la señal OOK (FFT).

clear; close all; clc;

%% Parámetros generales
T = 1e-3;          % Duración del pulso rectangular / bit (1 ms)
Rb = 1/T;          % Tasa de bits = 1 kbit/s
fc = 100e3;        % Frecuencia portadora OOK
fs = 1e6;          % Frecuencia de muestreo
bits = [1 0 1 1 0];% Secuencia de bits para OOK (5 bits)
Nbits = length(bits);

%% -------------------------------
%% Figura 1: Transformada de Fourier de un pulso rectangular
%% -------------------------------
f = linspace(-5000, 5000, 10000); % Frecuencia en Hz

G = T * abs(sinc(f * T));  % Transformada de un pulso rectangular

figure;
plot(f, G, 'LineWidth', 2, 'Color', [1 0.5 0]); % naranja
title('Figura 1: |G(f)| de un pulso rectangular (T = 1 ms)');
xlabel('Frecuencia [Hz]');
ylabel('|G(f)|');
grid on;
xline(-1/T, '--k', 'f = -1/T');
xline( 1/T, '--k', 'f = 1/T');
xlim([-5e3 5e3]);


%% -------------------------------
%% Figura 2: Señal OOK en el dominio del tiempo
%% -------------------------------

% Vector de tiempo total
t_total = 0 : 1/fs : Nbits*T - 1/fs;
samples_per_bit = round(fs * T);
baseband = repelem(bits, samples_per_bit);

% Portadora
carrier = cos(2*pi*fc*t_total);

% Señal OOK: portadora cuando bit=1, cero cuando bit=0
ook_signal = baseband .* carrier;

figure;
plot(t_total*1e3, ook_signal, 'LineWidth', 1.2, 'Color', [1 0.5 0]);
title('Figura 2: Señal OOK en el dominio del tiempo (5 bits)');
xlabel('Tiempo [ms]');
ylabel('Amplitud');
grid on;
xlim([0 Nbits*T*1e3]);

%% -------------------------------
%% Figura 3: Espectro de la señal OOK (FFT)
%% -------------------------------
N = length(ook_signal);
Y = abs(fftshift(fft(ook_signal)));
f_axis = fftshift(fftshift(fftshift((0:N-1)/N - 0.5) * fs));

figure;
plot(f_axis/1e3, Y, 'LineWidth', 1.2, 'Color', [1 0.5 0]);
title('Figura 3: Espectro de la señal OOK (FFT)');
xlabel('Frecuencia [kHz]');
ylabel('|FFT|');
grid on;
xlim([-200 200]);  % kHz

