function featureNames = getFeatureNames()
%GETFEATURENAMES Return the names of extracted features
%   Returns a cell array with the names of all features extracted from
%   the 3-axis vibration data
%
%   Output:
%       featureNames - Cell array of feature names

    featureNames = {
        'Ch1_CrestFactor',  % Channel 1: Crest Factor
        'Ch1_Kurtosis',     % Channel 1: Kurtosis  
        'Ch1_RMS',          % Channel 1: RMS
        'Ch1_StdDev',       % Channel 1: Standard Deviation
        'Ch2_Mean',         % Channel 2: Mean
        'Ch2_RMS',          % Channel 2: RMS
        'Ch2_Skewness',     % Channel 2: Skewness
        'Ch2_StdDev',       % Channel 2: Standard Deviation
        'Ch3_CrestFactor',  % Channel 3: Crest Factor
        'Ch3_SINAD',        % Channel 3: SINAD (Signal-to-Noise and Distortion Ratio)
        'Ch3_SNR',          % Channel 3: SNR (Signal-to-Noise Ratio)
        'Ch3_THD'           % Channel 3: THD (Total Harmonic Distortion)
    };

end