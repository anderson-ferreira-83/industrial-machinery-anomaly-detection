function model = trainOneClassSVM(XTrain)
%TRAINONECLASSSVM Train One-Class SVM for anomaly detection
%   Trains a One-Class SVM model using only normal data
%
%   Input:
%       XTrain - Training data (normal samples only)
%
%   Output:
%       model - Trained One-Class SVM model structure

    fprintf('Training One-Class SVM...\n');
    
    % Check if Statistics and Machine Learning Toolbox is available
    if ~license('test', 'Statistics_Toolbox')
        error('Statistics and Machine Learning Toolbox is required for One-Class SVM');
    end
    
    try
        % Train One-Class SVM using fitcsvm
        % Note: MATLAB's fitcsvm doesn't have direct one-class support
        % We'll use a workaround by creating artificial negative samples
        
        [nSamples, nFeatures] = size(XTrain);
        
        % Create artificial outlier samples for binary classification
        % Generate samples outside the normal data distribution
        means = mean(XTrain, 1);
        stds = std(XTrain, 0, 1);
        
        % Generate outliers at 3-5 standard deviations from mean
        nOutliers = floor(nSamples * 0.1); % 10% outliers
        outliers = zeros(nOutliers, nFeatures);
        
        for i = 1:nOutliers
            % Random direction
            direction = randn(1, nFeatures);
            direction = direction / norm(direction);
            
            % Random distance (3-5 standard deviations)
            distance = 3 + 2*rand();
            
            % Generate outlier
            outliers(i, :) = means + distance * stds .* direction;
        end
        
        % Combine normal and outlier data
        X_combined = [XTrain; outliers];
        y_combined = [ones(nSamples, 1); -ones(nOutliers, 1)]; % 1 for normal, -1 for outlier
        
        % Train SVM
        svmModel = fitcsvm(X_combined, y_combined, ...
                          'KernelFunction', 'rbf', ...
                          'KernelScale', 'auto', ...
                          'Standardize', false); % Already standardized
        
        % Store model parameters
        model.type = 'OneClassSVM';
        model.svmModel = svmModel;
        model.threshold = 0; % Decision boundary
        model.trainData = XTrain;
        model.nSupportVectors = size(svmModel.SupportVectors, 1);
        
        fprintf('  One-Class SVM training completed.\n');
        fprintf('  Support vectors: %d\n', model.nSupportVectors);
        
    catch ME
        % Fallback: Use simple statistical approach if SVM fails
        warning('SVM training failed. Using statistical approach instead.');
        
        model.type = 'Statistical';
        model.mean = mean(XTrain, 1);
        model.cov = cov(XTrain);
        
        % Use Mahalanobis distance threshold (95th percentile)
        distances = mahal(XTrain, XTrain);
        model.threshold = prctile(distances, 95);
        
        fprintf('  Statistical model trained as fallback.\n');
    end

end

function yPred = predictOneClassSVM(model, XTest)
%PREDICTONECLASSSVM Predict anomalies using One-Class SVM
%   Predicts anomalies on test data using trained One-Class SVM
%
%   Inputs:
%       model - Trained One-Class SVM model
%       XTest - Test data
%
%   Output:
%       yPred - Predicted labels (1 = anomaly, 0 = normal)

    if strcmp(model.type, 'OneClassSVM')
        % Use SVM model
        [~, scores] = predict(model.svmModel, XTest);
        % Convert to binary predictions (1 = anomaly, 0 = normal)
        yPred = double(scores(:, 2) < model.threshold); % Positive class is normal
        
    else
        % Use statistical model (Mahalanobis distance)
        distances = mahal(XTest, model.trainData);
        yPred = double(distances > model.threshold);
    end

end