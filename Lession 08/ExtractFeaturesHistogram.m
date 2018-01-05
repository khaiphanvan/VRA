function [featuresDataTrain] = ExtractFeaturesHistogram(imgDataTrain)
    nBins = 256;
    nNumTestImages = size(imgDataTrain, 2);
    featuresDataTrain = zeros(nBins, nNumTestImages);
    for i = 1 : nNumTestImages
        featuresDataTrain(:,i) = imhist(imgDataTrain(:,i), nBins);
    end
end