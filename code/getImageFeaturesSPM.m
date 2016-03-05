function [h] = getImageFeaturesSPM(layerNum, wordMap, dictionarySize, currentLayer)
	if nargin<4
		currentLayer = 0;
	end

	L = layerNum-1;
	wordMapWidth = size(wordMap,1);
	wordMapHeight = size(wordMap,2);

	if currentLayer==0
		featureWeight = 2^(-L);
	else
		featureWeight = 2^(currentLayer-L-1);
	end

	h = featureWeight*getImageFeatures(wordMap, dictionarySize);

	if currentLayer < L
		midWidth = ceil(wordMapWidth/2.0);
		midHeight = ceil(wordMapHeight/2.0);
		
		wordMap_00 = wordMap(1:midWidth,1:midHeight);
		wordMap_01 = wordMap(midWidth+1:wordMapWidth,1:midHeight);
		wordMap_10 = wordMap(1:midWidth,midHeight+1:wordMapHeight);
		wordMap_11 = wordMap(midWidth+1:wordMapWidth,midHeight+1:wordMapHeight);

		h = [h, 2*getImageFeaturesSPM(layerNum, wordMap_00, dictionarySize, currentLayer+1)];
		h = [h, 2*getImageFeaturesSPM(layerNum, wordMap_01, dictionarySize, currentLayer+1)];
		h = [h, 2*getImageFeaturesSPM(layerNum, wordMap_10, dictionarySize, currentLayer+1)];
		h = [h, 2*getImageFeaturesSPM(layerNum, wordMap_11, dictionarySize, currentLayer+1)];
	end
end