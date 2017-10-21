% a runnable demo to show plsa in nlp application
global MAXNUMDIM;
MAXNUMDIM = 20000; % global variable, dimension of terms
global MAXNUMDOC;
MAXNUMDOC = 2000;  % global variable, number of documents
numTopic = 5;     % number of topics
numIter = 10;      % number of iteration

[num,txt,raw] = xlsread('desc.xls');
%    descriptions = raw(2:size(raw,1),2);
    descriptions = raw(1:size(raw,1),1);
    inputcellarray = descriptions;
    nminFeatures = 1;
    removeStopWords = 1;
    doStem=0;
    grams=1;
    
   [featureVector b] = featurize_bigram(inputcellarray, nminFeatures, removeStopWords, doStem, 1); 

out=tfidf(featureVector);
disp(out);
% 1th, preprocess the raw text set
%[term2Index, index2Term, termDocMatrix] = analyze('data/award_abstracts.txt');
termDocMatrix = featureVector';
fileID=fopen('termDoc.txt','w');
for i=1:size(termDocMatrix,1)
	for j=1:size(termDocMatrix,2)
		fprintf(fileID,'%f ',termDocMatrix(i,j));
	end
	fprintf(fileID,'\n');
end


fprintf('Num of dimension: %d\n', size(termDocMatrix, 1));
fprintf('Num of document: %d\n', size(termDocMatrix, 2));

%disp(termDocMatrix);
% 2th, fit a plsa model from a given term-doc matrix
[prob_term_topic, prob_topic_doc, lls] = plsa(termDocMatrix, numTopic, numIter);
% [prob_term_topic, prob_doc_topic, prob_topic, lls] = plsa2(termDocMatrix, numTopic, numIter);

%{
% 3th, display topN keywords for each topic
topN = 31;

for z = 1:numTopic
	showTopN(b, prob_term_topic(:, z), topN, z);
end

% 4th, plot the log-likelihood per iteration
%figure;
%plot(lls);
%xlabel('Iteration');
%ylabel('log-likehood');

Query = {'Stretched palm moving towards the right'};
 [featureVector b] = featurize_bigram(Query, nminFeatures, removeStopWords, doStem, 0); 
termDocMatrix = featureVector';

fprintf('Num of dimension: %d\n', size(termDocMatrix, 1));
fprintf('Num of document: %d\n', size(termDocMatrix, 2));

% 2th, fit a plsa model from a given term-doc matrix
[prob_term_topic1, prob_topic_doc1, lls1] = plsa(termDocMatrix, numTopic, numIter);

%dist = KLDiv(prob_term_topic(:,1), prob_term_topic1(:,1));
%}
