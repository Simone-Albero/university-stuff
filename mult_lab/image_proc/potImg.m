function [out] = potImg(img, low_out, high_out, gamma)

low_in = double(min(min(img)) / 255);
high_in = double(max(max(img)) / 255);

inParams = [low_in, high_in];
outParams = [low_out, high_out];

out = imadjust(img, inParams, outParams, gamma);
end