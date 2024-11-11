close all;
img = imread("../test_img/Baboon.bmp");

img = double(img);
bitPlanes = decToBin(img);
bitPlanes = bitPlanes * 255;
bitPlanes = uint8(bitPlanes);

figure 
for i = 1:8
    subplot(2, 4, i);
    imshow(bitPlanes(:, :, i));
    desc = sprintf('Bit Plane N%d', i);
    title(desc);
end

figure
subplot(1, 3, 1);
imshow(img, []);
title('Immagine Originale');

subplot(1, 3, 2);
secret = insertText(zeros(size(img)),[60 150],'SECRET','BoxOpacity',0,'FontSize',100,'TextColor','w');
secret = secret(:, : ,1);
imshow(secret);

title('Secret on Bit Plane 8');

subplot(1, 3, 3);
bitPlanes(:, :, 8) = secret;
bitPlanes = double(bitPlanes);
rec = binToDec(bitPlanes);
rec = rec / max(max(rec));
imshow(rec);

imwrite(rec, 'rec.jpg' , 'quality', 100);
title('Image reconstruction');

img = imread("rec.jpg");

img = double(img);
bitPlanes = decToBin(img);
bitPlanes = bitPlanes * 255;
bitPlanes = uint8(bitPlanes);

figure 
for i = 1:8
    subplot(2, 4, i);
    imshow(bitPlanes(:, :, i));
    desc = sprintf('Bit Plane N%d', i);
    title(desc);
end





