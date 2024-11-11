function [low,high] = frequencies(img)
filter = fspecial("gaussian", 3, 0.62);
low = imfilter(img, filter);
high = img-low;
end