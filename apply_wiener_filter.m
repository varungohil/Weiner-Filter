function img_restored = apply_wiener_filter(invSNR_trained, H, img_noised_blurred_f);
%Calculates G_f by using Wiener filter formula
G_f = conj(H)./((abs(H).^2)+invSNR_trained);
%Computes the restored image in time domain after computing the restored
%image in frequency domain.
img_restored = ifft2(img_noised_blurred_f.*G_f);
return