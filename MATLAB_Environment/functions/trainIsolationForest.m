function model = trainIsolationForest(XTrain)
%TRAINISOLATIONFOREST Train Isolation Forest for anomaly detection
%   Trains an Isolation Forest model using only normal data
%
%   Input:
%       XTrain - Training data (normal samples only)
%
%   Output:
%       model - Trained Isolation Forest model structure

    fprintf('Training Isolation Forest...\n');
    
    % Check if Statistics and Machine Learning Toolbox is available
    if ~license('test', 'Statistics_Toolbox')
        error('Statistics and Machine Learning Toolbox is required for Isolation Forest');
    end
    
    try
        % MATLAB doesn't have built-in Isolation Forest, so we'll implement a simplified version
        % using ensemble of decision trees with random splits
        
        [nSamples, nFeatures] = size(XTrain);
        
        % Parameters for Isolation Forest
        nTrees = 100;           % Number of trees in the forest
        subSampleSize = min(256, nSamples); % Subsample size for each tree
        maxDepth = ceil(log2(subSampleSize)); % Maximum tree depth
        
        % Initialize model structure
        model.type = 'IsolationForest';
        model.nTrees = nTrees;
        model.subSampleSize = subSampleSize;
        model.maxDepth = maxDepth;
        model.trees = cell(nTrees, 1);
        model.featureRanges = [min(XTrain, [], 1); max(XTrain, [], 1)];
        
        fprintf('  Building %d isolation trees...\n', nTrees);
        
        % Train each tree
        for t = 1:nTrees
            % Random subsample
            sampleIdx = randsample(nSamples, subSampleSize, true);
            treeData = XTrain(sampleIdx, :);
            
            % Build isolation tree
            model.trees{t} = buildIsolationTree(treeData, 0, maxDepth, nFeatures);
            
            if mod(t, 20) == 0
                fprintf('    Completed %d/%d trees\n', t, nTrees);
            end
        end
        
        % Calculate average path length for training data (for threshold)
        pathLengths = zeros(nSamples, 1);
        for i = 1:nSamples
            lengths = zeros(nTrees, 1);
            for t = 1:nTrees
                lengths(t) = getPathLength(model.trees{t}, XTrain(i, :));
            end
            pathLengths(i) = mean(lengths);
        end
        
        % Set threshold as 95th percentile of path lengths
        model.threshold = prctile(pathLengths, 5); % Lower path length = more anomalous
        
        fprintf('  Isolation Forest training completed.\n');
        fprintf('  Trees: %d, Threshold: %.3f\n', nTrees, model.threshold);
        
    catch ME
        % Fallback: Use simple outlier detection
        warning('Isolation Forest training failed. Using outlier detection instead.');
        
        model.type = 'OutlierDetection';
        model.mean = mean(XTrain, 1);
        model.std = std(XTrain, 0, 1);
        model.threshold = 3; % 3-sigma rule
        
        fprintf('  Outlier detection model trained as fallback.\n');
    end

end

function tree = buildIsolationTree(data, currentDepth, maxDepth, nFeatures)
%BUILDISOLATIONTREE Build a single isolation tree
%   Recursively builds an isolation tree by randomly selecting features and split points
%
%   Inputs:
%       data         - Data to split
%       currentDepth - Current depth of the tree
%       maxDepth     - Maximum allowed depth
%       nFeatures    - Total number of features
%
%   Output:
%       tree - Tree structure

    [nSamples, ~] = size(data);
    
    % Base cases: stop splitting
    if currentDepth >= maxDepth || nSamples <= 1 || isempty(data)
        tree.isLeaf = true;
        tree.size = nSamples;
        return;
    end
    
    % Check if all samples are identical
    if all(all(data == data(1, :)))
        tree.isLeaf = true;
        tree.size = nSamples;
        return;
    end
    
    % Random feature selection
    feature = randi(nFeatures);
    
    % Random split point between min and max of selected feature
    featureValues = data(:, feature);
    minVal = min(featureValues);
    maxVal = max(featureValues);
    
    if minVal == maxVal
        tree.isLeaf = true;
        tree.size = nSamples;
        return;
    end
    
    splitPoint = minVal + (maxVal - minVal) * rand();
    
    % Split data
    leftIdx = featureValues < splitPoint;
    rightIdx = ~leftIdx;
    
    % Create internal node
    tree.isLeaf = false;
    tree.feature = feature;
    tree.splitPoint = splitPoint;
    tree.size = nSamples;
    
    % Recursively build subtrees
    if any(leftIdx)
        tree.left = buildIsolationTree(data(leftIdx, :), currentDepth + 1, maxDepth, nFeatures);
    else
        tree.left.isLeaf = true;
        tree.left.size = 0;
    end
    
    if any(rightIdx)
        tree.right = buildIsolationTree(data(rightIdx, :), currentDepth + 1, maxDepth, nFeatures);
    else
        tree.right.isLeaf = true;
        tree.right.size = 0;
    end

end

function pathLength = getPathLength(tree, sample)
%GETPATHLENGTH Calculate path length for a sample in isolation tree
%   Calculates the path length from root to leaf for a given sample
%
%   Inputs:
%       tree   - Isolation tree
%       sample - Sample to evaluate
%
%   Output:
%       pathLength - Path length from root to leaf

    pathLength = getPathLengthRecursive(tree, sample, 0);

end

function pathLength = getPathLengthRecursive(tree, sample, currentDepth)
%GETPATHLENGTHRECURSIVE Recursive helper for path length calculation

    if tree.isLeaf
        % Add average path length for remaining samples in leaf
        if tree.size > 1
            pathLength = currentDepth + averagePathLength(tree.size);
        else
            pathLength = currentDepth;
        end
        return;
    end
    
    % Navigate to appropriate subtree
    if sample(tree.feature) < tree.splitPoint
        pathLength = getPathLengthRecursive(tree.left, sample, currentDepth + 1);
    else
        pathLength = getPathLengthRecursive(tree.right, sample, currentDepth + 1);
    end

end

function avgPath = averagePathLength(n)
%AVERAGEPATHLENGTH Calculate average path length for BST with n samples
%   Calculates the average path length in a Binary Search Tree with n samples
%
%   Input:
%       n - Number of samples
%
%   Output:
%       avgPath - Average path length

    if n <= 1
        avgPath = 0;
    else
        avgPath = 2 * (log(n-1) + 0.5772156649) - 2*(n-1)/n; % Euler-Mascheroni constant
    end

end

function yPred = predictIsolationForest(model, XTest)
%PREDICTISOLATIONFOREST Predict anomalies using Isolation Forest
%   Predicts anomalies on test data using trained Isolation Forest
%
%   Inputs:
%       model - Trained Isolation Forest model
%       XTest - Test data
%
%   Output:
%       yPred - Predicted labels (1 = anomaly, 0 = normal)

    nSamples = size(XTest, 1);
    
    if strcmp(model.type, 'IsolationForest')
        % Calculate average path length for each test sample
        pathLengths = zeros(nSamples, 1);
        
        for i = 1:nSamples
            lengths = zeros(model.nTrees, 1);
            for t = 1:model.nTrees
                lengths(t) = getPathLength(model.trees{t}, XTest(i, :));
            end
            pathLengths(i) = mean(lengths);
        end
        
        % Predict anomalies (shorter path = more anomalous)
        yPred = double(pathLengths < model.threshold);
        
    else
        % Use outlier detection fallback
        zScores = abs((XTest - model.mean) ./ model.std);
        maxZScores = max(zScores, [], 2);
        yPred = double(maxZScores > model.threshold);
    end

end