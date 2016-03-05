layerNum = 3;
K = 50;

%load the files and texton dictionary
load('../dat/traintest.mat');
load('vision.mat');

source = '../dat/';
target = '../dat/';

if ~exist(target,'dir')
    mkdir(target);
end

for category = mapping
    if ~exist([target,category{1}],'dir')
        mkdir([target,category{1}]);
    end
end

f = 1050;
l = length(test_imagenames);
wordRepresentation = cell(l,1);
test_features = zeros(f,l);
predicted_labels = zeros(1,l);

%load the word representations
fprintf('Loading the files\n');
for i=1:l
    load([source, strrep(test_imagenames{i},'.jpg','.mat')]);
    wordRepresentation{i} = wordMap;
end

%This is a peculiarity of loading inside of a function with parfor. We need to 
%tell MATLAB that these variables exist and should be passed to worker pools.
filterBank = filterBank;
dictionary = dictionary;

for i=1:l
    %fprintf('Converting to feature vector %s\n', test_imagenames{i});
    test_features(:,i) = getImageFeaturesSPM(layerNum, wordRepresentation{i}, K);
    distances = distanceToSet(test_features(:,i), train_features');
    [~,nnI] = max(distances);
    predicted_labels(i) = train_labels(nnI);
    if predicted_labels(i) ~= test_labels(i)
        fprintf('Mistake on %s classified as %s\n', test_imagenames{i}, mapping{predicted_labels(i)});
    end
end

for k=1:30
    model = fitcknn(train_features',train_labels,'Distance','spearman');
    model.NumNeighbors = k;
    predicted_labels_ = predict(model,test_features');
    accVersusK(k) = sum(predicted_labels_'==test_labels)/160.0;
end
accVersusK

acc=sum(predicted_labels==test_labels)/160.0;
cm = confusionmat(predicted_labels, test_labels);
accPerClass = 100*diag(cm)'./sum(cm,1);

fprintf('\nAccuracy:\n');
acc
fprintf('\nAccuracy Per Class:\n');
accPerClass
fprintf('\nConfusion Matrix:\n');
cm


