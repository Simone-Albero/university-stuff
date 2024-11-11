%% Frequency Analysis
clc
clear all
close all

%% Read Input Image
I = imread("cameraman.tif");

figure(1)
imshow(I, []);
title("Original Image");

%% Add Noise
I_noise = imnoise(I,"poisson");

figure(2)
imshow(I_noise, []);
title("Noise Image");

%% Low And High Frequencies

[low_f,high_f] = frequencies(I_noise);

figure(3);
imshowpair(low_f, high_f, "montage");
title("Image Low And High Frequencies")

%% High Frequencies Correction
value = max(max(high_f))/2;
new_high_f = high_f;

I_size = size(I_noise);
for i = 1:I_size(1)
    for j = 1:I_size(2)
        if new_high_f(i,j) < value
            new_high_f(i,j) = 0;
        end
    end
end

figure(4);
imshowpair(high_f, new_high_f, "montage");
title("High Frequencies Correction")

%% Low Frequencies Analysis

[low_f_2,high_f_2] = frequencies(low_f);

figure(5);
imshowpair(low_f_2, high_f_2, "montage");
title("Low Frequencies Analysis")

%% Low -> High Frequencies Correction
value = max(max(high_f_2))/2;
new_high_f_2 = high_f_2;

I_size = size(I_noise);
for i = 1:I_size(1)
    for j = 1:I_size(2)
        if new_high_f_2(i,j) < value
            new_high_f_2(i,j) = 0;
        end
    end
end

figure(6);
imshowpair(high_f_2, new_high_f_2, "montage");
title("Low -> High Frequencies Correction")

%% Another Correction

low_correction = imresize(low_f, 0.25);
low_correction = imresize(low_correction, 4, "bilinear");

I_result = low_correction + high_f;

figure(7);
imshowpair(I, I_result, "montage");
title("Another Correction")

