%% Audio Processing
clc
clear all
close all

%% Loading Audio Sample
[y, fs] = audioread("sample/audio1.wav"); %fs: audio, sampling sequence

if size(y, 2) == 2
    y = mean(y,2);
end

figure(1)
time_axis = (1:length(y))./fs;
plot(time_axis, y);
title("Audio waveform");
ylabel("Aplitude");
xlabel("Time in second");

%% PLay the audio
player = audioplayer(y, fs);
play(player);

%% FFT
figure(2)
Nfft = 2048;
y_fft = abs(fftshift(fft(y, Nfft))).^2/Nfft;
f_vector = (-Nfft/2:Nfft/2-1)*(fs/Nfft);
plot(f_vector, y_fft)
title("Power Spectrum");
ylabel("|x(f)|");
xlabel("Hz");

%% STFT
figure(3)
stft(y, fs, Window=kaiser(1024,5), OverlapLength=512, FFTLength=1024, FrequencyRange="onesided")

%% Reverse
y_rev = flipud(y);
player = audioplayer(y_rev, fs);
play(player);

%% Ampl
y_ampl = y*2;
player = audioplayer(y_ampl, fs);
play(player);

%% Record
Fs = 44100; 
nBits = 16; 
nChannels = 1; 
recObj = audiorecorder(Fs,nBits,nChannels);

disp("Begin speaking.")
recDuration = 5;
recordblocking(recObj,recDuration);
disp("End of recording.")

play(recObj);

