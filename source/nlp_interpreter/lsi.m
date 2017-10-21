%Latent Semantic Indexing

clc;
clear all;
%featuriziation
   
    [num,txt,raw] = xlsread('desc.xls');
%    descriptions = raw(2:size(raw,1),2);
    descriptions = raw(1:size(raw,1),1);
    inputcellarray = descriptions;
    nminFeatures = 1;
    removeStopWords = 1;
    doStem=0;
    grams=1;
    
   [featureVector b] = featurize_bigram(inputcellarray, nminFeatures, removeStopWords, doStem); 
   
   A = featureVector';
   [U S V] = svd(A);
    
   fid = fopen('english.stop');
   stopwords = textscan(fid, '%s');
   stopwords = stopwords{1,1};
   fclose(fid);

n=1;

g = containers.Map();
bigs = containers.Map();
lastword = '';
   query = {'Stretched palm waving right'}; 
   comment = query{1};
    comment = SanitizeComment(comment);
    comment = lower(comment);
    r=regexp(comment,' ','split');
    for j =1:size(r,2)
        
        if doStem
            word = porterStemmer(cell2mat(r(j)));
        else
            word = (cell2mat(r(j)));
        end
        
        if removeStopWords % if the function caller wants to remove stopwords
            tfflag = ~isStopWord(word, stopwords);
        else
            tfflag = 1;
        end
        
        if isKey(g, word) && tfflag
            g(word) = g(word)+1;
        elseif tfflag & (~strcmp(word,' ')) & (~strcmp(word,''))
            g(word) = 1;
        end
        if  (~strcmp(lastword,'')) & (~strcmp(word,' ')) & (~strcmp(lastword,' ')) & (~strcmp(word,''))
            bigram = char(strcat(lastword, {' '}, word));
            % for debugging :) fprintf('DDD%sDDDDDD%sDDD%sDDD\n',bigram,lastword,word);
            if isKey(g, bigram)
                g(bigram) = g(bigram)+1;
            else
                bigs(bigram) =1;
                g(bigram) = 1;
                
            end
        end
        lastword = word;
        
    end
    
selectedheaders =containers.Map();
gkeys = keys(g);
for i=1:size(gkeys,2)
    if g(gkeys{i})>=n
        
        selectedheaders(gkeys{i})=1;
        
    end
    
end
headers = keys(selectedheaders);
disp(headers);

Q = zeros(size(b'));
for i=1:size(headers,2)
	for j=1:size(b,2)
		if strcmp(headers(i),b(j))
			Q(j)=Q(j)+1;
		end
	end
end

QT=transpose(Q);
S=S(1:5,1:5);
%U=U(:,1:5);
QTS = QT*U;
QTS=QTS(:,1:5);
newQ=QTS*inv(S);

sim = zeros(size(V,1));
for d=1:size(V,1)
	sim(d) = (newQ*V(d,:)')/(norm(newQ)*norm(V(d,:)));
end
