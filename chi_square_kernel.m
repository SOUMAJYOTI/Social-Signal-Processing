function K = chi_square_kernel(p1,p2,L)

numData_p1 = size(p1, 1);
numData_p2 = size(p2, 1);
K=zeros(numData_p1,numData_p2);
for l=1:4
	sum = 0;
	for i=1:numData_p1
		for j=1:numData_p2
			D(i,j) = chi_square_statistics(cell2mat(p1(i,l))', cell2mat(p2(j,l))');
		end
	end
	
	alpha = 1.0/(2^(L-l+1));
	for i=1:numData_p1
		for j=1:numData_p2
			K(i,j) = K(i,j) + alpha*D(i,j); 
		end
	end
end
