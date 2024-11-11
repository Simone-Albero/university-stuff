function [ratio] = compressionRatio(img)

info = imfinfo(img);
ratio = floor((info.Width*info.Height*info.BitDepth/8)/info.FileSize);

end