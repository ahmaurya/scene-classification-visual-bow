function [histInter] = distanceToSet(wordHist, histograms)
	histInter = sum(bsxfun(@min, wordHist', histograms));
end