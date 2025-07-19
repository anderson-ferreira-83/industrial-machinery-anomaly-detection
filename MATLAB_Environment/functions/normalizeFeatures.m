function [normalizedFeatures, scalingParams] = normalizeFeatures(features)
%NORMALIZEFEATURES Normalize features using z-score standardization
%   Normalizes features to have zero mean and unit variance
%
%   Inputs:
%       features - Feature matrix (nSamples x nFeatures)
%
%   Outputs:
%       normalizedFeatures - Normalized feature matrix
%       scalingParams      - Structure containing mean and std for each feature

    % Calculate mean and standard deviation for each feature
    featureMeans = mean(features, 1);
    featureStds = std(features, 0, 1);
    
    % Avoid division by zero
    featureStds(featureStds == 0) = 1;
    
    % Normalize features
    normalizedFeatures = (features - featureMeans) ./ featureStds;
    
    % Store scaling parameters
    scalingParams.means = featureMeans;
    scalingParams.stds = featureStds;
    
    fprintf('Feature normalization completed.\n');
    fprintf('  Features normalized: %d\n', size(features, 2));
    fprintf('  Samples normalized: %d\n', size(features, 1));

end

function normalizedFeatures = applyNormalization(features, scalingParams)
%APPLYNORMALIZATION Apply pre-computed normalization to new data
%   Applies the normalization parameters computed on training data to new data
%
%   Inputs:
%       features      - Feature matrix to normalize
%       scalingParams - Scaling parameters from normalizeFeatures
%
%   Output:
%       normalizedFeatures - Normalized feature matrix

    normalizedFeatures = (features - scalingParams.means) ./ scalingParams.stds;

end