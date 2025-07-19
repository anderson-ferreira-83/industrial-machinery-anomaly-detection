import scipy.io
import h5py
import numpy as np
import pandas as pd

def extract_machine_data():
    """Extract vibration data from MachineData.mat"""
    try:
        # Load the file and examine its structure
        mat_data = scipy.io.loadmat('vibrationData/MachineData.mat', struct_as_record=False, squeeze_me=True)
        
        print("Keys in MachineData.mat:")
        for key in mat_data.keys():
            if not key.startswith('__'):
                print(f"  {key}: {type(mat_data[key])}")
        
        # Try to access the actual data
        if 'trainData' in mat_data:
            train_data = mat_data['trainData']
            print(f"\ntrainData type: {type(train_data)}")
            
            # If it's a structured array, try to access its fields
            if hasattr(train_data, 'dtype') and train_data.dtype.names:
                print(f"Field names: {train_data.dtype.names}")
                for field in train_data.dtype.names:
                    field_data = getattr(train_data, field)
                    print(f"  {field}: {type(field_data)} - Shape: {field_data.shape if hasattr(field_data, 'shape') else 'N/A'}")
            
        return mat_data
    except Exception as e:
        print(f"Error loading MachineData.mat: {e}")
        return None

def extract_feature_data():
    """Extract feature data from FeatureEntire.mat"""
    try:
        # Try h5py first since it worked before
        with h5py.File('vibrationData/FeatureEntire.mat', 'r') as f:
            print("Keys in FeatureEntire.mat:")
            for key in f.keys():
                if not key.startswith('#'):
                    data = f[key]
                    print(f"  {key}: {data.shape} - {data.dtype}")
                    
                    # Try to get actual data
                    if key == 'featureAll':
                        feature_data = data[:]
                        print(f"    Data sample: {feature_data[:5] if len(feature_data) > 5 else feature_data}")
                        return feature_data
        return None
    except Exception as e:
        print(f"Error loading FeatureEntire.mat: {e}")
        return None

# Try alternative approach - check if there are references in the data
def explore_references():
    """Look for references to actual data in the MATLAB files"""
    try:
        # Load with different options
        mat_data = scipy.io.loadmat('vibrationData/MachineData.mat', mat_dtype=True)
        
        print("\nExploring with mat_dtype=True:")
        for key in mat_data.keys():
            if not key.startswith('__'):
                data = mat_data[key]
                print(f"{key}: {type(data)}")
                if hasattr(data, 'shape'):
                    print(f"  Shape: {data.shape}")
                if hasattr(data, 'flat'):
                    print(f"  Flat content: {data.flat[:5]}")
                    
    except Exception as e:
        print(f"Error in exploration: {e}")

if __name__ == "__main__":
    print("=== Extracting Machine Data ===")
    machine_data = extract_machine_data()
    
    print("\n=== Extracting Feature Data ===")
    feature_data = extract_feature_data()
    
    print("\n=== Exploring References ===")
    explore_references()