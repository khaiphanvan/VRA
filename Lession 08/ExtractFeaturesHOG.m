function [featuresDataTrain] = ExtractFeaturesHOG(imgDataTrain, cellSize)

imgI1D = imgDataTrain(:,1);
imgI2D = reshape(imgI1D,28,28);
featureVector = extractHOGFeatures(imgI2D, 'CellSize', cellSize);
nSize = length(featureVector);
nTrainData = size(imgDataTrain,2);
featuresDataTrain=zeros(nSize,nTrainData);
 
    for i = 1:nTrainData
        imgI1D = imgDataTrain(:,i); 
        imgI2D = reshape(imgI1D,28,28); 
        featuresDataTrain(:,i) = extractHOGFeatures(imgI2D, 'CellSize', cellSize);
    end
end