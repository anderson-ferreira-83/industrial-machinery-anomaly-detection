# Industrial Machinery Anomaly Detection using 3-Axis Vibration Data

This project implements anomaly detection for industrial machinery using 3-axis vibration data, based on the MATLAB Predictive Maintenance Toolbox example. The MATLAB implementation includes three different anomaly detection approaches:

1. **One-Class SVM**: Identifies abnormalities "far" from normal data
2. **Isolation Forest**: Uses decision trees to isolate observations
3. **Autoencoder Neural Network**: Reconstructs normal data with low error

## Features

- **Synthetic Data Generation**: Creates realistic 3-axis vibration data with normal and anomalous patterns
- **Feature Extraction**: Implements 12 key features across 3 channels:
  - Channel 1: Crest Factor, Kurtosis, RMS, Standard Deviation
  - Channel 2: Mean, RMS, Skewness, Standard Deviation  
  - Channel 3: Crest Factor, SINAD, SNR, THD
- **Multiple Models**: Compares three different anomaly detection approaches
- **Comprehensive Evaluation**: Provides accuracy, precision, recall, F1-score, and confusion matrices
- **Visualization**: Generates plots showing model performance

## Requirements

### MATLAB Toolboxes
- Statistics and Machine Learning Toolbox
- Signal Processing Toolbox  
- Deep Learning Toolbox (optional, for autoencoder)
- Predictive Maintenance Toolbox (optional)

## Usage

Run the main MATLAB script:

```matlab
% Navigate to MATLAB_Environment/src
cd('MATLAB_Environment/src')

% Execute main script
anomaly_detection_main
```

## Results

The implementation achieves the following performance on synthetic data:

- **Isolation Forest**: Best overall performance (91.4% accuracy)
- **One-Class SVM**: High recall for anomaly detection (100% recall)
- **Autoencoder**: High precision but lower recall (100% precision, 30% recall)

## Key Concepts

### Anomaly Detection in Machinery

Anomaly detection in machinery is challenging because:
- More normal behavior data is typically available than anomalous behavior
- Training is done primarily on normal (post-maintenance) data
- Models must identify deviations that indicate potential failures

### Feature Engineering

The 12 extracted features capture different aspects of vibration:
- **Time Domain**: RMS, Standard Deviation, Mean, Kurtosis, Skewness, Crest Factor
- **Frequency Domain**: SINAD, SNR, THD

### Model Characteristics

1. **One-Class SVM**: 
   - Works well when normal data forms tight clusters
   - Sensitive to hyperparameter tuning
   - Good for identifying outliers

2. **Isolation Forest**:
   - Ensemble method using random forests
   - Effective for high-dimensional data
   - Less sensitive to hyperparameters

3. **Autoencoder**:
   - Deep learning approach
   - Learns compressed representation of normal data
   - Reconstruction error indicates anomalies

## File Structure

- `MATLAB_Environment/src/anomaly_detection_main.m`: Main implementation
- `MATLAB_Environment/functions/`: MATLAB function library
- `MATLAB_Environment/data/`: Data directory
- `MATLAB_Environment/results/`: Generated results and visualizations

## References

- <a href="https://www.mathworks.com/help/predmaint/ug/anomaly-detection-using-3-axis-vibration-data.html" target="_blank">MATLAB Predictive Maintenance Toolbox: Anomaly Detection Using 3-Axis Vibration Data</a>