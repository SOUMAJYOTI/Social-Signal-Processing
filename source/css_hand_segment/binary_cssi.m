function [css_binary_prob] = binary_cssi(css_images)
num_of_images = length(css_images);

css_image_model = ones(100,200);

for i = 1 : num_of_images
	x_range = css_images(i).zero_crossings;
    y_range = repmat(css_images(i).sigma,[1 length(x_range)]);
    
    for j=1:size(x_range,2)
        css_image_model(100-floor(y_range(j)),x_range(j)) = 0;
    end
    
end

%css_binary = imcomplement(im2bw(css_image_model,0.5));
css_binary=css_image_model;
css_binary_prob = ones(size(css_binary));
for i=1:size(css_binary,2)
	for j=1:size(css_binary,1)
		if css_binary(j,i) == 0
			css_binary_prob(j,i)=0;
			break;
		end
	end
end
imshow(css_binary);
end