function [out bin] = generate_skinmap(filename)
%GENERATE_SKINMAP Produce a skinmap of a given image. Highlights patches of
%"skin" like pixels. Can be used in face detection, gesture recognition,
%and other HCI applications.

%   The function reads an image file given by the input parameter string
%   filename, read by the MATLAB function 'imread'.
%   out - contains the skinmap overlayed onto the image with skin pixels
%   marked in blue color.
%   bin - contains the binary skinmap, with skin pixels as '1'.
%
%   Example usage:
%       [out bin] = generate_skinmap('nadal.jpg');
%       generate_skinmap('nadal.jpg');
%

    
    if nargin > 1 | nargin < 1
        error('usage: generate_skinmap(filename)');
    end;
    
    %Read the image, and capture the dimensions
    img_orig = imread(filename);
    height = size(img_orig,1);
    width = size(img_orig,2);
    
    %Initialize the output images
    out = img_orig;
    bin = zeros(height,width);
    
    %Apply Grayworld Algorithm for illumination compensation
    img = grayworld(img_orig);    
    
    %Convert the image from RGB to YCbCr
    img_ycbcr = rgb2ycbcr(img);
    Y = img_ycbcr(:,:,1);
    Cb = img_ycbcr(:,:,2);
    Cr = img_ycbcr(:,:,3);
    
    %Detect Skin
    [r,c,v] = find(Y>=90 & Cb>=80 & Cb<=135 & Cr>=110 & Cr<=140);
    numind = size(r,1);
    
    %Mark Skin Pixels
    for i=1:numind
        out(r(i),c(i),:) = [0 0 255];
        bin(r(i),c(i)) = 1;
    end
    %imshow(img_orig);
    %figure; imshow(bin);
    imwrite(bin, 'thresh.jpg');
    
   %{ max_row=1;
    min_row=1;
    max_col=1;
    min_col=1;
    flag=0;
    
    for i=1:height
      for j=1:width 
          if bin(i,j) == 1
              min_row = i;
              flag=1;
              break;
          end
          if flag == 1 
              break;
          end
      end
   end
       
    flag=0;
    for j=1:width
      for i=1:height 
          if bin(i,j) == 1
              min_col = j;
              flag=1;
              break;
          end
           if flag == 1 
              break;
          end
      end
    end
       
    flag=0;
    for j=width:-1:1
      for i=1:height 
          if bin(i,j) == 1
              max_col = j;
              flag=1;
              break;
          end
           if flag == 1 
              break;
          end
      end
    end
    
    flag=0;
    
    for i=height:-1:1 
      for j=1:width 
          if bin(i,j) == 1
              max_row = i;
              flag=1;
              break;
          end
          if flag == 1 
              break;
          end
      end
    end
   
    for i=min_row:max_row
        img_orig(i,min_col,:) = [255 0 0];
        img_orig(i,max_col,:) = [255 0 0];
    end
    for i=min_col:max_col
        img_orig(min_row,i,:) = [255 0 0];
        img_orig(max_row,i,:) = [255 0 0];
    end
   %} 
     %figure; imshow(img_orig);
     %{
    fileID = fopen('values.txt','w');
    
    for i=1:height
      for j=1:width 
          fprintf(fileID,'%d ', bin(i,j));
      end
          fprintf(fileID, '\n');
    end
    fclose(fileID);
    
    %}
  %fprintf('%d %d %d\n', min_col, max_col, height);  
end
