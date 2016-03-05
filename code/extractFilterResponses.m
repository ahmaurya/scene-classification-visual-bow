function [filterResponses] = extractFilterResponses(I, filterBank)
% Inputs: 
%   I:                  a 3-channel RGB image with width W and height H 
%   filterBank:         a cell array of N filters
% Outputs:
%   filterResponses:    a W*H x N*3 matrix of filter responses

% convert input Image to Lab
doubleI = double(I);
if ndims(doubleI)<=2
    doubleI=repmat(doubleI,[1,1,3]);
end
[L,a,b] = RGB2Lab(doubleI(:,:,1), doubleI(:,:,2), doubleI(:,:,3));
pixelCount = size(doubleI,1)*size(doubleI,2);

% filterResponses: a W*H x N*3 matrix of filter responses
filterResponses = zeros(pixelCount, length(filterBank)*3);

% for each filter and channel, apply the filter, and vectorize
for i=1:size(filterBank)
    filterResponses(:,(i-1)*3+1) = reshape(filter2(filterBank{i}, L), pixelCount, 1);
    filterResponses(:,(i-1)*3+2) = reshape(filter2(filterBank{i}, a), pixelCount, 1);
    filterResponses(:,(i-1)*3+3) = reshape(filter2(filterBank{i}, b), pixelCount, 1);
end

end
