%% Industrial Machinery Anomaly Detection using 3-Axis Vibration Data
% This script implements anomaly detection for industrial machinery using
% 3-axis vibration data, based on the MATLAB Predictive Maintenance Toolbox

%% Clear workspace and command window
clear; clc; close all;

fprintf('=== Industrial Machinery Anomaly Detection ===\n');
fprintf('MATLAB Implementation\n\n');

%% Add paths
addpath('functions');
addpath('../data');

%% 1. Load or Generate Data
fprintf('1. Loading vibration data...\n');

try
    % Try to load real MATLAB data
    load('../data/vibrationData/MachineData.mat');
    load('../data/vibrationData/FeatureEntire.mat');
    fprintf('   Real data loaded successfully.\n');
    
    % If real data is available, extract and process it
    % [This section would need to be customized based on actual data structure]
    
catch
    % Generate synthetic data if real data is not available
    fprintf('   Real data not found. Generating synthetic data...\n');
    [vibrationData, labels] = generateSyntheticVibrationData();
    fprintf('   Synthetic data generated: %d samples\n', size(vibrationData, 1));
end

%% 2. Feature Extraction
fprintf('\n2. Extracting features from vibration signals...\n');

% Extract features for each channel
features = extractVibrationFeatures(vibrationData);
featureNames = getFeatureNames();

fprintf('   Features extracted: %d features per sample\n', size(features, 2));
fprintf('   Feature names: ');
fprintf('%s, ', featureNames{1:end-1});
fprintf('%s\n', featureNames{end});

%% 3. Data Preparation
fprintf('\n3. Preparing data for training...\n');

% Split data into training and testing sets
[XTrain, XTest, yTrain, yTest] = splitData(features, labels, 0.7);

% Extract only normal data for training (anomaly detection approach)
normalIdx = (yTrain == 0);
XTrainNormal = XTrain(normalIdx, :);

% Normalize features
[XTrainNormalScaled, scalingParams] = normalizeFeatures(XTrainNormal);
XTestScaled = applyNormalization(XTest, scalingParams);

fprintf('   Training samples (normal only): %d\n', size(XTrainNormalScaled, 1));
fprintf('   Test samples: %d\n', size(XTestScaled, 1));
fprintf('   Test anomalies: %d (%.1f%%)\n', sum(yTest), 100*mean(yTest));

%% 4. Train Anomaly Detection Models
fprintf('\n4. Training anomaly detection models...\n');

% One-Class SVM
fprintf('   Training One-Class SVM...\n');
ocSVMModel = trainOneClassSVM(XTrainNormalScaled);

% Isolation Forest (using Statistics and Machine Learning Toolbox)
fprintf('   Training Isolation Forest...\n');
isoForestModel = trainIsolationForest(XTrainNormalScaled);

% Autoencoder (using Deep Learning Toolbox)
if license('test', 'Neural_Network_Toolbox')
    fprintf('   Training Autoencoder...\n');
    autoencoderModel = trainAutoencoder(XTrainNormalScaled);
else
    fprintf('   Deep Learning Toolbox not available. Skipping Autoencoder.\n');
    autoencoderModel = [];
end

%% 5. Make Predictions
fprintf('\n5. Making predictions...\n');

% Predict using One-Class SVM
yPredSVM = predictOneClassSVM(ocSVMModel, XTestScaled);
fprintf('   One-Class SVM: %d anomalies detected\n', sum(yPredSVM));

% Predict using Isolation Forest
yPredIsoForest = predictIsolationForest(isoForestModel, XTestScaled);
fprintf('   Isolation Forest: %d anomalies detected\n', sum(yPredIsoForest));

% Predict using Autoencoder (if available)
if ~isempty(autoencoderModel)
    yPredAutoencoder = predictAutoencoder(autoencoderModel, XTestScaled);
    fprintf('   Autoencoder: %d anomalies detected\n', sum(yPredAutoencoder));
else
    yPredAutoencoder = [];
end

%% 6. Evaluate Models
fprintf('\n6. Evaluating model performance...\n');

% Evaluate One-Class SVM
fprintf('\n=== One-Class SVM Results ===\n');
evaluateModel(yTest, yPredSVM, 'One-Class SVM');

% Evaluate Isolation Forest
fprintf('\n=== Isolation Forest Results ===\n');
evaluateModel(yTest, yPredIsoForest, 'Isolation Forest');

% Evaluate Autoencoder (if available)
if ~isempty(yPredAutoencoder)
    fprintf('\n=== Autoencoder Results ===\n');
    evaluateModel(yTest, yPredAutoencoder, 'Autoencoder');
end

%% 7. Visualize Results
fprintf('\n7. Generating visualizations...\n');

% Create comprehensive visualization
fig = figure('Name', 'Anomaly Detection Results', 'Position', [100, 100, 1200, 800]);

% Plot original data distribution
subplot(2, 3, 1);
plotDataDistribution(features, labels, featureNames);

% Plot One-Class SVM results
subplot(2, 3, 2);
plotPredictionResults(XTest, yTest, yPredSVM, 'One-Class SVM');

% Plot Isolation Forest results
subplot(2, 3, 3);
plotPredictionResults(XTest, yTest, yPredIsoForest, 'Isolation Forest');

% Plot Autoencoder results (if available)
if ~isempty(yPredAutoencoder)
    subplot(2, 3, 4);
    plotPredictionResults(XTest, yTest, yPredAutoencoder, 'Autoencoder');
end

% Plot performance comparison
subplot(2, 3, 5);
plotPerformanceComparison(yTest, yPredSVM, yPredIsoForest, yPredAutoencoder);

% Plot confusion matrices
subplot(2, 3, 6);
plotConfusionMatrices(yTest, yPredSVM, yPredIsoForest, yPredAutoencoder);

% Save figure
saveas(fig, '../results/matlab_anomaly_detection_results.png');
fprintf('   Results saved to: ../results/matlab_anomaly_detection_results.png\n');

%% 8. Save Results
fprintf('\n8. Saving results...\n');

% Save models and results
save('../results/anomaly_detection_models.mat', 'ocSVMModel', 'isoForestModel', ...
     'autoencoderModel', 'scalingParams', 'featureNames');

% Save predictions
save('../results/anomaly_detection_predictions.mat', 'yTest', 'yPredSVM', ...
     'yPredIsoForest', 'yPredAutoencoder');

fprintf('   Models and predictions saved.\n');

%% Summary
fprintf('\n=== SUMMARY ===\n');
fprintf('Implementation completed successfully!\n');
fprintf('Models trained: One-Class SVM, Isolation Forest');
if ~isempty(autoencoderModel)
    fprintf(', Autoencoder');
end
fprintf('\n');
fprintf('Check the results folder for saved models and visualizations.\n');

fprintf('\nDone!\n');