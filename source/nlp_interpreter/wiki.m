% TF-IDF

clc;
clear all;
%featuriziation
   
[num,txt,raw] = xlsread('desc.xls');
%    descriptions = raw(2:size(raw,1),2);
descriptions = raw(1:size(raw,1),1);
inputcellarray = descriptions;
nminFeatures = 0;
removeStopWords = 1;
doStem=0;
grams=1;
    
[featureVector b] = featurize_bigram(inputcellarray, nminFeatures, removeStopWords, doStem, 1); 

A = featureVector';
df=zeros(size(b,2),1);
for i=1:size(b,2)
	for j=1:size(A,2)
		if A(i,j)>=1
			df(i) =df(i)+1;
		end
	end
end
for i=1:size(b,2)
	r=regexp(b(1,i),' ','split');
	w(i)=size(r{1},2);
end

tf =zeros(size(A));
T =zeros(size(A));
for i=1:size(A,1)
	for j=1:size(A,2)
		if A(i,j)>=1
			tf(i,j) =double(log(A(i,j)))+1;
		end
	end
end
for i=1:size(A,1)
	for j=1:size(A,2)
		T(i,j) = tf(i,j)*(log(size(A,2))/df(i));
		if isnan(T(i,j))
			T(i,j)=0;
		end
	end
end

T=T';
wd=zeros(size(T,1),1);
query = {'Left hand Stretched palm waving right'}; 
[featureVector q] = featurize_bigram(query, nminFeatures, removeStopWords, doStem, 0); 
for i=1:size(T,1)
	for j=1:size(T,2)
		for k=1:size(q,2)
			if strcmp(b(j),q(k))  
				wd(i)= wd(i)+(w(i)*T(i,j));
			end
		end		
	end
end


