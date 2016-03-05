function [h] = getImageFeatures(wordMap, dictionarySize)
	h = hist(wordMap, 1:dictionarySize);
	h = h / sum(h);
	h = h';
end