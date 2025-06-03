 f0 = 1; % Ancho de banda de 6 dB (Hz)
        alpha_values = [0, 0.25, 0.75, 1]; 
        Ts = 1 / (2 * f0);
        t_total = 5;
        N = 100001;
        t = linspace(-t_total, t_total, N);
        f = linspace(-2 * f0 * (1 + max(alpha_values)), 2 * f0 * (1 + max(alpha_values)), N);
        
        % Paleta de colores consistente
        colors = lines(length(alpha_values));
        
        %% Figura: Respuesta en frecuencia
        figure('Name', 'Respuesta en frecuencia');
        hold on;
        for i = 1:length(alpha_values)
            alpha = alpha_values(i);
            f_delta = alpha * f0;
            B = f0 * (1 + alpha);
        
            % Calcular H_e(f)
            H = zeros(size(f));
            f1 = f0 - f_delta;
            mask1 = abs(f) <= f1;
            mask2 = (abs(f) > f1) & (abs(f) <= B);
            H(mask1) = 1;
            H(mask2) = 0.5 * (1 + cos(pi * (abs(f(mask2)) - f1) / (2 * f_delta)));
            H(abs(f) > B) = 0;
        
            plot(f, H, 'Color', colors(i,:), 'LineWidth', 1.5, ...
                'DisplayName', ['\alpha = ', num2str(alpha)]);
        end
        title('Respuesta en frecuencia');
        xlabel('f (Hz)');
        ylabel('H_e(f)');
        grid on;
        legend show;
        xlim([min(f), max(f)]);
        hold off;
        
        %% Figura: Respuesta al impulso 
        figure('Name', 'Respuesta al impulso');
        hold on;
        for i = 1:length(alpha_values)
            alpha = alpha_values(i);
            f_delta = alpha * f0;
        
            % Calcular h_e(t)
            sinc_term = sin(2 * pi * f0 * t) ./ (2 * pi * f0 * t);
            sinc_term(t == 0) = 1;
            denominator = 1 - (4 * f_delta * t).^2;
            denominator(abs(denominator) < 1e-9) = NaN;
            cos_term = cos(2 * pi * f_delta * t) ./ denominator;
            h = 2 * f0 * sinc_term .* cos_term;
            h(isnan(h)) = 0;
        
            plot(t, h, 'Color', colors(i,:), 'LineWidth', 1.5, ...
                'DisplayName', ['\alpha = ', num2str(alpha)]);
        end
        title('Respuesta al impulso');
        xlabel('t (s)');
        ylabel('h_e(t)');
        grid on;
        legend show;
        xlim([-4, 4]);
        hold off;
 N_bits = 1e4;                   % Número de bits
                bit_rate = 1e3;                 % Tasa de bits (bps)
                fs = 10*bit_rate;               % Frecuencia de muestreo
                alpha_values = [0, 0.25, 0.75, 1];
                colors = ['b', 'r', 'g', 'm'];  % Colores para cada α
                span = 10;                      % Duración del filtro
                SNR = 20;                       % Relación señal-ruido (dB)
                
                % Genera secuencia NRZ-L con ruido
                bits = randi([0 1], 1, N_bits);
                nrz_signal = 2*bits - 1;        % Mapeo: 0 → -1, 1 → 1
                upsampled_signal = repelem(nrz_signal, fs/bit_rate);
                noisy_signal = awgn(upsampled_signal, SNR, 'measured');
                
                % Itera sobre cada α y crea una figura para cada uno
                for idx = 1:length(alpha_values)
                    figure;  % Crea una nueva figura para cada α
                    hold on;
                    alpha = alpha_values(idx);
                    sps = fs/bit_rate;  % Muestras por símbolo
                
                    % Diseña filtro de coseno alzado
                    filter_coeff = rcosdesign(alpha, span, sps, 'sqrt');
                
                    % Aplica filtro
                    filtered_signal = conv(noisy_signal, filter_coeff, 'same');
                
                    % Extrae segmentos de 2 símbolos para el diagrama de ojo
                    segment_length = 2*sps;
                    num_segments = floor(length(filtered_signal)/segment_length);
                
                    % Graficar los segmentos centrados
                    for k = 1:min(50, num_segments)
                        start_idx = (k-1)*segment_length + 1 - round(sps/2);
                        end_idx = start_idx + segment_length - 1;
                
                    % Asegura que los índices estén dentro del rango del vector
                    if start_idx < 1 || end_idx > length(filtered_signal)
                        continue;
                    end
                
                        segment = filtered_signal(start_idx:end_idx);
                
                        % Tiempo centrado: de -1 a 1 ms → desplazamos para que sea de 0 a 2 ms
                        time = (((0:length(segment)-1) - sps) / fs) * 1e3 + 1;  % tiempo en ms, centrado en 1 ms
                
                        % Graficar cada segmento
                        plot(time, segment, 'Color', colors(idx), 'LineWidth', 0.5);
                    end
                
                    % Etiquetas y formato
                    title(['Diagrama de Ojo (α = ', num2str(alpha), ')']);
                    xlabel('Tiempo (ms)');
                    ylabel('Amplitud');
                    xlim([0 2]);  % Eje X de 0 a 2 ms
                    grid on;
                    hold off;
                end
