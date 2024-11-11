%% Jpeg Coding
clc
clear all
close all

%% Read Input Image
I = imread("peppers.png");

figure(1)
imshow(I);
title("Original Image");

%% RGB -> YCbCr Conversion
ycbcr = rgb2ycbcr(I);

y = ycbcr(:, :, 1) - 128;
cb = ycbcr(:, :, 2) - 128;
cr = ycbcr(:, :, 3) - 128;

%% Under sampling

cb = cb(1:4:end, 1:4:end);
cr = cr(1:4:end, 1:4:end);

%% Block splitting and DCT

dct2_block = @(block_struct) dct2(block_struct.data);

y_DC = blockproc(y, [8 8], dct2_block);
cb_DC = blockproc(cb, [8 8], dct2_block);
cr_DC = blockproc(cr, [8 8], dct2_block);

%% Block quantizzation

quantization_matrix_luminance = [[16 11 10 16 24 40 51 61];
                                [12 12 14 19 26 58 60 55];
                                [14 13 16 24 40 57 69 56];
                                [14 17 22 29 51 87 80 62];
                                [18 22 37 56 68 109 103 77];
                                [24 35 55 64 81 104 113 92];
                                [49 64 78 87 103 121 120 101];
                                [72 92 95 98 112 100 103 99]];

quantization_matrix_crominance = [[17 18 24 47 99 99 99 99]; 
                                [18 21 26 66 99 99 99 99]; 
                                [24 26 56 99 99 99 99 99]; 
                                [47 66 99 99 99 99 99 99]; 
                                [99 99 99 99 99 99 99 99]; 
                                [99 99 99 99 99 99 99 99]; 
                                [99 99 99 99 99 99 99 99]; 
                                [99 99 99 99 99 99 99 99]];

ew_divide = @(x, y) x ./ y;

luminance_quantizzation = @(block_struct) ew_divide(block_struct.data, quantization_matrix_luminance);
crominance_quantizzation = @(block_struct) ew_divide(block_struct.data, quantization_matrix_crominance);


y_DC = blockproc(y_DC, [8 8], luminance_quantizzation);
cb_DC = blockproc(cb_DC, [8 8], crominance_quantizzation);
cr_DC = blockproc(cr_DC, [8 8], crominance_quantizzation);

%% Run Length Encoding
Y_size = size(y_DC);
high = Y_size(1);
width = Y_size(2);

prev_y = 0;

f_path = fopen('jpg.txt', 'a');

for i = 1:8:high
    for j = 1:8:width
        y_block = y_DC(i:i+7, j:j+7);
        y_zigzag = zigzag(y_block);
           
        tmp = y_zigzag(1, 1);
        y_zigzag(1, 1) = y_zigzag(1, 1) - prev_y;
        prev_y = tmp;

        y_run_length = rle(y_zigzag);

        fprintf(f_path, '%s Y\n', num2str(y_run_length));
    end
end

CB_size = size(cb_DC);
high = CB_size(1);
width = CB_size(2);

prev_cb = 0; 
prev_cr = 0;

for i = 1:8:high
    for j = 1:8:width
        cb_block = cb_DC(i:i+7, j:j+7);
        cb_zigzag = zigzag(cb_block);

        cr_block = cr_DC(i:i+7, j:j+7);
        cr_zigzag = zigzag(cr_block);
           
        tmp = cb_zigzag(1, 1);
        cb_zigzag(1, 1) = cb_zigzag(1, 1) - prev_cb;
        prev_cb = tmp;

        cb_run_length = rle(cb_zigzag);

        tmp = cr_zigzag(1, 1);
        cr_zigzag(1, 1) = cr_zigzag(1, 1) - prev_cr;
        prev_cr = tmp;

        cr_run_length = rle(cr_zigzag);

        fprintf(f_path, '%s CB\n', num2str(cb_run_length));
        fprintf(f_path, '%s CR\n', num2str(cr_run_length));
    end
end

