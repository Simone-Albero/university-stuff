%% Spatial Filtering
clc
clear all
close all

%% Input Image
figure(1)
I = imread("../test_img/Lena.bmp");
imshow(I, []);
title("original image")

xlabel("u", "Interpreter","latex")
ylabel("v", "Interpreter","latex")

%% Average Filter
dim_filter = 6;
H_average = fspecial('average', dim_filter);

I_average = imfilter(I, H_average);

figure(2);
imshowpair(I, I_average, "montage");
title("Average Filter")

figure(3);
bar3(H_average);
title("Filter")

%% Custom Filter
H_custom = [0.0 0.5 0.0; 0.125 0.2 0.125; 0.0 0.5 0.0];
I_custom = imfilter(I, H_custom);

figure(4);
imshowpair(I, I_custom, "montage");
title("Custom Filter")

figure(5);
bar3(H_custom);
title("Custom Filter")

H_not_uniform = [3.0 0.0 0.0; 0.0 1.0 0.0; 0.0 0.0 3.0];
H_not_uniform = H_not_uniform ./ sum(sum(H_not_uniform));
I_not_uniform = imfilter(I, H_not_uniform);

figure(6);
imshowpair(I, I_not_uniform, "montage");
title("Not Uniform Filter")

figure(7);
bar3(H_not_uniform);
title("Not Uniform Filter")


%% Gaussian Filter
dim_filter = 9;
variance = 0.5;

H_gaussian = fspecial('gaussian', dim_filter, variance);
I_gaussian = imfilter(I, H_gaussian);

figure(8);
imshowpair(I, I_gaussian, "montage");
title("Gaussian Filter")

figure(9);
bar3(H_gaussian);
title("Gaussian Filter")

%% Rectangular Filter
H_width = 6;
H_height = 12;
variance = 2;

H_gaussian = fspecial('gaussian', [H_width H_height], variance);
I_gaussian = imfilter(I, H_gaussian);

figure(10);
imshowpair(I, I_gaussian, "montage");
title("Gaussian Rectangolar Filter")

figure(11);
bar3(H_gaussian);
title("Gaussian Rectangolar Filter")


%% Median Filter
density = 0.03;
I_noise = imnoise(I,'salt & pepper',density);

H_width = 2;
H_height = 2;
I_denoised = medfilt2(I_noise, [H_width, H_height]);

figure(12);
imshowpair(I_noise, I_denoised, "montage");
title("Median Filter")

%% Custom Noise

I_noise = I;
shape = size(I);
I_noise(floor(shape(1) / 2), :) = zeros(1, shape(1));
%I_noise(floor(shape(1) / 2)+2, :) = zeros(1, shape(1));

H_width = 3;
H_height = 3;
I_denoised = medfilt2(I_noise, [H_width, H_height]);

figure(13);
imshowpair(I_noise, I_denoised, "montage");
title("Median Filter")

%% Laplacian Filter
I = imread("../test_img/Luna.jpg");
alpha = 0.9;
c = 5;

H_laplac = fspecial('laplacian', alpha);
I_laplac = c * imfilter(I, H_laplac);

figure(14);
imshowpair(I, I_laplac, "montage");
title("Laplacian Filter")

figure(15);
bar3(H_laplac);
title("Laplacian Filter")

figure(16);
imshowpair(I, I - I_laplac, "montage");
title("Laplacian Filter")


%% Edge detector

threshold = []; %([0,1] or [] for automatic)
figure(17);
imshowpair(I, edge(I, 'Canny', threshold));
title("Image with Canny edge detector"); 

figure(18);
imshowpair(I, edge(I,"Prewitt",threshold));
title("Image with Prewitt edge detector"); 

figure(19);
imshowpair(I, edge(I, 'sobel', threshold));
title("Image with Sobel edge detector"); 









