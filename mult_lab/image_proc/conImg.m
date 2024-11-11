function [out] = conImg(img,m,E)
out = 1./(1+(m./(double(img)+eps)).^E);
end