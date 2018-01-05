function BaiTap26()
    strData = 'train-images.idx3-ubyte';
    strDataLabel = 'train-labels.idx1-ubyte';
    strDataTest = 't10k-images.idx3-ubyte';
    strDataLabelTest = 't10k-labels.idx1-ubyte';
    [imgDataTrain,lblDataTrain] = loadData(strData,strDataLabel);
    [imgDataTest,lblDataTest] = loadData(strDataTest, strDataLabelTest);
    
    Mdl = fitcecoc(imgDataTrain', lblDataTrain);
    lblResult = predict(Mdl, imgDataTest');
    
    nResult = (lblResult == lblDataTest);
    nCount = sum(nResult);
    
    fprintf('\nSo luong mau dung: %d\n', nCount);
end