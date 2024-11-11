%% Image Processing
clc
clear all
close all

%% Image Compression Ratio
I = imread("../test_img/Baboon.bmp");

imwrite(I, 'Baboon.jpg' , 'quality', 100);
compressionRatio('Baboon.jpg')

%% Image Histogram Plot
gray_count = zeros(256,1);
for gray_value = 0:255
    res = size(find(I == gray_value),1);
    gray_count(gray_value + 1) = res;
end

figure(1);
bar(gray_count);

figure(2);
n=imhist(I);
bar(n);
axis([0 255 0 max(n)]);

%% Image Negative
I_neg = negImg(I, 256);

for quality=10:10:100
    I_name = sprintf('Neg/neg%d.jpg', quality);
    imwrite(I_neg, I_name , 'quality', quality);
end

figure(3);
imshowpair(imread("Neg/neg100.jpg"), imread("Neg/neg10.jpg"), "montage");
title("Negative Compression")

%% Power Transform
figure(4);
I_pot = potImg(I, 0, 1, 5.0);

imshowpair(I, I_pot, "montage");
title("Power Transform")

%% Log Transform
I_log = logImg(I, 1);

imshowpair(I, I_log, "montage");
title("Log Transform")

%% Contrast transform
I_con = conImg(I, 60, 5);

imshowpair(I, I_con, "montage");
title("Contrast Transform")



