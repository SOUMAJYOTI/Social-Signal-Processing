%Create the PHOG descriptors
clear all;
clc;

I = '1.jpg';
img = imread(I);
bin = 8;
angle = 360;
L=3;
roi = [1;size(img,1);1;size(img,2)];
p1{:} = phog(I,bin,angle,L,roi);
x=p1{1}
figure(1),hist(cell2mat(x(4)))
saveas(gcf,'4.jpg');

%{
I = '2.jpg';
img = imread(I);
bin = 8;
angle = 360;
L=3;
roi = [1;size(img,1);1;size(img,2)];
p2{:} = phog(I,bin,angle,L,roi);
%figure,hist(p)

I = '3.jpg';
img = imread(I);
bin = 8;
angle = 360;
L=3;
roi = [1;size(img,1);1;size(img,2)];
p3{:} = phog(I,bin,angle,L,roi)

y1(1,:)=p1{1};
y1(2,:)=p2{1};
y(1,:)=p3{1};
%}
%d1 = chi_square_kernel(y1,y,4);
%d2 = chi_square_kernel(p1,p3,4);
%image_dir = strcat('gesture_codebook','/gest_', num2str(1), '/');
%fnames = dir(fullfile(image_dir, '*.jpg'));
%num_files = size(fnames,1);
	



	
