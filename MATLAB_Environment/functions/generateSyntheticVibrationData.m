function [vibrationData, labels] = generateSyntheticVibrationData(nNormal, nAnomaly)
%GENERATESYNTHETICVIBRATIONDATA Generate synthetic 3-axis vibration data
%   This function generates synthetic vibration data for 3 channels with
%   normal and anomalous patterns similar to real industrial machinery
%
%   Inputs:
%       nNormal  - Number of normal samples (default: 1000)
%       nAnomaly - Number of anomaly samples (default: 200)
%
%   Outputs:
%       vibrationData - Matrix of size (nTotal x nChannels x nSamples)
%       labels        - Vector of labels (0 = normal, 1 = anomaly)

    if nargin < 1
        nNormal = 1000;
    end
    if nargin < 2
        nAnomaly = 200;
    end
    
    % Set random seed for reproducibility
    rng(42);
    
    % Parameters for synthetic data generation
    fs = 1000;           % Sampling frequency (Hz)
    duration = 1;        % Signal duration (seconds)
    nSamples = fs * duration;
    nChannels = 3;
    
    % Initialize data arrays
    vibrationData = zeros(nNormal + nAnomaly, nChannels, nSamples);
    labels = [zeros(nNormal, 1); ones(nAnomaly, 1)];
    
    fprintf('Generating synthetic vibration data...\n');
    fprintf('  Normal samples: %d\n', nNormal);
    fprintf('  Anomaly samples: %d\n', nAnomaly);
    fprintf('  Channels: %d\n', nChannels);
    fprintf('  Samples per signal: %d\n', nSamples);
    
    %% Generate Normal Data (Post-maintenance)
    for i = 1:nNormal
        for ch = 1:nChannels
            % Normal vibration characteristics
            switch ch
                case 1 % Channel 1 - Low frequency machinery vibration
                    % Fundamental frequency around 30 Hz
                    f1 = 30 + 5*randn();
                    % Harmonics
                    f2 = 2*f1 + 2*randn();
                    f3 = 3*f1 + 3*randn();
                    
                    % Amplitudes (normal levels)
                    A1 = 0.1 + 0.02*randn();
                    A2 = 0.05 + 0.01*randn();
                    A3 = 0.02 + 0.005*randn();
                    
                case 2 % Channel 2 - Medium frequency bearing vibration
                    % Bearing characteristic frequencies
                    f1 = 150 + 20*randn();
                    f2 = 2.5*f1 + 10*randn();
                    f3 = 4*f1 + 15*randn();
                    
                    % Amplitudes (normal levels)
                    A1 = 0.08 + 0.015*randn();
                    A2 = 0.04 + 0.008*randn();
                    A3 = 0.015 + 0.003*randn();
                    
                case 3 % Channel 3 - High frequency gear vibration
                    % Gear mesh frequencies
                    f1 = 400 + 50*randn();
                    f2 = 1.8*f1 + 30*randn();
                    f3 = 2.2*f1 + 40*randn();
                    
                    % Amplitudes (normal levels)
                    A1 = 0.06 + 0.01*randn();
                    A2 = 0.03 + 0.006*randn();
                    A3 = 0.012 + 0.002*randn();
            end
            
            % Time vector
            t = (0:nSamples-1) / fs;
            
            % Generate signal with multiple components
            signal = A1 * sin(2*pi*f1*t + 2*pi*rand()) + ...
                    A2 * sin(2*pi*f2*t + 2*pi*rand()) + ...
                    A3 * sin(2*pi*f3*t + 2*pi*rand());
            
            % Add white noise
            noiseLevel = 0.01 + 0.005*randn();
            signal = signal + noiseLevel * randn(size(t));
            
            % Add some random modulation (normal wear)
            modFreq = 0.5 + 0.2*randn();
            modDepth = 0.1 + 0.05*randn();
            signal = signal .* (1 + modDepth * sin(2*pi*modFreq*t));
            
            vibrationData(i, ch, :) = signal;
        end
    end
    
    %% Generate Anomalous Data (Pre-maintenance, degraded conditions)
    for i = 1:nAnomaly
        idx = nNormal + i;
        
        for ch = 1:nChannels
            % Anomalous vibration characteristics (degraded conditions)
            switch ch
                case 1 % Channel 1 - Increased unbalance/misalignment
                    % Fundamental frequency (slightly shifted due to wear)
                    f1 = 30 + 8*randn();
                    % More prominent harmonics
                    f2 = 2*f1 + 5*randn();
                    f3 = 3*f1 + 7*randn();
                    
                    % Higher amplitudes (degraded condition)
                    A1 = 0.25 + 0.08*randn();
                    A2 = 0.15 + 0.05*randn();
                    A3 = 0.08 + 0.02*randn();
                    
                case 2 % Channel 2 - Bearing wear/damage
                    % Bearing frequencies with sidebands
                    f1 = 150 + 30*randn();
                    f2 = 2.5*f1 + 20*randn();
                    f3 = 4*f1 + 25*randn();
                    
                    % Much higher amplitudes (bearing damage)
                    A1 = 0.20 + 0.06*randn();
                    A2 = 0.12 + 0.04*randn();
                    A3 = 0.06 + 0.02*randn();
                    
                case 3 % Channel 3 - Gear wear/tooth damage
                    % Gear mesh frequencies with impact peaks
                    f1 = 400 + 80*randn();
                    f2 = 1.8*f1 + 50*randn();
                    f3 = 2.2*f1 + 60*randn();
                    
                    % Higher amplitudes (gear wear)
                    A1 = 0.15 + 0.05*randn();
                    A2 = 0.08 + 0.03*randn();
                    A3 = 0.04 + 0.01*randn();
            end
            
            % Time vector
            t = (0:nSamples-1) / fs;
            
            % Generate signal with multiple components
            signal = A1 * sin(2*pi*f1*t + 2*pi*rand()) + ...
                    A2 * sin(2*pi*f2*t + 2*pi*rand()) + ...
                    A3 * sin(2*pi*f3*t + 2*pi*rand());
            
            % Add impulse/shock components (typical of worn machinery)
            nImpulses = poissrnd(3); % Random number of impulses
            for j = 1:nImpulses
                impulseLoc = randi(nSamples);
                impulseAmp = 0.5 + 0.3*randn();
                if impulseLoc <= nSamples - 50
                    impulse = impulseAmp * exp(-0.1*(0:49)) .* sin(2*pi*200*(0:49)/fs);
                    signal(impulseLoc:impulseLoc+49) = signal(impulseLoc:impulseLoc+49) + impulse;
                end
            end
            
            % Higher noise level (degraded conditions)
            noiseLevel = 0.03 + 0.015*randn();
            signal = signal + noiseLevel * randn(size(t));
            
            % Add stronger modulation (severe wear patterns)
            modFreq = 0.8 + 0.4*randn();
            modDepth = 0.3 + 0.15*randn();
            signal = signal .* (1 + modDepth * sin(2*pi*modFreq*t));
            
            % Add some non-linear distortion (typical of damaged machinery)
            signal = signal + 0.05 * sign(signal) .* signal.^2;
            
            vibrationData(idx, ch, :) = signal;
        end
    end
    
    fprintf('Synthetic vibration data generation completed.\n');
    
    % Shuffle the data
    shuffleIdx = randperm(nNormal + nAnomaly);
    vibrationData = vibrationData(shuffleIdx, :, :);
    labels = labels(shuffleIdx);
    
end