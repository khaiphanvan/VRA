function BaiTap27()
    [trainImages, trainLabels] = loadData('train-images.idx3-ubyte','train-labels.idx1-ubyte');
    nBins = 256;
    nTrainImages = size(trainImages, 2);
    imgTrainAll_hist = zeros(nBins, nTrainImages);
    for i = 1: nTrainImages
        imgTrainAll_hist(:, i) = imhist(trainImages(:, i), nBins);
    end
    mdl = fitcecoc(imgTrainAll_hist', trainLabels);
    
    [testImages, testLabels] = loadData('t10k-images.idx3-ubyte','t10k-labels.idx1-ubyte' );
    nTestImages = size(testImages, 2);
    
    imgTestAll_hist = zeros(nBins, nTestImages);
    for i = 1: nTestImages
        imgTestAll_hist(:, i) = imhist(testImages(:, i), nBins);
    end
    
    lblResult = predict(mdl, imgTestAll_hist');
    nResult = (lblResult == testLabels);
    nCount = sum(nResult);
    fprintf('\nSo mau dung %d\n', nCount);
end