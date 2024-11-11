function [trans_I] = applyFilter(I,H)
    I_fft = fftshift(fft2(I));
    I_fft_fixed = I_fft .* H;
    trans_I = real(ifft2(ifftshift(I_fft_fixed)));
end