function invSNR_trained = train_for_SNR(noise_mean, noise_variance, dataset_dir);
%This function trains over 35 images and computes the average value of
%invSNR. It returns this average value of invSNR which is then used while
%testing images.
invSNR_trained=zeros(512,512);
for i=1:35
    img=im2double(imread(strcat(dataset_dir,int2str(i),'.gif')));
    %Finds the image in frequency domain
    img_f = fft2(img, 512, 512);
    %Finds the noise and computes in frequency domain
    noise=imnoise(img,'gaussian',noise_mean,noise_variance)-img;
    noise_f=fft2(noise);
    %Computes (N^2)/(S^2) for each image.
    invSNR_trained = invSNR_trained +(abs(noise_f).^2)./(abs(img_f).^2);
end
%Calculates average of all calculated invSNR.
invSNR_trained=invSNR_trained/35;
return