import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.svm import OneClassSVM
from sklearn.ensemble import IsolationForest
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import classification_report, confusion_matrix
import tensorflow as tf
from tensorflow import keras
import warnings
warnings.filterwarnings('ignore')

class VibrationAnomalyDetector:
    """
    Anomaly detection for industrial machinery using 3-axis vibration data
    Based on MATLAB Predictive Maintenance Toolbox example
    """
    
    def __init__(self):
        self.scaler = StandardScaler()
        self.models = {}
        self.feature_names = [
            'Ch1_CrestFactor', 'Ch1_Kurtosis', 'Ch1_RMS', 'Ch1_StdDev',
            'Ch2_Mean', 'Ch2_RMS', 'Ch2_Skewness', 'Ch2_StdDev',
            'Ch3_CrestFactor', 'Ch3_SINAD', 'Ch3_SNR', 'Ch3_THD'
        ]
    
    def generate_synthetic_data(self, n_normal=1000, n_anomaly=200):
        """
        Generate synthetic 3-axis vibration data with normal and anomalous behavior
        """
        np.random.seed(42)
        
        # Normal data (after maintenance)
        normal_data = []
        for i in range(n_normal):
            # Channel 1 features (normal vibration patterns)
            ch1_crest = np.random.normal(3.2, 0.3)  # Crest Factor
            ch1_kurt = np.random.normal(3.1, 0.2)   # Kurtosis
            ch1_rms = np.random.normal(0.15, 0.02)  # RMS
            ch1_std = np.random.normal(0.12, 0.015) # Standard Deviation
            
            # Channel 2 features
            ch2_mean = np.random.normal(0.001, 0.0005)  # Mean
            ch2_rms = np.random.normal(0.14, 0.018)     # RMS
            ch2_skew = np.random.normal(0.05, 0.02)     # Skewness
            ch2_std = np.random.normal(0.11, 0.012)     # Standard Deviation
            
            # Channel 3 features
            ch3_crest = np.random.normal(3.1, 0.25)  # Crest Factor
            ch3_sinad = np.random.normal(42, 2)      # SINAD
            ch3_snr = np.random.normal(38, 1.5)      # SNR
            ch3_thd = np.random.normal(0.08, 0.01)   # THD
            
            normal_data.append([
                ch1_crest, ch1_kurt, ch1_rms, ch1_std,
                ch2_mean, ch2_rms, ch2_skew, ch2_std,
                ch3_crest, ch3_sinad, ch3_snr, ch3_thd
            ])
        
        # Anomalous data (before maintenance - degraded conditions)
        anomaly_data = []
        for i in range(n_anomaly):
            # Channel 1 features (anomalous - higher vibrations, different patterns)
            ch1_crest = np.random.normal(4.8, 0.5)    # Higher crest factor
            ch1_kurt = np.random.normal(5.2, 0.8)     # Higher kurtosis
            ch1_rms = np.random.normal(0.35, 0.08)    # Higher RMS
            ch1_std = np.random.normal(0.28, 0.05)    # Higher standard deviation
            
            # Channel 2 features (anomalous)
            ch2_mean = np.random.normal(0.008, 0.003)  # Higher mean
            ch2_rms = np.random.normal(0.32, 0.06)     # Higher RMS
            ch2_skew = np.random.normal(0.25, 0.08)    # Higher skewness
            ch2_std = np.random.normal(0.25, 0.04)     # Higher standard deviation
            
            # Channel 3 features (anomalous)
            ch3_crest = np.random.normal(5.1, 0.6)   # Higher crest factor
            ch3_sinad = np.random.normal(28, 4)      # Lower SINAD (more distortion)
            ch3_snr = np.random.normal(22, 3)        # Lower SNR (more noise)
            ch3_thd = np.random.normal(0.18, 0.03)   # Higher THD (more distortion)
            
            anomaly_data.append([
                ch1_crest, ch1_kurt, ch1_rms, ch1_std,
                ch2_mean, ch2_rms, ch2_skew, ch2_std,
                ch3_crest, ch3_sinad, ch3_snr, ch3_thd
            ])
        
        # Combine data
        X_normal = np.array(normal_data)
        X_anomaly = np.array(anomaly_data)
        
        # Create labels (0 = normal, 1 = anomaly)
        y_normal = np.zeros(n_normal)
        y_anomaly = np.ones(n_anomaly)
        
        X = np.vstack([X_normal, X_anomaly])
        y = np.hstack([y_normal, y_anomaly])
        
        # Create DataFrame
        df = pd.DataFrame(X, columns=self.feature_names)
        df['label'] = y
        df['condition'] = ['Normal' if label == 0 else 'Anomaly' for label in y]
        
        return df
    
    def prepare_data(self, df):
        """
        Prepare data for training - split and scale
        """
        # Features and labels
        X = df[self.feature_names].values
        y = df['label'].values
        
        # Split data
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.3, random_state=42, stratify=y
        )
        
        # For anomaly detection, we typically train only on normal data
        X_train_normal = X_train[y_train == 0]
        
        # Scale the data
        X_train_normal_scaled = self.scaler.fit_transform(X_train_normal)
        X_test_scaled = self.scaler.transform(X_test)
        
        return X_train_normal_scaled, X_test_scaled, y_test
    
    def train_one_class_svm(self, X_train_normal):
        """
        Train One-Class SVM for anomaly detection
        """
        print("Training One-Class SVM...")
        
        # One-Class SVM
        oc_svm = OneClassSVM(nu=0.05, kernel='rbf', gamma='scale')
        oc_svm.fit(X_train_normal)
        
        self.models['OneClassSVM'] = oc_svm
        print("One-Class SVM training completed.")
    
    def train_isolation_forest(self, X_train_normal):
        """
        Train Isolation Forest for anomaly detection
        """
        print("Training Isolation Forest...")
        
        # Isolation Forest
        iso_forest = IsolationForest(contamination=0.1, random_state=42)
        iso_forest.fit(X_train_normal)
        
        self.models['IsolationForest'] = iso_forest
        print("Isolation Forest training completed.")
    
    def build_autoencoder(self, input_dim):
        """
        Build autoencoder neural network
        """
        # Encoder
        encoder = keras.Sequential([
            keras.layers.Dense(8, activation='relu', input_shape=(input_dim,)),
            keras.layers.Dense(4, activation='relu'),
            keras.layers.Dense(2, activation='relu')  # Bottleneck layer
        ])
        
        # Decoder
        decoder = keras.Sequential([
            keras.layers.Dense(4, activation='relu', input_shape=(2,)),
            keras.layers.Dense(8, activation='relu'),
            keras.layers.Dense(input_dim, activation='linear')
        ])
        
        # Autoencoder
        autoencoder = keras.Sequential([encoder, decoder])
        autoencoder.compile(optimizer='adam', loss='mse')
        
        return autoencoder
    
    def train_autoencoder(self, X_train_normal):
        """
        Train autoencoder for anomaly detection
        """
        print("Training Autoencoder...")
        
        # Build and train autoencoder
        autoencoder = self.build_autoencoder(X_train_normal.shape[1])
        
        # Train on normal data only
        history = autoencoder.fit(
            X_train_normal, X_train_normal,
            epochs=100,
            batch_size=32,
            validation_split=0.2,
            verbose=0
        )
        
        self.models['Autoencoder'] = autoencoder
        print("Autoencoder training completed.")
        
        return history
    
    def predict_anomalies(self, X_test):
        """
        Predict anomalies using all trained models
        """
        predictions = {}
        
        # One-Class SVM predictions
        if 'OneClassSVM' in self.models:
            oc_pred = self.models['OneClassSVM'].predict(X_test)
            # Convert -1 (anomaly) to 1, and 1 (normal) to 0
            predictions['OneClassSVM'] = (oc_pred == -1).astype(int)
        
        # Isolation Forest predictions
        if 'IsolationForest' in self.models:
            iso_pred = self.models['IsolationForest'].predict(X_test)
            # Convert -1 (anomaly) to 1, and 1 (normal) to 0
            predictions['IsolationForest'] = (iso_pred == -1).astype(int)
        
        # Autoencoder predictions
        if 'Autoencoder' in self.models:
            # Reconstruct data
            reconstructed = self.models['Autoencoder'].predict(X_test, verbose=0)
            # Calculate reconstruction error
            mse = np.mean(np.square(X_test - reconstructed), axis=1)
            # Use threshold to classify (using 95th percentile of reconstruction errors)
            threshold = np.percentile(mse, 95)
            predictions['Autoencoder'] = (mse > threshold).astype(int)
        
        return predictions
    
    def evaluate_models(self, y_true, predictions):
        """
        Evaluate model performance
        """
        results = {}
        
        for model_name, y_pred in predictions.items():
            print(f"\n=== {model_name} Results ===")
            
            # Classification report
            report = classification_report(y_true, y_pred, target_names=['Normal', 'Anomaly'])
            print(report)
            
            # Confusion matrix
            cm = confusion_matrix(y_true, y_pred)
            print(f"Confusion Matrix:\n{cm}")
            
            # Calculate metrics
            tn, fp, fn, tp = cm.ravel()
            accuracy = (tp + tn) / (tp + tn + fp + fn)
            precision = tp / (tp + fp) if (tp + fp) > 0 else 0
            recall = tp / (tp + fn) if (tp + fn) > 0 else 0
            f1 = 2 * (precision * recall) / (precision + recall) if (precision + recall) > 0 else 0
            
            results[model_name] = {
                'accuracy': accuracy,
                'precision': precision,
                'recall': recall,
                'f1_score': f1,
                'confusion_matrix': cm
            }
        
        return results
    
    def plot_results(self, df, predictions, y_test):
        """
        Visualize results
        """
        fig, axes = plt.subplots(2, 2, figsize=(15, 12))
        
        # Plot 1: Feature distribution (normal vs anomaly)
        axes[0, 0].scatter(df[df['label']==0]['Ch1_RMS'], 
                          df[df['label']==0]['Ch1_Kurtosis'], 
                          alpha=0.6, label='Normal', c='blue')
        axes[0, 0].scatter(df[df['label']==1]['Ch1_RMS'], 
                          df[df['label']==1]['Ch1_Kurtosis'], 
                          alpha=0.6, label='Anomaly', c='red')
        axes[0, 0].set_xlabel('Channel 1 RMS')
        axes[0, 0].set_ylabel('Channel 1 Kurtosis')
        axes[0, 0].set_title('Ground Truth: Normal vs Anomaly')
        axes[0, 0].legend()
        
        # Plot 2-4: Model predictions
        model_names = list(predictions.keys())
        colors = ['green', 'orange', 'purple']
        
        for i, (model_name, y_pred) in enumerate(predictions.items()):
            if i < 3:  # Only plot first 3 models
                row = (i + 1) // 2
                col = (i + 1) % 2
                
                normal_idx = y_pred == 0
                anomaly_idx = y_pred == 1
                
                axes[row, col].scatter(range(np.sum(normal_idx)), 
                                     np.sum(normal_idx) * [0], 
                                     alpha=0.6, label='Predicted Normal', c='blue')
                axes[row, col].scatter(range(np.sum(anomaly_idx)), 
                                     np.sum(anomaly_idx) * [1], 
                                     alpha=0.6, label='Predicted Anomaly', c='red')
                axes[row, col].set_title(f'{model_name} Predictions')
                axes[row, col].set_ylabel('Prediction')
                axes[row, col].legend()
        
        plt.tight_layout()
        plt.savefig('../results/anomaly_detection_results.png', dpi=300, bbox_inches='tight')
        plt.show()

