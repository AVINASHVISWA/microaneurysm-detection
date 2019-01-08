
clc;
clear all;
close all;
%%%%%%%%%%%%%%%%%%%%  Read Input Retina Image  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% I = imread('C:\Users\user\Desktop\MY FINAL\final program\image034.png');
% figure,imshow(I);
% title('Input image');

myFolder='E:\Avinash\MY FINAL\final program\HELTHY\';
filePattern = fullfile(myFolder, '*.jpg');
jpegFiles = dir(filePattern);

    for i=1:length(jpegFiles)
        
         baseFileName = jpegFiles(i).name;
         fullFileName = fullfile(myFolder, baseFileName);
         I= imread(fullFileName);

k=I(:,:,2);                         %%%%%%%Green channel conversion
figure,imshow(k);
title('Green channel image');
y=k;

%%%%%%%%%%%%%%%%%%%%%%%%Invert the green channel%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isinteger(y)
    G = intmax(class(y))-y;
elseif isfloat(y)        
    G = 1 - y;
elseif islogical(y)
    G = ~y;
else
    error('Strange image you''ve got there...');
end
figure,imshow(G);
title('inverted_ Green');

%%%%%%%%%%%%%%%%%%%%%%%%%% Pre-Processing Steps %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%% Illumination Equalization %%%%%%%%%%%%%%%%%%%%%%%%%


[~, c]=size(G);

h = fspecial('average',[51,51]);          %%%%%%%% Average filtering %%%%%% 
Ib=imfilter(G,h);
figure,imshow(Ib);
title('Avg filtered_Image');
D=abs(G-Ib);                              %%%    Backgroud seperation   %%%
figure,imshow(D);
title('Difference_Image');
B_value=255-max(max(D));
Q=D+B_value;
figure,imshow(Q);
title('Illumination_equ_Image');

%%%%%%%%%%%%%%%%%%%%%     Candidate Extraction    %%%%%%%%%%%%%%%%%%%%%%%%% 

p=im2double(Q);
c = edge(p,'canny',0.3);        %%%%%%%%%%%  Edge Detection  %%%%%%%%%%%%%%
figure,imshow(c);
LEVEL=.610;                     %%%%%%%%%%%   Thresholding   %%%%%%%%%%%%%%
ky = im2bw(c,LEVEL);
figure,imshow(ky);
op=bwmorph(ky,'thick');         %%%%%%%%%%%    Thikening     %%%%%%%%%%%%%%
se = strel('disk',1);
BW = imclose(op,se);      %%% morphological closing on the binary image %%%
figure, imshow(BW);
BW2 = bwareaopen(BW, 75);    %%%%  removel of all connected components %%%%
figure, imshow(BW2);
O=BW-BW2;
imshow(O);
BWoutline = bwperim(O);
Segout = I; 
Segout(BWoutline) = 0; 
figure, imshow(Segout); title('outlined original image');

%%%%%%%%%%%%%%%%%%%%%%%%%  Feature Extraction  %%%%%%%%%%%5%%%%%%%%%%%%%%%%

R(i,1)=energy(O);
R(i,2)=mean2(O);
R(i,3)=std2(O);

%%%%%%%%%%%%%%%%%%%%%%%    Hessian Features     %%%%%%%%%%%%%%%%%%%%%%%%%%%


[r t g]=Hessian2D(O,2);
    H{i,1}=r;
    H{i,2}=t;
    H{i,3}=g;
average1=mean2(r~=0);
average2=mean2(t~=0);
average3=mean2(g~=0);
R(i,4)=average1;
R(i,5)=average2;
R(i,6)=average3;

    end
