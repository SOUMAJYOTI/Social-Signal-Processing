function [divergence_distance] = KL_distance(CSS_I_binary, CSS_M_binary)

[H,W] = size(CSS_I_binary);

distribution_1=zeros(size(CSS_I_binary));
distribution_1 = imcomplement(im2bw(distribution_1,0.5));
distribution_2=zeros(size(CSS_I_binary));
distribution_2 = imcomplement(im2bw(distribution_2,0.5));

p_1 = zeros(100,1);
p_2 = zeros(100,1);

for j=1:W
    for i=1:H
        if CSS_I_binary(i,j) == 0
            distribution_1(i,j)=0;
            p_1(j,1)= i;
            break;
        end
    end
end

imwrite(distribution_1, 'distr.jpg');
%display(p_1);
for j=1:W
    for i=1:H
        if CSS_M_binary(i,j) == 0
            distribution_2(i,j)=0;
            p_2(j,1)= i;
            break;
        end
    end
end

divergence_distance=0;
for i=1:W
    
    if p_1(i,1) == 0
        val_1=0;
    else
        val_1=log(p_1(i,1));
    end
    
    if p_2(i,1) == 0
        val_2=0;
    else
        val_2=log(p_2(i,1));
    end
    
    temp_1_2 = -(val_1*val_2) + (val_1*val_1);
    temp_2_1 = -(val_2*val_1) + (val_2*val_2);
    divergence_distance = divergence_distance + temp_1_2+temp_2_1;
end

%display(divergence_distance);
%figure, imshow(distribution_1);


end