def main():
    """
    Main function to run the anomaly detection pipeline
    """
    print("=== Industrial Machinery Anomaly Detection ===")
    print("Based on MATLAB Predictive Maintenance Toolbox example")
    
    # Initialize detector
    detector = VibrationAnomalyDetector()
    
    # Generate synthetic data
    print("\n1. Generating synthetic vibration data...")
    df = detector.generate_synthetic_data()
    print(f"Generated {len(df)} samples with {df['label'].sum()} anomalies")
    
    # Prepare data
    print("\n2. Preparing data...")
    X_train_normal, X_test, y_test = detector.prepare_data(df)
    print(f"Training set (normal only): {X_train_normal.shape[0]} samples")
    print(f"Test set: {X_test.shape[0]} samples")
    
    # Train models
    print("\n3. Training anomaly detection models...")
    detector.train_one_class_svm(X_train_normal)
    detector.train_isolation_forest(X_train_normal)
    detector.train_autoencoder(X_train_normal)
    
    # Make predictions
    print("\n4. Making predictions...")
    predictions = detector.predict_anomalies(X_test)
    
    # Evaluate models
    print("\n5. Evaluating models...")
    results = detector.evaluate_models(y_test, predictions)
    
    # Plot results
    print("\n6. Generating visualizations...")
    detector.plot_results(df, predictions, y_test)
    
    # Summary
    print("\n=== Summary ===")
    for model_name, metrics in results.items():
        print(f"{model_name}: Accuracy={metrics['accuracy']:.3f}, "
              f"Precision={metrics['precision']:.3f}, "
              f"Recall={metrics['recall']:.3f}, "
              f"F1={metrics['f1_score']:.3f}")

if __name__ == "__main__":
    main()