clear all; close all; clc;
fs = 16000;
Ts = 1/fs;
f = 0:1:fs/2;
w = 2*pi*f;
z1 = 1*exp(1j*w*Ts);
z_real = real(z1);
z_imag = imag(z1);

n = 2; % Beispiel für die Filterordnung (diesen Wert anpassen, um andere Ordnungen zu testen)
[b] = fir1(n, 0.5);
[b,a] = cheby2(n,3,0.5);
a = [1]; % FIR-Filter haben keine Pole außer bei z=0
%!
%[z, p, k] = tf2zpk(b, a);
a11= 1
z = [-0 + 0*j 0 - 0*j]';
p = [ 0 +  0.999*j  0 -  0.999*j]';
[b,a] = zp2tf(z,p,1);
% Verbindung Pol-Nullstellen und Frequenzgang
D_zero = ones(1, length(z1));
D_poles = ones(1, length(z1));

for i = 1:length(z1)
    for k = 1:length(z)
        D_zero(i) = D_zero(i) * abs(z(k) - (z_real(i) + 1j*z_imag(i)));
    end
    for k = 1:length(p)
        D_poles(i) = D_poles(i) * abs(p(k) - (z_real(i) + 1j*z_imag(i)));
    end
    FrequencyResponseMAG(i) = D_zero(i) / D_poles(i);
end

% Berechnung der Frequenzgangsmagnitude in Dezibel
FrequencyResponseDB = 20 * log10(FrequencyResponseMAG);

% Plot der Magnitudenfrequenzantwort
figure;
plot(f, FrequencyResponseMAG);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Response Magnitude');
grid on;

% Berechnung der Frequenzgangsmagnitude mit freqz
[H, f_freqz] = freqz(b, a, 1000, fs);

% Plot der Frequenzantwort berechnet mit freqz
figure;
plot(f_freqz, 20 * log10(abs(H)));
grid on;
title('Frequency Response Calculated with freqz');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');

% Plot der Frequenzantwort berechnet mit Abstandsmethode
figure;
plot(f, FrequencyResponseDB);
grid on;
title('Frequency Response Calculated with Distance');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');

% Plot der Nullstellen-Pol-Plot
figure;
zplane(z, p);
title('Pole-Zero Plot');
