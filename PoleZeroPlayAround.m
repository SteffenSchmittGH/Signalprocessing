clc; clear all; close all;
fs = 16000;
Ts = 1/fs;
f = 0:250:fs/2;
w = 2*pi*f;
z1 = 1*exp(1*j*w*Ts);
z_real = real(z1);
z_imag = imag(z1);
[b] = fir1(2,0.5);
%[b,a] = cheby2(2,3,0.5);
a = [1];
[z,p,k] = tf2zpk(b,a);
%Connection PoleZero & FreqResponse
for i = 1:length(z1)
    difference_1 = z(1) - (z_real(i) + j*z_imag(i));
    difference_2 = z(2) - (z_real(i) + j*z_imag(i));
    difference_3 = p(1) - (z_real(i) + j*z_imag(i));
    difference_4 = p(2) - (z_real(i) + j*z_imag(i));
    D_zero(i) = abs(difference_1)*abs(difference_2);
    D_poles(i) = abs(difference_3)*abs(difference_4);
    FrequencyResponseMAG(i) = D_zero(i)/D_poles(i);
end
FrequencyResponseDB = 20*log10(FrequencyResponseMAG);
[H,f] = freqz(b,a,1000,fs);
figure
zplane(z,p);
figure
plot(f,20*log10(abs(H)));
grid on
title('Frequency Response Calculated with freqz')
figure
plot(FrequencyResponseDB)
grid on
title('Frequency Response Calculated with Distance')