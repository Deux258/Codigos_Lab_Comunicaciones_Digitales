% Rango en decibelios
EbN0_dB = 0:11;
EbN0_lin = 10.^(EbN0_dB / 10);

% BER teórico BPSK
BER_theoretical = 0.5 * erfc(sqrt(EbN0_lin));

semilogy(EbN0_dB, BER_theoretical, 'b-o', 'LineWidth', 2);
grid on;
xlabel('E_b/N_0 [dB]');
ylabel('Tasa de error de bits (BER)');
title('Curva teórica BER vs. E_b/N_0 para BPSK');
legend('BER teórica BPSK');
