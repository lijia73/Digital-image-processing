clear

Image = im2double(rgb2gray(imread('cat1.png')));
figure,imshow(Image),title('ԭʼͼ��');
H = fspecial('gaussian',7,10);
V = 0.0001;
Process = imfilter(Image,H);

WeightMatrix = zeros(size(Image));
WeightMatrix(5:end-1,5:end-4)=1;

RL1 = deconvlucy(Process,H,10,sqrt(V),WeightMatrix);
RL2 = deconvlucy(Process,H,50,sqrt(V),WeightMatrix);
RL3 = deconvlucy(Process,H,100,sqrt(V),WeightMatrix);


a=norm(Image-RL1,'fro');
b=norm(Image-RL2,'fro');
c=norm(Image-RL3,'fro');


figure,imshow(RL1),title('10�ε���');
figure,imshow(RL2),title('50�ε���');
figure,imshow(RL3),title('100�ε���');


fprintf("����10�ε�����ԭͼ�Ĳ�ࣺ%d\n",a);
fprintf("����50�ε�����ԭͼ�Ĳ�ࣺ%d\n",b);
fprintf("����100�ε�����ԭͼ�Ĳ�ࣺ%d\n",c);
