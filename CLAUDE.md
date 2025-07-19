# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a dual-environment industrial machinery anomaly detection project using 3-axis vibration data. The project implements the same functionality in both Python and MATLAB, allowing users to choose their preferred environment.

## Commands

### Python Environment
```bash
# Navigate to Python environment
cd Python_Environment

# Install dependencies
pip install -r requirements/requirements.txt

# Run main anomaly detection pipeline
python src/vibration_anomaly_detection.py

# Launch Jupyter notebook for interactive analysis
jupyter lab notebooks/vibration_anomaly_detection.ipynb

# Run data examination utilities
python src/examine_data.py
python src/extract_matlab_data.py
```

### MATLAB Environment
```matlab
% Navigate to MATLAB source directory
cd('MATLAB_Environment/src')

% Run main anomaly detection pipeline
anomaly_detection_main

% Individual function examples
addpath('../functions')
[data, labels] = generateSyntheticVibrationData();
features = extractVibrationFeatures(data);
```

### Testing
```bash
# Python tests (if implemented)
cd Python_Environment
python -m pytest tests/

# No automated tests for MATLAB environment
```

## Architecture

### Dual Environment Structure
- **Python_Environment/**: Complete Python implementation using scikit-learn and TensorFlow
- **MATLAB_Environment/**: Complete MATLAB implementation following Predictive Maintenance Toolbox patterns

### Core Components

#### Python Implementation (`Python_Environment/src/`)
- `vibration_anomaly_detection.py`: Main class `VibrationAnomalyDetector` with complete pipeline
- `examine_data.py`: Data exploration utilities
- `extract_matlab_data.py`: MATLAB data conversion utilities
- `notebooks/vibration_anomaly_detection.ipynb`: Interactive analysis notebook

#### MATLAB Implementation (`MATLAB_Environment/`)
- `src/anomaly_detection_main.m`: Main pipeline script
- `functions/`: Modular functions for each processing step
  - `generateSyntheticVibrationData.m`: Data generation
  - `extractVibrationFeatures.m`: Feature extraction (12 features across 3 channels)
  - `trainOneClassSVM.m` & `trainIsolationForest.m`: Model training
  - `evaluateModel.m`: Model evaluation utilities

### Feature Engineering
Both environments extract 12 features from 3-axis vibration data:
- **Channel 1**: Crest Factor, Kurtosis, RMS, Standard Deviation
- **Channel 2**: Mean, RMS, Skewness, Standard Deviation  
- **Channel 3**: Crest Factor, SINAD, SNR, THD

### Models Implemented
1. **One-Class SVM**: Boundary-based anomaly detection
2. **Isolation Forest**: Tree-based anomaly detection
3. **Autoencoder**: Neural network-based reconstruction error detection

## Development Notes

### Python Dependencies
- Core: numpy, pandas, scipy, scikit-learn, tensorflow
- Visualization: matplotlib, seaborn
- Jupyter: jupyter, ipykernel, ipywidgets
- Utilities: h5py, tqdm

### MATLAB Requirements
- Statistics and Machine Learning Toolbox (required)
- Signal Processing Toolbox (required)
- Deep Learning Toolbox (optional, for autoencoder)
- Predictive Maintenance Toolbox (optional, for advanced features)

### Data Flow
1. **Data Generation/Loading**: Synthetic vibration signals or real .mat files
2. **Feature Extraction**: 12 statistical/frequency domain features
3. **Data Preprocessing**: Normalization and train/test split
4. **Model Training**: Three different anomaly detection approaches
5. **Evaluation**: Performance metrics and visualizations
6. **Results Export**: Models and predictions saved to respective results/ directories

### Cross-Environment Compatibility
Both environments are designed to produce comparable results using equivalent algorithms and feature extraction methods. The Python implementation focuses on modern ML libraries while MATLAB follows industry-standard predictive maintenance patterns.