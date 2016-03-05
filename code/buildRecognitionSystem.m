layerNum = 3;
K = 50;

%load the files and texton dictionary
load('../dat/traintest.mat');
load('dictionary.mat');

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
l = length(train_imagenames);
wordRepresentation = cell(l,1);
train_features = zeros(f,l);

%load the word representations
fprintf('Loading the files\n');
for i=1:l
    load([source, strrep(train_imagenames{i},'.jpg','.mat')]);
    wordRepresentation{i} = wordMap;
end

%calculating training feature vectors
for i=1:l
    fprintf('Converting to feature vector %s\n', train_imagenames{i});
    train_features(:,i) = getImageFeaturesSPM(layerNum, wordRepresentation{i}, K);
end

save('vision.mat','filterBank','dictionary','train_features','train_labels');
