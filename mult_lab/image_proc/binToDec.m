function [dec] = binToDec(bin)
shape = size(bin);
dec = zeros(shape(1:end-1));

for i= 8:-1:1
    dec = dec + 2^(8-i) * bin(:, :, i);
end
end