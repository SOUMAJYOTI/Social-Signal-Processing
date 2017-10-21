function [corr_coefficient] = distance_pdf(CSS_I_binary, CSS_M_binary)

x_points_M = zeros(200,1);
y_points_M = zeros(100,1);

for j=1:200
    for i=1:100
        x_points_M(j,1)= j;
        if CSS_M_binary(i,j) == 0
            y_points_M(j,1)= 100-i;
            break;
        end
    end
end

%   extract the maximas
[cord_I_y,cord_I_x] = find(CSS_I_binary == 0);
cord_I = [cord_I_y,cord_I_x];
maximas_I = extractMaxima(cord_I,CSS_I_binary);

%p= polyfit(x_points, y_points, 3);

%display(maximas_I(:,2));

for i=1:length(maximas_I)
    if(y_points_M(maximas_I(i,2))==0)
        y_I(i) = spline(x_points_M,y_points_M,maximas_I(i,2));
    else
        y_I(i) = y_points_M(maximas_I(i,2));
    end
end

for i=1:length(maximas_I)
    maximas_y(i)  = 100-maximas_I(i,1);
end

%display(maximas_y);
%display(y_I);

corr_coefficient=0;

corr_coefficient = corrcoef(maximas_y,y_I);
%display(corr_coefficient);

%corr_coefficient_2 = corrcoef(maximas_M(:,1),maximas_M(:,2));
%display(corr_coefficient_2);
end