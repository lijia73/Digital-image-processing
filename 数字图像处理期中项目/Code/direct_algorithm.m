% read the original image and display

input_image = imread('cat1.png');
input_image = rgb2gray(input_image);
input_image = im2double(input_image);
figure;
imshow(input_image);
title('Original Input Image');

% Apply Gaussian blur (7*7 size with sigma = 10) to the image and display blurred image

actual_psf = fspecial('Gaussian',7,10);
blurred_image = imfilter(input_image,actual_psf,'conv','circular');
figure;
imshow(blurred_image);
title('Gaussian Blurred Image');

% Estimate The PSF Function and display 

k = 0.00000025;
blurred_Fourier = fft2(blurred_image);
blurred_Fourier = fftshift(blurred_Fourier);
blurred_Fourier_Spectrum = log(1+abs(blurred_Fourier));
figure;
imshow(blurred_Fourier_Spectrum);
title('The Spectrum For Blurred Image');

estimate_psf_fourier = zeros(size(blurred_Fourier));
for i = 1 : size(estimate_psf_fourier,1)
    for j = 1 : size(estimate_psf_fourier,2)
        temp = ((i)^2+(j)^2)^(5/6.0);
        expo = -1*k*temp;
        estimate_psf_fourier(i,j) = exp(expo);
    end
end
estimate_psf_fourier = fftshift(estimate_psf_fourier);
estimate_psf_spectrum = log(1+abs(estimate_psf_fourier));
figure;
imshow(estimate_psf_spectrum);
title('The Spectrum For Estimated PSF');

% Using Frequency Domain Division To Get Original Image

deblurred_image_fourier = blurred_Fourier ./ estimate_psf_fourier;

% Perform Inverse Fourier 

deblurred_image_fourier = ifftshift(deblurred_image_fourier);
deblurred_image = real(ifft2(deblurred_image_fourier));
figure;
imshow(deblurred_image);
title('The Deblurred Image');

% Evaluate the performance

a=norm(input_image-deblurred_image,'fro');
c=norm(blurred_image-input_image,'fro');
fprintf("Before:%f\n",c);
fprintf("After:%f\n",a);





