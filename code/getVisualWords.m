function [wordMap] = getVisualWords(I, filterBank, dictionary)    
    imageWidth = size(I,1);
    imageHeight = size(I,2);
    
    filterResponse = extractFilterResponses(I, filterBank);
    [~, minIndices] = min(pdist2(dictionary',filterResponse));

    wordMap = reshape(minIndices, imageWidth, imageHeight);
return;