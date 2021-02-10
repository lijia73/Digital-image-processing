
Image = im2double(rgb2gray(imread('cross.png')));
PSF = fspecial('gaussian',7,10);
V = 0.0001;
Process = imfilter(Image,PSF);
ProcessedImage = imnoise(Process,'gaussian',0,V);
%WEIGHT = edge(ProcessedImage,'sobel',.08);
WeightMatrix = zeros(size(Image));
WeightMatrix(5:end-1,5:end-4)=1;
% se = strel('disk',2);
% WEIGHT = 1-double(imdilate(WEIGHT,se));
% WEIGHT([1:3 end-(0:2)],:) = 0;
% WEIGHT(:,[1:3 end-(0:2)]) = 0;

INITPSF = ones(size(PSF));
[J P] = deconvblind(ProcessedImage,INITPSF,20,10*sqrt(V),WeightMatrix);

subplot(2,3,1)
imshow(Image),title('原始图像');
subplot(2,3,2)
imshow(ProcessedImage),title('高斯平滑图像');
subplot(2,3,3)
imshow(J),title('原始图像最终估计值');
subplot(2,3,4)
imagesc(PSF)
colormap gray
colorbar
title('点扩展函数');
subplot(2,3,5)
imagesc(INITPSF)
colormap gray
colorbar
title('点扩展函数初始估计值');
subplot(2,3,6)
imagesc(P)
colormap gray
colorbar
title('点扩展函数最终估计值');


evaluate = norm(Image-ProcessedImage,'fro');
fprintf("Before:%f\n",evaluate);
evaluate = norm(Image-J,'fro');
fprintf("After:%f\n",evaluate);