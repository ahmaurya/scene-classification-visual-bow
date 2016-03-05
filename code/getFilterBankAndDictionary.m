function [filterBank, dictionary] = getFilterBankAndDictionary(image_names)

alpha = 500;
K = 30;

[filterBank] = createFilterBank();

filter_responses = zeros(alpha*length(image_names),3*length(filterBank));

for i = 1:length(image_names)
    currentImage = imread(image_names{i});
    currentFilterResponse = extractFilterResponses(currentImage,filterBank);
    for j = 1:alpha
        xcoord = randi(size(currentImage,1));
        ycoord = randi(size(currentImage,2));
        filter_responses(i*j,:) = currentFilterResponse(xcoord*ycoord,:);
    end
end

[~, dictionary] = kmeans(filter_responses, K, 'EmptyAction', 'singleton');
dictionary = dictionary';

return;
