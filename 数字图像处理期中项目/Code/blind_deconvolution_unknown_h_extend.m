%��ͼ
x = imread('cross.png');
if(size(x,3)==3),x=rgb2gray(x);x=double(x);end % ��rgbͼƬתΪ�Ҷ�ͼƬ��תΪ˫����
if(size(x,1)~=size(x,2)),x=x(1:min(size(x,1),size(x,2)),1:min(size(x,1),size(x,2))); end %ֻ����������ͼ��
x = x(:, :, 1) / max(x(:));
n = size(x, 1);
X = fft2(x);

%����չ����h����˹ƽ��
blur_sigma = 6;
h = fspecial('gaussian', size(x, 1), blur_sigma);
h = h / sum(h(:));
H = fft2(h);

%����˹ƽ������õ���ͼ��
Y = X .* abs(H);
y = ifft2(Y);
y = abs(y);
% Process = imfilter(x,h);
% y = imnoise(Process,'gaussian',0,0.001);

%��Ե��չ
[N1,N2]=size(y);
M1=127;
M2=127;
m1=(M1-1)/2;
m2=(M1-1)/2;
 
yy=zeros(N1+2*m1,N2+2*m2);
yy(m1+1:m1+N1,m2+1:m2+N2)=y;

for i=1:m1
    yy(i,:)=2*yy(m1+1,:)-yy(m1+1+i,:);
    yy(i+m1+N1,:)=2*yy(m1+N1,:)-yy(m1+N1-i,:);
end
for i=1:m2
    yy(:,i)=2*yy(:,m2+1)-yy(:,m2+1+i);
    yy(:,i+m2+N2)=2*yy(:,m2+N2)-yy(:,m2+N2-i);
end

%����չ������ʼ����
blur_sigma_hat = 1.5 * blur_sigma;
h_hat = fspecial('gaussian', size(yy, 1), blur_sigma_hat);
h_hat = h_hat / sum(h_hat(:));
h0 = h_hat;

lucy_iterations = 7;

%�������̣�����h��x
iterations = 20;
for k=1:iterations
    % Optimize for x_hat. These values can be treated as a black box; we can
    % swap any of the out (makes sense by looking at the input/outputs)
    x_hat = deconvlucy(yy, h_hat, lucy_iterations);
    %x_hat = deconvwnr(y, h_hat);
    %x_hat = deconvreg(y, h_hat);

    % Estimate H. Richardson-Lucy doesn't make any assumptions about the form of
    % the equation and X and H are interchangable. It goes of the Fourier
    % tranfrom representation.
    h_hat = deconvlucy(yy, x_hat, lucy_iterations);
end

%���л�ԭͼ��С
RECT=[m1+1,m2+1,N2-1,N1-1];
x_hat = imcrop(x_hat,RECT);

% show results
subplot(2,3,1)
imshow(x),title('ԭʼͼ��');
subplot(2,3,2)
imshow(y),title('��˹ƽ��ͼ��');
subplot(2,3,3)
imshow(x_hat),title('ԭʼͼ�����չ���ֵ');
subplot(2,3,4)
imagesc(h);
colormap gray
colorbar
title('����չ����');
subplot(2,3,5)
imagesc(h0)
colormap gray
colorbar
title('����չ������ʼ����ֵ');
subplot(2,3,6)
imagesc(h_hat)
colormap gray
colorbar
title('����չ�������չ���ֵ');

evaluate = norm(x-y,'fro');
fprintf("Before:%f\n",evaluate);
evaluate = norm(x-x_hat,'fro');
fprintf("After:%f\n",evaluate);
