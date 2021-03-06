function output = term_count(inputtext, headers)
% Multinomial Featurizer
%
% takes:
%      inputtext: a long string
%      headers: a cell array containing a number of keywords
% output:
%      an array of numbers
%      showing how many times each term is repeated in the text
output = [];
%out_bigrams = n_grams(inputtext, 2)
    for i= 1:size(headers,2)
        pattern = headers{i};
        temp = regexp(inputtext, pattern, 'match');
                
        %inputtext = regexprep(inputtext, pattern, ' '); %removes the terms for efficiency 
        output = [output, size(temp,2)];
    end

end
