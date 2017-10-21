%Curv action
clc;
clear;

N = 200;
DISPLAY_STEP = 2;
DISPLAY_ORIGINAL = 1;
MAX_SUBPLOT = 6;

measure=10;
contours_action_sequence = get_action_frame_contour('8.jpg');
css_image_2= CSSIFunction(contours_action_sequence, DISPLAY_ORIGINAL, DISPLAY_STEP, MAX_SUBPLOT);
[css_binary_2] = binary_cssi(css_image_2);
measure=measure+1;
%figure(measure),imshow(css_binary_2);
imwrite(css_binary_2, 'css_binary_1.jpg');

contours_action_sequence = get_action_frame_contour('11.jpg');
css_image_3= CSSIFunction(contours_action_sequence, DISPLAY_ORIGINAL, DISPLAY_STEP, MAX_SUBPLOT);
[css_binary_3] = binary_cssi(css_image_3);
measure=measure+1;
%figure(measure),imshow(css_binary_2);
imwrite(css_binary_2, 'css_binary_2.jpg');

%cost = matchingAlgo( css_binary_2, css_binary_3 );
%disp(cost);

%dist = KL_distance(css_binary_2, css_binary_3);
dist = distance_pdf(css_binary_2, css_binary_3);
disp(dist)



%distance_2 = distance_pdf(css_binary_2, css_binary_2);
%display(distance_2);
%{
css_binary_shift=zeros(size(css_binary_2));
circshift=30;
for i=1:200
    id=mod(i+circshift,200);
    if id==0
        id=200;
    end
    css_binary_shift(:,i)=css_binary_2(:,id);
end
figure,imshow(css_binary_shift);
title('B shift');
cost = matchingAlgo( css_binary_2, css_binary_shift );
disp(cost);
dist = KL_distance(css_binary_2, css_binary_shift);
disp(dist)


%display(dist);
contours_action_sequence = get_action_frame_contour('test_1.jpg');
css_image_3= CSSIFunction(contours_action_sequence, DISPLAY_ORIGINAL, DISPLAY_STEP, MAX_SUBPLOT);
[css_binary_3] = binary_cssi(css_image_3);
%figure,imshow(css_binary_2);

contours_action_sequence = get_action_frame_contour('i.jpg');        
css_image_1=CSSIFunction(contours_action_sequence, DISPLAY_ORIGINAL, DISPLAY_STEP, MAX_SUBPLOT);
[css_binary_1] = binary_cssi(css_image_1);
%figure,imshow(css_binary_1);

%dist = KL_distance(css_binary_1, css_binary_3);
%cost_hand = matchingAlgo(css_binary_2, css_binary_3);
%display(cost_hand);

%distance_1 = distance_pdf(css_binary_1, css_binary_3);
%distance_2 = distance_pdf(css_binary_2, css_binary_3);

%cost_face = matching(css_binary_1, css_binary_3);
%display(cost_face);



image_input = imread('test.jpg');
img_copy = image_input;

height = size(image_input,1);
width = size(image_input,2);

flag=0;

for i=1:100:height
   for j=1:130:width
       if flag ==0
       rect = [i j 130 100];
       crop_image = imcrop(image_input,rect);
       imwrite(crop_image, 'img_temp.jpg');
       contours_action_sequence = get_action_frame_contour('img_temp.jpg'); 
       css_image=CSSIFunction(contours_action_sequence, DISPLAY_ORIGINAL, DISPLAY_STEP, MAX_SUBPLOT);
       css_binary = binary_cssi(css_image);
       cost= distance_pdf(css_binary_2, css_binary);
       if(cost(1,1) > 0.3)
           for k=i:i+100
                img_copy(k,j,:) = [255 0 0];
                img_copy(k,j+130,:) = [255 0 0];
           end
           for k=j:j+130
                img_copy(i,k,:) = [255 0 0];
                img_copy(i+100,k,:) = [255 0 0];
           end
       end
       flag=1;
       end
   end
end

imshow(img_copy);

%}
%}