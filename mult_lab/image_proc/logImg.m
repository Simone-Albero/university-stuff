function [out] = logImg(img, c)
maxVal = double(max(max(img)));
img = double(img)/maxVal;
out = uint8(maxVal*c*log10(1+9*img));
end