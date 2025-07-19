function evaluateModel(yTrue, yPred, modelName)
%EVALUATEMODEL Evaluate anomaly detection model performance
%   Calculates and displays comprehensive performance metrics
%
%   Inputs:
%       yTrue     - True labels (0 = normal, 1 = anomaly)
%       yPred     - Predicted labels (0 = normal, 1 = anomaly)
%       modelName - Name of the model for display

    % Calculate confusion matrix
    cm = confusionmat(yTrue, yPred);
    
    % Handle edge cases
    if size(cm, 1) == 1
        if unique(yTrue) == 0
            cm = [cm, 0; 0, 0]; % All true are normal
        else
            cm = [0, 0; 0, cm]; % All true are anomalies
        end
    end
    
    % Extract confusion matrix components
    if size(cm, 1) >= 2 && size(cm, 2) >= 2
        tn = cm(1, 1); % True Negatives (normal predicted as normal)
        fp = cm(1, 2); % False Positives (normal predicted as anomaly)
        fn = cm(2, 1); % False Negatives (anomaly predicted as normal)
        tp = cm(2, 2); % True Positives (anomaly predicted as anomaly)
    else
        % Handle degenerate cases
        tn = sum(yTrue == 0 & yPred == 0);
        fp = sum(yTrue == 0 & yPred == 1);
        fn = sum(yTrue == 1 & yPred == 0);
        tp = sum(yTrue == 1 & yPred == 1);
    end
    
    % Calculate metrics
    accuracy = (tp + tn) / (tp + tn + fp + fn);
    
    if (tp + fp) > 0
        precision = tp / (tp + fp);
    else
        precision = 0;
    end
    
    if (tp + fn) > 0
        recall = tp / (tp + fn);
    else
        recall = 0;
    end
    
    if (precision + recall) > 0
        f1Score = 2 * (precision * recall) / (precision + recall);
    else
        f1Score = 0;
    end
    
    if (tn + fp) > 0
        specificity = tn / (tn + fp);
    else
        specificity = 0;
    end
    
    % Display results
    fprintf('\n📊 %s Performance Metrics:\n', modelName);
    fprintf('   ────────────────────────────────\n');
    fprintf('   Accuracy:     %.3f (%.1f%%)\n', accuracy, accuracy * 100);
    fprintf('   Precision:    %.3f (%.1f%%)\n', precision, precision * 100);
    fprintf('   Recall:       %.3f (%.1f%%)\n', recall, recall * 100);
    fprintf('   Specificity:  %.3f (%.1f%%)\n', specificity, specificity * 100);
    fprintf('   F1-Score:     %.3f\n', f1Score);
    fprintf('\n');
    
    % Display confusion matrix
    fprintf('   Confusion Matrix:\n');
    fprintf('                Predicted\n');
    fprintf('              Normal  Anomaly\n');
    fprintf('   Normal      %4d    %4d\n', tn, fp);
    fprintf('   Anomaly     %4d    %4d\n', fn, tp);
    fprintf('\n');
    
    % Display interpretation
    fprintf('   📈 Interpretation:\n');
    
    if accuracy >= 0.9
        fprintf('   ✅ Excellent overall performance\n');
    elseif accuracy >= 0.8
        fprintf('   ✅ Good overall performance\n');
    elseif accuracy >= 0.7
        fprintf('   ⚠️  Moderate performance\n');
    else
        fprintf('   ❌ Poor performance - consider tuning\n');
    end
    
    if recall >= 0.9
        fprintf('   ✅ Excellent anomaly detection (high recall)\n');
    elseif recall >= 0.7
        fprintf('   ✅ Good anomaly detection\n');
    else
        fprintf('   ⚠️  Missing many anomalies (low recall)\n');
    end
    
    if precision >= 0.9
        fprintf('   ✅ Very few false alarms (high precision)\n');
    elseif precision >= 0.7
        fprintf('   ✅ Acceptable false alarm rate\n');
    else
        fprintf('   ⚠️  High false alarm rate (low precision)\n');
    end
    
    % Additional insights
    totalSamples = tp + tn + fp + fn;
    anomalyRate = (tp + fn) / totalSamples;
    detectionRate = tp / totalSamples;
    
    fprintf('\n   📊 Additional Statistics:\n');
    fprintf('   • Total samples: %d\n', totalSamples);
    fprintf('   • True anomaly rate: %.1f%%\n', anomalyRate * 100);
    fprintf('   • Detected anomaly rate: %.1f%%\n', detectionRate * 100);
    fprintf('   • False alarm rate: %.1f%%\n', (fp / totalSamples) * 100);

end