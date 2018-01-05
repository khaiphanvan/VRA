% VRA - Khai Phan Van CH1601029
function lstImage = createOxfordBuildingLibary(img)
    clear all;close all;
    %% init parameter
    addpath('AKM');
    run('vlfeat\toolbox\vl_setup.m');
    datasetDir = 'oxford\images\';
    num_words = 600000;
    num_iterations = 5;
    num_trees = 8;
    dim = 128;
    if_weight = 'tfidf';
    if_norm = 'l1';
    if_dist = 'l1';
    verbose=1;
    
    %% Compute SIFT features
    if ~exist('oxford\feat\feature.bin', 'file')
        fprintf('Computing SIFT features:\n');
        features = zeros(dim, 2000000);
        nfeat = 0;
        files = dir(fullfile(datasetDir, '*.jpg'));
        nfiles = length(files);
        features_per_image = zeros(1,nfiles);
        for i=1:nfiles
            fprintf('Extracting features %d/%d\n', i, nfiles);
            imgPath = strcat(datasetDir, files(i).name);
            I = im2single(rgb2gray(imread(imgPath)));
            I = imresize(I, 0.6);
            [frame, sift] = vl_covdet(I, 'method', 'Hessian', 'estimateAffineShape', true);

            if nfeat+size(sift,2) > size(features,2)
                features = [features zeros(dim,1000000)];
            end
            features(:,nfeat+1:nfeat+size(sift,2)) = sift;
            nfeat = nfeat+size(sift,2);
            features_per_image(i) = size(sift, 2);
        end
        features = features(:,1:nfeat);
        if ~exist('oxford\feat\', 'dir')
            mkdir('oxford\feat\')
        end
        fid = fopen('oxford\feat\feature.bin', 'w');
        fwrite(fid, features, 'float');
        fclose(fid);

        save('oxford\feat\feat_info.mat', 'features_per_image', 'files');
    else
        fprintf('Loading SIFT features:\n');
        file = dir('oxford\feat\feature.bin');
        fid = fopen('oxford\feat\feature.bin', 'r');
        features = fread(fid, [128, file.bytes/(4*128)], 'float');
        fclose(fid);
        load('oxford\feat\feat_info.mat');
    end

    %% Run AKM to build dictionary
    fprintf('Building the dictionary:\n');
    num_images = length(files);
    dict_params =  {num_iterations, 'kdt', num_trees};
    
    %% build the dictionary
    if exist('oxford\feat\dict.mat', 'file')
        load('oxford\feat\dict.mat');
    else
        randIndex = randperm(size(features,2));
        dict_words = ccvBowGetDict(features(:,randIndex(1:100000)), [], [], num_words, 'flat', 'akmeans', ...
            [], dict_params);
        save('oxford\feat\dict.mat', 'dict_words');
    end

    %% Compute sparse frequency vector
    fprintf('Computing the words\n');
    dict = ccvBowGetWordsInit(dict_words, 'flat', 'akmeans', [], dict_params);
    %     save('dicts.mat','-struct','dict');
    
    if exist('oxford\feat\words.mat', 'file')
        load('oxford\feat\words.mat');
    else
        words = cell(1, num_images);
        for i=1:num_images
            fprintf('Quantizing %d/%d images\n', i, num_images);
            if i==1
                bIndex = 1;
            else
                bIndex = sum(features_per_image(1:i-1))+1;
            end
            eIndex = bIndex + features_per_image(i)-1;
            words{i} = ccvBowGetWords(dict_words, features(:, bIndex:eIndex), [], dict);
        end
        save('oxford\feat\words.mat', 'words');
    end
end

