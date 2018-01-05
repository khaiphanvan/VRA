function BaiTap028()
    [trainImages, trainLabels] = loadData('train-images.idx3-ubyte','train-labels.idx1-ubyte');
    nBins = 144;
    nTrainImages = size(trainImages, 2);
    imgTrainHOG = zeros(nBins, nTrainImages);
    for i = 1: nTrainImages
        img = reshape(trainImages(:, i), 28, 28);
        
        imgTrainHOG(:, i) = extractHOGFeatures(img);
    end
    mdl = fitcecoc(imgTrainHist', trainLabels);
    
    [testImages, testLabels] = loadData('t10k-images.idx3-ubyte','t10k-labels.idx1-ubyte' );
    nTestImages = size(testImages, 2);
    imgTestHOG = zeros(nBins, nTestImages);
    for i = 1: nTestImages
        img = reshape(testImages(:, i), 28, 28);
        
        imgTestHOG(:, i) = extractHOGFeatures(img);
    end
    
    nResult = predict(mdl, imgTestHOG');
    nCount = sum(nResult==testLabels);
    fprintf('\nSo mau dung %d\n', nCount);
end