%% Wavelet Transform
clc
clear all
close all

%% Read Input Image
I = imread("../test_img/Barbara.bmp");

figure(1)
imshow(I);
title("Original Image");

I = double(I);

%% Wavelet Transform

[LL, LH, HL, HH] = dwt2(I, "haar");

%% Wavelet Inverse Transform
I_inv = idwt2(LL, LH, HL, HH, "haar");

figure(2)
imshowpair(I, I_inv, "montage");
title("Image From Wavelet Transform");

%% HH Peak signal-to-noise ratio
noise = zeros(size(HH));

I_noised = idwt2(LL, LH, HL, noise, "haar");
[peak,snr] = psnr(I, I_noised)

figure(3)
imshowpair(I, I_noised, "montage");
title("HH Noised");

%% LH And HL Peak signal-to-noise ratio
noise = zeros(size(HH));

I_noised = idwt2(LL, noise, noise, HH, "haar");
[peak,snr] = psnr(I, I_noised)

figure(4)
imshowpair(I, I_noised, "montage");
title("LH And HL Noised");

%% LL Peak signal-to-noise ratio
noise = zeros(size(HH));

I_noised = idwt2(noise, LH, HL, HH, "haar");
[peak,snr] = psnr(I, I_noised)

figure(5)
imshowpair(I, I_noised, "montage");
title("LL Noised");

%% LH, HL And HH Peak signal-to-noise ratio
noise = zeros(size(HH));

I_noised = idwt2(LL, noise, noise, noise, "haar");
[peak,snr] = psnr(I, I_noised)

figure(6)
imshowpair(I, I_noised, "montage");
title("LH, HL And HH Noised");

%% Simple Threshold
TH_LL = threshold(LL);
TH_HH = threshold(HH);
TH_LH = threshold(LH);
TH_HL = threshold(HL);

I_noised = idwt2(TH_LL, TH_HH, TH_LH, TH_HL, "haar");
[peak,snr] = psnr(I, I_noised)

figure(7)
imshowpair(I, I_noised, "montage");
title("Simple Threshold");

%% AVG Threshold
AVG_LL = avgThreshold(LL);
AVG_HH = avgThreshold(HH);
AVG_LH = avgThreshold(LH);
AVG_HL = avgThreshold(HL);

I_noised = idwt2(AVG_LL, AVG_HH, AVG_LH, AVG_HL, "haar");
[peak,snr] = psnr(I, I_noised)

figure(8)
imshowpair(I, I_noised, "montage");
title("Avg Threshold");

%% HH Pollution
pollution = double(imresize(imread("../test_img/Baboon.bmp"), 0.5, "bilinear"));

figure(9)
imshow(idwt2(LL, LH, HL, HH+pollution, "haar"), []);
title("HH Pollution");

%% HL Pollution
pollution = double(imresize(imread("../test_img/Baboon.bmp"), 0.5, "bilinear"));

figure(9)
imshow(idwt2(LL, LH, HL+pollution, HH, "haar"), []);
title("HL Pollution");

%% LH Pollution
pollution = double(imresize(imread("../test_img/Baboon.bmp"), 0.5, "bilinear"));

figure(9)
imshow(idwt2(LL, LH+pollution, HL, HH, "haar"), []);
title("LH Pollution");

%% LL Pollution
pollution = double(imresize(imread("../test_img/Baboon.bmp"), 0.5, "bilinear"));

figure(9)
imshow(idwt2(LL+pollution, LH, HL, HH, "haar"), []);
title("LL Pollution");

%% Level 2 Wavelet Transform
[LL2, LH2, HL2, HH2] = dwt2(LL, "haar");

%% HH2 Peak signal-to-noise ratio
noise2 = zeros(size(HH2));
LL_noised = idwt2(LL2, LH2, HL2, noise2, "haar");

I_noised = idwt2(LL_noised, LH, HL, HH, "haar");
[peak,snr] = psnr(I, I_noised)

figure(10)
imshowpair(I, I_noised, "montage");
title("HH2 Noised");

%% HL2 And LH2 Peak signal-to-noise ratio
noise2 = zeros(size(HH2));
LL_noised = idwt2(LL2, noise2, noise2, HH2, "haar");

I_noised = idwt2(LL_noised, LH, HL, HH, "haar");
[peak,snr] = psnr(I, I_noised)

figure(11)
imshowpair(I, I_noised, "montage");
title("HL2 And LH2 Noised");

%% LL Peak signal-to-noise ratio
noise2 = zeros(size(HH2));
LL_noised = idwt2(noise2, LH2, HL2, HH2, "haar");

I_noised = idwt2(LL_noised, LH, HL, HH, "haar");
[peak,snr] = psnr(I, I_noised)

figure(12)
imshowpair(I, I_noised, "montage");
title("LL Noised");

%% HH2, LH2 And HL2 Peak signal-to-noise ratio
noise2 = zeros(size(HH2));
LL_noised = idwt2(LL2, noise2, noise2, noise2, "haar");

I_noised = idwt2(LL_noised, LH, HL, HH, "haar");
[peak,snr] = psnr(I, I_noised)

figure(13)
imshowpair(I, I_noised, "montage");
title("HH2, LH2 And HL2 Noised");
