clc;
clear all;
close all;
%Read Input Retina Image
I = imread('C:\Users\user\Desktop\MY FINAL\image089.png');
k=rgb2gray(I);
figure,imshow(I);
p=im2double(k);
c = edge(p,'canny',0.4);
figure,imshow(c);
LEVEL=.610;
ky = im2bw(c,LEVEL);
figure,imshow(ky);
op=bwmorph(ky,'thick');%thikening
se = strel('disk',2);
BW = imclose(op,se);
figure, imshow(BW);
BW2 = bwareaopen(BW, 75);
figure, imshow(BW2);
O=BW-BW2;
imshow(O);
BWoutline = bwperim(O);
Segout = I; 
Segout(BWoutline) = 0; 
figure, imshow(Segout); title('outlined original image');

 