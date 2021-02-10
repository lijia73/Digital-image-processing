clear

Image = im2double(rgb2gray(imread('cat1.png')));
H = fspecial('gaussian',7,10);
V = 0.0001;

x=Image;
[N1,N2]=size(x);
M1=127;
M2=127;
m1=(M1-1)/2;
m2=(M1-1)/2;
 
%f(1-j)=2f(1)-f(1+j)
%f(n+j)=2f(n)-f(n-j)
ImageA=zeros(N1+2*m1,N2+2*m2);
ImageA(m1+1:m1+N1,m2+1:m2+N2)=x;

for i=1:m1
    ImageA(i,:)=2*ImageA(m1+1,:)-ImageA(m1+1+i,:);
    ImageA(i+m1+N1,:)=2*ImageA(m1+N1,:)-ImageA(m1+N1-i,:);
end
for i=1:m2
    ImageA(:,i)=2*ImageA(:,m2+1)-ImageA(:,m2+1+i);
    ImageA(:,i+m2+N2)=2*ImageA(:,m2+N2)-ImageA(:,m2+N2-i);
end

figure,imshow(Image),title('原始图像');
Process = imfilter(ImageA,H);

figure,imshow(Process),title('经过高斯模糊后的图像');
WeightMatrix = zeros(size(Process));
WeightMatrix(5:end-1,5:end-4)=1;

RL1 = deconvlucy(Process,H,10,sqrt(V),WeightMatrix);
RL2 = deconvlucy(Process,H,100,sqrt(V),WeightMatrix);
RL3 = deconvlucy(Process,H,1000,sqrt(V),WeightMatrix);

RECT=[m1+1,m2+1,N2-1,N1-1];
CutImage1 = imcrop(RL1,RECT);
CutImage2 = imcrop(RL2,RECT);
CutImage3 = imcrop(RL3,RECT);

a=norm(Image-CutImage1,'fro');
b=norm(Image-CutImage2,'fro');
c=norm(Image-CutImage3,'fro');


figure,imshow(CutImage1),title('10次迭代');
figure,imshow(CutImage2),title('100次迭代');
figure,imshow(CutImage3),title('1000次迭代');


fprintf("经过10次迭代和原图的差距：%d\n",a);
fprintf("经过100次迭代和原图的差距：%d\n",b);
fprintf("经过1000次迭代和原图的差距：%d\n",c);



