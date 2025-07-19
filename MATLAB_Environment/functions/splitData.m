function [XTrain, XTest, yTrain, yTest] = splitData(features, labels, trainRatio)
%SPLITDATA Split data into training and testing sets
%   Splits the feature matrix and labels into training and testing sets
%   while maintaining class balance
%
%   Inputs:
%       features   - Feature matrix (nSamples x nFeatures)
%       labels     - Label vector (nSamples x 1)
%       trainRatio - Ratio of data to use for training (default: 0.7)
%
%   Outputs:
%       XTrain - Training features
%       XTest  - Testing features  
%       yTrain - Training labels
%       yTest  - Testing labels

    if nargin < 3
        trainRatio = 0.7;
    end
    
    % Set random seed for reproducibility
    rng(42);
    
    % Get unique classes
    uniqueClasses = unique(labels);
    nClasses = length(uniqueClasses);
    
    % Initialize indices for train and test sets
    trainIdx = [];
    testIdx = [];
    
    % Split each class separately to maintain balance
    for i = 1:nClasses
        classIdx = find(labels == uniqueClasses(i));
        nClassSamples = length(classIdx);
        
        % Shuffle class indices
        classIdx = classIdx(randperm(nClassSamples));
        
        % Split into train and test
        nTrain = floor(nClassSamples * trainRatio);
        
        trainIdx = [trainIdx; classIdx(1:nTrain)];
        testIdx = [testIdx; classIdx(nTrain+1:end)];
    end
    
    % Extract training and testing data
    XTrain = features(trainIdx, :);
    XTest = features(testIdx, :);
    yTrain = labels(trainIdx);
    yTest = labels(testIdx);
    
    % Shuffle training data
    shuffleIdx = randperm(length(trainIdx));
    XTrain = XTrain(shuffleIdx, :);
    yTrain = yTrain(shuffleIdx);
    
    % Shuffle testing data
    shuffleIdx = randperm(length(testIdx));
    XTest = XTest(shuffleIdx, :);
    yTest = yTest(shuffleIdx);
    
    fprintf('Data split completed:\n');
    fprintf('  Training samples: %d (%.1f%%)\n', length(yTrain), 100*length(yTrain)/(length(yTrain)+length(yTest)));
    fprintf('  Testing samples: %d (%.1f%%)\n', length(yTest), 100*length(yTest)/(length(yTrain)+length(yTest)));
    fprintf('  Training normal/anomaly ratio: %d/%d\n', sum(yTrain==0), sum(yTrain==1));
    fprintf('  Testing normal/anomaly ratio: %d/%d\n', sum(yTest==0), sum(yTest==1));

end