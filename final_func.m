clc;
clf;
clear all;

%Set the below variable to the path of directory named bwdataset
dataset_dir = 'bwdataset/';

%Set test_img to name of image you want to test.
test_img = '48.gif';

%The mean and variance of noise are specified
noise_mean = 0;
noise_variance = 0.01;

%Trains the images to find the invSNR value.
invSNR_trained=train_for_SNR(noise_mean, noise_variance, dataset_dir);


%%
%Reads the test image
img_orig=im2double(imread(strcat(dataset_dir,test_img)));
% Finds the dimensions of image
[r,c]=size(img_orig);

%Makes the blur kernel and convolves it with the test image. 
blur_kernel=fspecial('gaussian',[5 5],5);
img_blurred=imfilter(img_orig,blur_kernel,'conv','symmetric');

%Adds additive Gaussian noise
img_noised_blurred = imnoise(img_blurred,'gaussian',noise_mean,noise_variance);

%Find H i.e blur_kernel in frequency domain
H=fft2(blur_kernel,r,c);

%Found the noised and blurred image in frequency domain
img_noised_blurred_f=fft2(img_noised_blurred);

%Applies wiener filter to the test image and gets the restored image
img_restored = apply_wiener_filter(invSNR_trained, H, img_noised_blurred_f);

%Shows the original, coruppted and restored images in a seperate window
subplot(3,1,1)
imshow(img_orig)
title("Original Image")
subplot(3,1,2)
imshow(img_noised_blurred)
title("Noisd and Blurred Image")
subplot(3,1,3)
imshow(img_restored)
title("Restored Image")
%%
%Calculates and displays the PSNR for both coruppted and restored image.
psnrval = psnr(img_noised_blurred,img_orig);
disp("PSNR Noisy")
disp(psnrval)

psnrval = psnr(img_restored,img_orig);
disp("PSNR Restored")
disp(psnrval)