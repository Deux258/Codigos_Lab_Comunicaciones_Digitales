# Laboratorio 3 - Alex Marambio, Diego Muñoz

Este repositorio contiene los códigos necesarios para realizar la práctica presencial de FSK binario, tanto en **MATLAB** como en **GNU Radio Companion (GRC)**. A continuación se describe en detalle cada archivo, su propósito y qué parte del laboratorio cubre.

---

## Índice

1. [Descripción General](#descripción-general)  
2. [Estructura del Repositorio](#estructura-del-repositorio)  
3. [Dependencias](#dependencias)  
4. [MATLAB](#matlab)  
   - `FSK_envolvente.m`  
   - `FSK_simulacion.m`  
5. [GNU Radio Companion](#gnu-radio-companion)  
   - `FSK_Transmisor.grc`  
6. [Cómo Ejecutar](#cómo-ejecutar)  
7. [Mapeo con la Actividad de Laboratorio](#mapeo-con-la-actividad-de-laboratorio)  

---

## 1. Descripción General

En esta práctica se busca:

1. **Derivar y verificar** la ecuación teórica del ancho de banda para FSK binario:
   \[
     B_{\mathrm{FSK}} = 2\,\Delta f \;+\; 2\,R_b.
   \]
2. **Determinar la envolvente compleja** \(g(t)\) de una señal FSK:
   \[
     g(t) = e^{\,j\,2\pi\,\Delta f\,m(t)\,t}, \quad m(t)=\pm1.
   \]
3. **Graficar** en MATLAB la transformada de Fourier de dicha envolvente (dos lóbulos sinc desplazados).  
4. **Simular en MATLAB** la señal FSK en tiempo y frecuencia para una secuencia de bits.  
5. **Implementar en GNU Radio Companion** un transmisor FSK binario que use como modulante un tren de pulsos (onda cuadrada).  
6. **Medir y justificar** (en “Frequency Sink” o analizador de espectros real) que el ancho de banda medido coincide con el valor teórico.

---

## 2. Estructura del Repositorio
```bash
.
├── README.md
├── MATLAB/
│ ├── FSK_envolvente.m
│ └── FSK_simulacion.m
└── GNU_Radio/
└── FSK_Transmisor.grc
```

- **`MATLAB/`**  
  Contiene los scripts de MATLAB que generan:
  - La transformada de Fourier de la envolvente compleja (`FSK_envolvente.m`).  
  - La simulación en el dominio del tiempo y la FFT de la señal FSK (`FSK_simulacion.m`).

- **`GNU_Radio/`**  
  Contiene el flowgraph de GNU Radio Companion:
  - `FSK_Transmisor.grc`: definición de bloques y conexiones para transmitir FSK binario en tiempo real.

- **`README.md`**  
  Este documento, que explica en detalle cada componente, cómo ejecutarlo y cómo se relaciona con la actividad de laboratorio.

---

## 3. Dependencias

### MATLAB
- MATLAB R2018b o superior (funciones básicas de `fft`, `plot`, etc.).  
- No se utiliza Toolbox adicional: solo funciones básicas (`fft`, `fftshift`, `linspace`, `plot`, etc.).

### GNU Radio Companion
- GNU Radio versión 3.8 o 3.9 (u otra compatible).  
- Bloques estándar incluidos en la instalación básica:
  - **Signal Source** (Square y Cosine).  
  - **Multiply Const** y **Add Const**.  
  - **Selector** (o “Switch” en algunas versiones).  
  - **Throttle**, **QT GUI Time Sink**, **QT GUI Frequency Sink**.  
- Si va a usar hardware real:  
  - **Osmocom Sink** o **USRP Sink** (para emitir por RF).  
  - Un analizador de espectros o receptor SDR (opcional).

---

## 4. MATLAB

Dentro de la carpeta `MATLAB/` se encuentran dos scripts:

### 1. `FSK_envolvente.m`

#### Descripción
Este script calcula y grafica la **transformada de Fourier** de la envolvente compleja \(g(t)\) para un bit “1” y para un bit “0”. En banda base, cada envolvente es un pulso rectangular modulando un exponencial a \(\pm \Delta f\).

#### Parámetros importantes
```bash
- `Rb = 1e3;`      % Tasa de bits = 1 kbit/s  
- `T  = 1 / Rb;`   % Duración de bit = 1 ms  
- `DeltaF = 2e3;`  % Desviación de frecuencia = 2 kHz  
- `f = linspace(-10e3, 10e3, 10001);`  
    % Eje de frecuencias de –10 kHz a +10 kHz
```

#### Salida esperada
- Una figura donde se ve claramente:
Lóbulo principal centrado en +2 kHz (bit=1) y en −2 kHz (bit=0).
Primeros ceros en ±1 kHz y ±3 kHz.
- Permite verificar la envolvente en banda base y entender por qué el ancho de cada lóbulo es \(2/𝑇=2kHz\)

2. `FSK_simulacion.m`

### Descripción
Este script genera una señal FSK real (dominio del tiempo) para una secuencia de 5 bits, y luego calcula su FFT para mostrar el espectro en el dominio de la frecuencia.

### Parámetros importantes
```bash
- `Rb = 1e3;`    % Tasa de bits = 1 kbit/s
- `T = 1 / Rb;`   % Duración de bit = 1 ms
- `DeltaF = 2e3;`  % Desviación de frecuencia = 2 kHz
- `fc = 100e3;`   % Frecuencia central = 100 kHz
- `fs = 1e6;`    % Frecuencia de muestreo = 1 MHz
- `N_bits = 5;`   % Número de bits a simular
- `bits = [1 0 1 1 0];` % Secuencia de bits ejemplo
```

### Salidas esperadas

- Figura “Señal FSK en el dominio del tiempo” (5 bits): Cosenos de 102 kHz durante bits=1 y cosenos de 98 kHz durante bits=0, con transiciones cada 1 ms.
- Figura “Espectro de la señal FSK (5 bits)”: Picos principales en ≈98 kHz y ≈102 kHz. Cada lóbulo cae a cero en ≈97 kHz y ≈103 kHz → ancho total ≈6 kHz.

### 5. GNU Radio Companion

- **`FSK_Transmisor.grc`**  
  *Descripción:*  
  Flowgraph de GNU Radio Companion que implementa un transmisor FSK binario. La señal modulante es un tren de pulsos (onda cuadrada) con frecuencia \( R_b = 1\,\text{kHz} \). Se utilizan bloques estándar para generar las portadoras en \( f_0 = 98\,\text{kHz} \) y \( f_1 = 102\,\text{kHz} \), y un bloque **Selector** que conmuta entre ellas en función del valor del pulso (0 o 1), produciendo así la señal FSK.

### Parámetros importantes:

```bash
- `samp_rate = 1e6`     % Frecuencia de muestreo: 1 MHz
- `Rb        = 1e3`     % Tasa de bits: 1 kHz
- `DeltaF    = 2e3`     % Desviación de frecuencia: 2 kHz
- `fc        = 100e3`   % Frecuencia central: 100 kHz
- `f1        = fc + DeltaF`   % → 102 kHz
- `f0        = fc - DeltaF`   % →  98 kHz
- `T         = 1.0 / Rb`      % → 1 ms
- `Ampl      = 1.0`           % Amplitud de portadoras
```

### Salida esperada

- QT GUI Time Sink: Portadora conmutando 98 kHz ↔ 102 kHz cada 1 ms.
- QT GUI Frequency Sink: Espectro en tiempo real con lóbulos a 98 kHz y 102 kHz.

---

### 6. Cómo Ejecutar

#### A. MATLAB

1. Abra **MATLAB** (o **GNU Octave**, si es compatible).

2. Cambie el directorio de trabajo a la carpeta `MATLAB/`.

3. Ejecute el script `FSK_envolvente.m`:

   ```matlab
   >> run('FSK_envolvente.m');

   Se abrirá una figura que muestra las dos envolventes espectrales (lóbulos tipo sinc desplazados a ±2 kHz) y sus ceros.

4. Ejecute el script `FSK_simulacion.m`:
    ```matlab
    >> run('FSK_simulacion.m');

    Se abrirá una figura con la señal FSK en el dominio del tiempo (para una secuencia de 5 bits).
    Luego, se abrirá otra figura que muestra el espectro (FFT) de la señal, con picos centrados en aproximadamente 98 kHz y 102 kHz, y un ancho total de banda estimado en ≈6 kHz.

#### B. GNU Radio Companion

1. Abra una terminal en Linux.

2. Navegue hasta la carpeta `GNU_Radio/`.

3. Ejecute el flowgraph con el siguiente comando:

   ```bash
   gnuradio-companion FSK_Transmisor.grc

4. Se abrirá el entorno de GNU Radio con el diagrama cargado. Haga clic en el botón ▶ (Run) para iniciar la simulación.

Al ejecutarse, se abrirán dos ventanas:

QT GUI Time Sink: muestra la conmutación de la portadora entre 98 kHz y 102 kHz, cambiando cada 1 ms (1 kHz).

QT GUI Frequency Sink: visualiza el espectro en tiempo real, con dos lóbulos centrados en 98 kHz y 102 kHz y un ancho total de ≈6 kHz.

---

### 7. Mapeo con Actividad de Laboratorio

| Ítem de la Actividad                                        | Archivo / Bloque                                         | Descripción                                                                                                 |
| ----------------------------------------------------------- | -------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| 1. Ecuación de ancho de banda FSK                           | —                                                        | Ver derivación en clase / README; resultado: $B = 2\,\Delta f + 2\,R_b$.                                    |
| 2. Envolvente compleja $g(t)$ para FSK                      | **`FSK_envolvente.m`**                                   | Define $g(t)$ en banda base y grafica sus lóbulos sinc desplazados a ±2 kHz.                                |
| 3. Gráfica FT de envolvente compleja                        | **`FSK_envolvente.m`**                                   | Muestra $\lvert G_1(f)\rvert$ y $\lvert G_0(f)\rvert$, con ceros en ±1 kHz y ±3 kHz.                        |
| 4. Simulación dominio tiempo (señal FSK de 5 bits)          | **`FSK_simulacion.m`**                                   | Genera la señal FSK en tiempo y grafica cosenos 98 kHz/102 kHz cada 1 ms.                                   |
| 5. Simulación espectro (FFT de señal FSK)                   | **`FSK_simulacion.m`**                                   | Calcula FFT de la señal (5 bits) y grafica su espectro, picos en ≈98 kHz/102 kHz, ancho ≈6 kHz.             |
| 6. Transmisor FSK en GNU Radio Companion                    | **`FSK_Transmisor.grc`**                                 | Flowgraph que implementa generador de pulso (1 kHz), portadoras 98 kHz/102 kHz y selector.                  |
| 7. Tiempo real (QT GUI Time Sink)                           | Bloque **QT GUI Time Sink** en `FSK_Transmisor.grc`      | Permite ver la conmutación instantánea entre 98 kHz y 102 kHz cada 1 ms.                                    |
| 8. Espectro en GRC (QT GUI Frequency Sink)                  | Bloque **QT GUI Frequency Sink** en `FSK_Transmisor.grc` | Permite medir visualmente los lóbulos en 98 kHz/102 kHz y sus ceros en 97 kHz/103 kHz (ancho total ≈6 kHz). |
| 9. Justificación ancho de banda con analizador de espectros | **QT GUI Frequency Sink** (o analizador SDR)             | Al mover cursor sobre ceros, se obtiene ancho ≈6 kHz, validando la ecuación teórica.                        |
