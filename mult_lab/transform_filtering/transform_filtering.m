%% Transform Filtering
clc
clear all
close all

%% Read Input Image
figure(1)
I = imread("cameraman.tif");
imshow(I, []);
I = double(I);
title("Original Image");

%% FFT
I_fft = fft2(I);
fft_module = abs(I_fft);
fft_phase = angle(I_fft);

figure(2);
imshowpair(fft_module, fft_phase, "montage");
title("FFT Module And Phase")

%% FFT Log
I_fft = fft2(I);
fft_module = abs(I_fft);
fft_phase = angle(I_fft);

fft_module_log = log(1 + fft_module);
fft_module_phase = log(1 + fft_phase);

figure(3);
imshowpair(fft_module_log, fft_module_phase, "montage");
title("FFT Log Module And Phase")

%% FFT Shift
I_fft = fft2(I);
fft_module = abs(I_fft);
fft_phase = angle(I_fft);

fft_module_log = log(1 + fft_module);
fft_shifted_module = fftshift(fft_module_log);

figure(4);
imshowpair(fft_module_log, fft_shifted_module, "montage");
title("FFT Shifted Module")

%% Ideal LP Filter
I_fft = fft2(I);
fft_module = abs(I_fft);
fft_phase = angle(I_fft);

fft_module_log = log(1 + fft_module);
fft_shifted_module = fftshift(fft_module_log);

sz = size(I_fft);
dist = 35;
dist_matrix = distmatrix(sz(1), sz(2));

H_LP = dist_matrix <= dist;
H_LP_shifted = fftshift(H_LP);

figure(4);
imshowpair(fft_shifted_module, H_LP_shifted, "montage");
title("LP Filter")

I_LP = fft_shifted_module .* H_LP_shifted;

figure(5);
imshowpair(fft_shifted_module, I_LP, "montage");
title("LP Filter")

figure(6);
I_LP = applyFilter(I, H_LP_shifted);
imshowpair(I, I_LP, "montage");
title("LP Filter")

%% Gaussian LP Filter
I_fft = fft2(I);
fft_module = abs(I_fft);
fft_phase = angle(I_fft);

fft_module_log = log(1 + fft_module);
fft_shifted_module = fftshift(fft_module_log);

sz = size(I_fft);
dist_matrix = distmatrix(sz(1), sz(2));

sigma = 30; 
H_gau = exp(-(dist_matrix.^2) / (2*(sigma^2)));
H_gau_shifted = fftshift(H_gau);

figure(7);
imshowpair(fft_shifted_module, H_gau_shifted, "montage");
title("Gaussian LP Filter")

figure(8);
I_LP = applyFilter(I, H_gau_shifted);
imshowpair(I, I_LP, "montage");
title("Gaussian LP Filter")

%% Butterworth LP Filter
I_fft = fft2(I);
fft_module = abs(I_fft);
fft_phase = angle(I_fft);

fft_module_log = log(1 + fft_module);
fft_shifted_module = fftshift(fft_module_log);

sz = size(I_fft);
dist_matrix = distmatrix(sz(1), sz(2));

n = 3;
D0 = 35;

H_but = 1./(1+(dist_matrix./D0).^(2*n));
H_but_shifted = fftshift(H_but);

figure(7);
imshowpair(fft_shifted_module, H_but_shifted, "montage");
title("Butterworth LP Filter")

figure(8);
I_LP = applyFilter(I, H_but_shifted);
imshowpair(I, I_LP, "montage");
title("Butterworth LP Filter")

%% Ideal HP Filter
I_fft = fft2(I);
fft_module = abs(I_fft);
fft_phase = angle(I_fft);

fft_module_log = log(1 + fft_module);
fft_shifted_module = fftshift(fft_module_log);

sz = size(I_fft);
dist = 35;
dist_matrix = distmatrix(sz(1), sz(2));

H_LP = dist_matrix <= dist;
H_LP_shifted = fftshift(H_LP);
H_HP_shifted = 1 - H_LP_shifted;

figure(9);
imshowpair(fft_shifted_module, H_HP_shifted, "montage");
title("HP Filter")

figure(10);
I_HP = applyFilter(I, H_HP_shifted);
imshowpair(I, I_HP, "montage");
title("HP Filter")

%% Gaussian HP Filter
I_fft = fft2(I);
fft_module = abs(I_fft);
fft_phase = angle(I_fft);

fft_module_log = log(1 + fft_module);
fft_shifted_module = fftshift(fft_module_log);

sz = size(I_fft);
dist_matrix = distmatrix(sz(1), sz(2));

sigma = 30; 
H_gau = exp(-(dist_matrix.^2) / (2*(sigma^2)));
H_gau_shifted = fftshift(H_gau);
H_gau_shifted = 1 - H_gau_shifted;

figure(11);
imshowpair(fft_shifted_module, H_gau_shifted, "montage");
title("Gaussian HP Filter")

figure(12);
I_LP = applyFilter(I, H_gau_shifted);
imshowpair(I, I_LP, "montage");
title("Gaussian HP Filter")

%% Butterworth HP Filter
I_fft = fft2(I);
fft_module = abs(I_fft);
fft_phase = angle(I_fft);

fft_module_log = log(1 + fft_module);
fft_shifted_module = fftshift(fft_module_log);

sz = size(I_fft);
dist_matrix = distmatrix(sz(1), sz(2));

n = 3;
D0 = 35;

H_but = 1./(1+(dist_matrix./D0).^(2*n));
H_but_shifted = fftshift(H_but);
H_but_shifted = 1 - H_but_shifted;

figure(7);
imshowpair(fft_shifted_module, H_but_shifted, "montage");
title("Butterworth HP Filter")

figure(8);
I_LP = applyFilter(I, H_but_shifted);
imshowpair(I, I_LP, "montage");
title("Butterworth HP Filter")


