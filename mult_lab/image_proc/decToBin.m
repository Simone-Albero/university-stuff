function [bin] = decToBin(dec)
shape = size(dec);
shape = [shape 8];

bin = zeros(shape);

for i= 8:-1:1
    bin(:, :, i) = mod(dec,2);
    dec = floor(dec / 2);
end
end