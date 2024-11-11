function [neg] = negImg(img, grayLevels)

img = double(img);

neg = grayLevels - 1 - img;
neg(neg < 0) = 0;
neg(neg > grayLevels - 1) = grayLevels - 1;

neg = uint8(neg);

end