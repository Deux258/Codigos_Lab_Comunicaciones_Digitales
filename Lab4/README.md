# Laboratorio 4 - Alex Marambio, Diego Muñoz

Este repositorio contiene los archivos y códigos correspondientes al Laboratorio 4 de Comunicaciones Digitales, enfocado en medir la Tasa de Error de Bits (BER) para modulaciones en banda base (BPSK, QPSK y 8‑PSK) bajo un canal AWGN.

### 📁 Estructura del repositorio

```bash
Lab4/
├── lab4_Presencial.grc # Diagrama de flujo final en GNU Radio Companion
├── lab4_Presencial.py # Script Python generado automáticamente por GRC
├── Matlab/
│ └── lab4.m # Script MATLAB para graficar BER teórico vs. empírico
└── README.md # Este archivo
```

### Descripción del diagrama `lab4_Presencial.grc`

El diagrama de flujo implementa un enlace digital en banda base con las siguientes etapas:

1. **Random Source**  
   Genera un flujo de bits `{0,1}` pseudoaleatorios.

2. **Throttle**  
   Controla la tasa de muestreo global (`samp_rate`) para evitar sobrecargar la CPU.

3. **Chunks to Symbols**  
   Mapea cada bit (0→−1, 1→+1) a la constelación BPSK.

4. **Noise Source**  
   Genera ruido Gaussiano (AWGN) con amplitud controlada por la variable `noise_amp`.

5. **Add**  
   Suma la señal modulada y el ruido para simular el canal.

6. **Constellation Decoder**  
   Decodifica la señal ruidosa asignando cada muestra al símbolo más cercano (0 o 1).

7. **UChar to Float**  
   Convierte los bits decodificados (uint8) a nivel `float` para comparar con la referencia.

8. **BER**  
   Compara la secuencia de referencia (bits originales) con la recibida, contando errores.

9. **QT GUI Number Sink**  
   Muestra en tiempo real el conteo de errores y la tasa de error (BER resultante).

10. **QT GUI Time Sink**
    - **Señal Modulada:** salida de `Chunks to Symbols` (±1 por bit).  
    - **Señal con Ruido:** salida del bloque `Add`.

11. **QT GUI Number Sink (opcional)**  
    Visualiza la secuencia de bits original vs. la decodificada.

### 🔧 Variables configurables

- `samp_rate` – Tasa de muestreo (p.ej. 32e3).  
- `noise_amp` – Amplitud del ruido AWGN (permite barrer Eb/N0).

Para cambiar el **Eb/N0**, basta con ajustar `noise_amp` (p.ej. 0.1, 0.2, 0.5, 1.0).

### Instrucciones de uso

1. Clona el repositorio:

   ```bash
   git clone https://github.com/Deux258/Codigos_Lab_Comunicaciones_Digitales.git
   cd Codigos_Lab_Comunicaciones_Digitales/Lab4

2. Abre el diagrama en GNU Radio:

```bash
gnuradio-companion lab4_Presencial.grc
```

3. Ajusta las variables samp_rate y noise_amp en el bloque Options.

4. Ejecuta el flujo desde GRC (botón ▶️).

5. Observa:

- La BER en el QT GUI Number Sink.

- Las formas de onda en los QT GUI Time Sink (modulada vs. con ruido).

- El conteo de bits en el segundo QT GUI Number Sink.

6. Para graficar la comparación con la teoría, recopila los valores de BER y edita lab4.m con tus datos empíricos.

7. Ejecutar el script en MATLAB