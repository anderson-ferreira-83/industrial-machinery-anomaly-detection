import scipy.io
import h5py
import numpy as np
import pandas as pd

def load_mat_file(filename):
    """Try to load MATLAB file with both scipy and h5py"""
    try:
        # Try scipy.io first (for older MATLAB files)
        data = scipy.io.loadmat(filename)
        print(f"Loaded {filename} with scipy.io")
        return data
    except:
        try:
            # Try h5py for v7.3 files
            with h5py.File(filename, 'r') as f:
                data = {key: f[key][:] for key in f.keys() if not key.startswith('#')}
            print(f"Loaded {filename} with h5py")
            return data
        except Exception as e:
            print(f"Error loading {filename}: {e}")
            return None

# Load MATLAB data files
print("Loading MachineData.mat...")
machine_data = load_mat_file('vibrationData/MachineData.mat')

print("Loading FeatureEntire.mat...")
feature_data = load_mat_file('vibrationData/FeatureEntire.mat')

if machine_data:
    print("=== MachineData.mat Structure ===")
    for key in machine_data.keys():
        if not key.startswith('__'):
            data = machine_data[key]
            print(f"{key}: {type(data)}")
            if hasattr(data, 'shape'):
                print(f"  Shape: {data.shape}")
            
            # Try to extract actual data if it's a MATLAB object
            if hasattr(data, '_fieldnames'):
                print(f"  Field names: {data._fieldnames}")
            
            # For scipy structures, try to get the actual data
            try:
                if key == 'trainData':
                    # Try to extract the table structure
                    print(f"  Data type: {type(data)}")
                    if hasattr(data, 'flat'):
                        flat_data = data.flat[0]
                        print(f"  Flat data type: {type(flat_data)}")
                        if hasattr(flat_data, '_fieldnames'):
                            print(f"  Flat field names: {flat_data._fieldnames}")
            except Exception as e:
                print(f"  Error extracting: {e}")

if feature_data:
    print("\n=== FeatureEntire.mat Structure ===")
    for key in feature_data.keys():
        if not key.startswith('__') and key != 'featureAll':
            data = feature_data[key]
            print(f"{key}: {type(data)} - Shape: {data.shape if hasattr(data, 'shape') else 'N/A'}")
    
    # Let's examine featureAll in detail
    if 'featureAll' in feature_data:
        print(f"\nfeatureAll details:")
        feat_data = feature_data['featureAll']
        print(f"  Type: {type(feat_data)}")
        print(f"  Shape: {feat_data.shape}")
        print(f"  Content: {feat_data}")

# Let's also check what files we have
import os
print(f"\nFiles in vibrationData directory:")
for file in os.listdir('vibrationData'):
    print(f"  {file}")
    
# Check file sizes to understand the data better
for file in ['MachineData.mat', 'FeatureEntire.mat']:
    size = os.path.getsize(f'vibrationData/{file}')
    print(f"{file}: {size} bytes ({size/1024:.1f} KB)")