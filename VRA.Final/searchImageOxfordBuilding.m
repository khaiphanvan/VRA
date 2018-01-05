% VRA - Khai Phan Van CH1601029
function lstImage = searchImageOxfordBuilding(image_name,pos,nImage)
    %% init parameter
    addpath('AKM');
    run('vlfeat\toolbox\vl_setup.m');
    datasetDir = 'oxford\images\';
    num_words = 1000000;
    num_iterations = 5;
    num_trees = 8;
    if_weight = 'tfidf';
    if_norm = 'l1';
    if_dist = 'l1';

    files = dir(fullfile(datasetDir, '*.jpg'));
    
    if exist('oxford\feat\dict.mat', 'file')
        load('oxford\feat\dict.mat');
    else
        msgbox('Not exist dict.mat','Error','Error');
        return;
    end
            
    %% Compute sparse frequency vector
    dict_params =  {num_iterations, 'kdt', num_trees};
%     fprintf('Computing the words\n');

    dict = ccvBowGetWordsInit(dict_words, 'flat', 'akmeans', [], dict_params);
               
    if exist('oxford\feat\words.mat', 'file')
        load('oxford\feat\words.mat');
    else
        msgbox('Not exist words.mat','Error','Error');
        return;
    end
       
    %% create an inverted file for the images
%     fprintf('Creating and searching an inverted file\n');
    inv_file = ccvInvFileInsert([], words, num_words);
    ccvInvFileCompStats(inv_file, if_weight, if_norm);
    
    %% Query images
    ntop = 0;
    % load query image
    x1=pos(1);
    y1=pos(2);
    x2=x1+pos(3);
    y2=y1+pos(4);
    file = strcat('oxford\images\', image_name); 
    if exist(file,'file')
        I = im2single(rgb2gray(imread(file)));
    else
        lstImage = file;
        return;
    end
       
    % compute SIFT features
    [frame, sift] = vl_covdet(I, 'method', 'Hessian', 'estimateAffineShape', true);
    sift = sift(:,(frame(1,:)<=x2) &  (frame(1,:) >= x1) & (frame(2,:) <= y2) & (frame(2,:) >= y1));
     
    %% Test on an image
    q_words = cell(1,1);
    q_words{1} = ccvBowGetWords(dict_words, double(sift), [], dict);
    [ids dists] = ccvInvFileSearch(inv_file, q_words(1), if_weight, if_norm, if_dist, ntop);
  
    lstImage={''};
    for i=1:nImage
        lstImage{i,:} = files(ids{1}(i)).name;
    end
    
    % clear inv file
    ccvInvFileClean(inv_file);
end

