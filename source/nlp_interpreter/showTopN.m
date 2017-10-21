function showTopN(index2Term, prob_term_topic, topN, z)
	fileID = fopen('TopN.txt','a');
	fprintf(fileID,'TopN(%d) keywords for topic %d\n', topN, z);
	[S, I] = sort(prob_term_topic, 'descend');
	for w = I(1:topN)'
		fprintf(fileID,'%s\t(%f)\n', index2Term{w}, prob_term_topic(w));
	end
end
