
            N_bits = 1e4;                   % Numero de bits
            bit_rate = 1e3;                 % Tasa de bits (bps)
            alpha_values = [0, 0.25, 0.75, 1];
            fs_values = [10, 5, 3];         % Multiplos de bit_rate para comparar
            span = 10;                      % Duracion del filtro
            SNR = 20;                       % Relacion señal-ruido (dB)
            colors = ['b', 'r', 'g', 'm'];  % Colores para cada \alpha
            
            %% Generación de señal base
            bits = randi([0 1], 1, N_bits);
            nrz_signal = 2*bits - 1;        % NRZ-L: 0→-1, 1→1
            
            %% Analisis para diferentes frecuencias de muestreo (Parte IV.A.b)
            for fs_factor = fs_values
                fs = fs_factor * bit_rate;  % Frecuencia de muestreo actual
                upsampled_signal = repelem(nrz_signal, fs/bit_rate);
                noisy_signal = awgn(upsampled_signal, SNR, 'measured');
                
                % Solo para \alpha = 0.5 (ejemplo)
                figure;
                hold on;
                sps = fs/bit_rate;
                filter_coeff = rcosdesign(0.5, span, sps, 'sqrt');
                filtered_signal = conv(noisy_signal, filter_coeff, 'same');
                
                % Diagrama de ojo
                segment_length = 2*sps;
                for k = 1:min(100, floor(length(filtered_signal)/segment_length))
                    start_idx = max(1, (k-1)*segment_length + 1 - round(sps/2));
                    end_idx = min(length(filtered_signal), start_idx + segment_length - 1);
                    segment = filtered_signal(start_idx:end_idx);
                    %% Ajuste para desplazar las gráficas 0.5 ms a la izquierda
                    time = (((0:length(segment)-1) - sps/2)/fs * 1e3 + 0.5);  % Cambiamos +1 por +0.5 para el desplazamiento
                    plot(time, segment, 'b', 'LineWidth', 0.5);
                end
                title(['Diagrama de Ojo (fs = ', num2str(fs_factor), '×bit\_rate)']);
                xlabel('Tiempo (ms)'); ylabel('Amplitud'); xlim([0 2]); grid on;
                saveas(gcf, ['Eye_fs_', num2str(fs_factor), 'x.png']);  % Guardar figura
            end

            
            %% ========== PREGUNTA c) ==========
            % Efecto de modificar α (ya incluido en el código anterior)
            % Observaciones:
            % - α = 0: Ancho de banda mínimo, pero el "ojo" se cierra (más ISI).
            % - α = 1: Ancho de banda máximo, pero el "ojo" está más abierto (menos ISI).
            % - Valores intermedios (α = 0.25, 0.75) equilibran ancho de banda y apertura del ojo.
               
