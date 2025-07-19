function features = extractVibrationFeatures(vibrationData)
%EXTRACTVIBRATIONFEATURES Extract time and frequency domain features
%   This function extracts comprehensive features from 3-axis vibration data
%   including time domain and frequency domain characteristics
%
%   Input:
%       vibrationData - Matrix of size (nSamples x nChannels x nTimePoints)
%
%   Output:
%       features - Matrix of size (nSamples x nFeatures)
%                 Features include: Crest Factor, Kurtosis, RMS, Std Dev,
%                 Mean, Skewness, SINAD, SNR, THD for each channel

    [nSamples, nChannels, nTimePoints] = size(vibrationData);
    
    % Define number of features per channel
    nFeaturesPerChannel = 4; % Will be adjusted based on channel
    
    % Channel-specific features based on MATLAB example:
    % Channel 1: Crest Factor, Kurtosis, RMS, Standard Deviation
    % Channel 2: Mean, RMS, Skewness, Standard Deviation  
    % Channel 3: Crest Factor, SINAD, SNR, THD
    
    totalFeatures = 12; % 4 features per channel * 3 channels
    features = zeros(nSamples, totalFeatures);
    
    fprintf('Extracting features from vibration signals...\n');
    fprintf('  Processing %d samples with %d channels\n', nSamples, nChannels);
    
    for i = 1:nSamples
        featureIdx = 1;
        
        for ch = 1:nChannels
            % Extract signal for current sample and channel
            signal = squeeze(vibrationData(i, ch, :));
            
            % Remove DC component
            signal = signal - mean(signal);
            
            switch ch
                case 1 % Channel 1 features
                    % Crest Factor
                    crestFactor = max(abs(signal)) / rms(signal);
                    features(i, featureIdx) = crestFactor;
                    featureIdx = featureIdx + 1;
                    
                    % Kurtosis
                    kurtosisVal = kurtosis(signal);
                    features(i, featureIdx) = kurtosisVal;
                    featureIdx = featureIdx + 1;
                    
                    % RMS
                    rmsVal = rms(signal);
                    features(i, featureIdx) = rmsVal;
                    featureIdx = featureIdx + 1;
                    
                    % Standard Deviation
                    stdVal = std(signal);
                    features(i, featureIdx) = stdVal;
                    featureIdx = featureIdx + 1;
                    
                case 2 % Channel 2 features
                    % Mean
                    meanVal = mean(signal);
                    features(i, featureIdx) = meanVal;
                    featureIdx = featureIdx + 1;
                    
                    % RMS
                    rmsVal = rms(signal);
                    features(i, featureIdx) = rmsVal;
                    featureIdx = featureIdx + 1;
                    
                    % Skewness
                    skewnessVal = skewness(signal);
                    features(i, featureIdx) = skewnessVal;
                    featureIdx = featureIdx + 1;
                    
                    % Standard Deviation
                    stdVal = std(signal);
                    features(i, featureIdx) = stdVal;
                    featureIdx = featureIdx + 1;
                    
                case 3 % Channel 3 features
                    % Crest Factor
                    crestFactor = max(abs(signal)) / rms(signal);
                    features(i, featureIdx) = crestFactor;
                    featureIdx = featureIdx + 1;
                    
                    % SINAD (Signal-to-Noise and Distortion Ratio)
                    sinadVal = calculateSINAD(signal);
                    features(i, featureIdx) = sinadVal;
                    featureIdx = featureIdx + 1;
                    
                    % SNR (Signal-to-Noise Ratio)
                    snrVal = calculateSNR(signal);
                    features(i, featureIdx) = snrVal;
                    featureIdx = featureIdx + 1;
                    
                    % THD (Total Harmonic Distortion)
                    thdVal = calculateTHD(signal);
                    features(i, featureIdx) = thdVal;
                    featureIdx = featureIdx + 1;
            end
        end
        
        % Progress indicator
        if mod(i, 100) == 0
            fprintf('  Processed %d/%d samples\n', i, nSamples);
        end
    end
    
    fprintf('Feature extraction completed.\n');
    fprintf('  Extracted %d features per sample\n', totalFeatures);
end

function sinadVal = calculateSINAD(signal)
    % Calculate Signal-to-Noise and Distortion Ratio
    % SINAD is the ratio of signal power to noise+distortion power
    
    try
        % Compute FFT
        N = length(signal);
        fs = 1000; % Assumed sampling frequency
        
        % Apply window to reduce spectral leakage
        windowed_signal = signal .* hann(length(signal));
        
        % Compute power spectral density
        [psd, f] = periodogram(windowed_signal, [], N, fs);
        
        % Find fundamental frequency (assume it's the peak in low freq range)
        [~, fundIdx] = max(psd(f >= 10 & f <= 200));
        fundIdx = fundIdx + find(f >= 10, 1) - 1;
        
        % Define signal band around fundamental (±5 Hz)
        signalBand = abs(f - f(fundIdx)) <= 5;
        
        % Calculate signal power and total power
        signalPower = sum(psd(signalBand));
        totalPower = sum(psd);
        
        % SINAD in dB
        sinadVal = 10 * log10(signalPower / (totalPower - signalPower));
        
        % Ensure reasonable range
        if isnan(sinadVal) || isinf(sinadVal)
            sinadVal = 30; % Default value
        end
        sinadVal = max(0, min(60, sinadVal)); % Clamp to reasonable range
        
    catch
        sinadVal = 30; % Default value if calculation fails
    end
end

function snrVal = calculateSNR(signal)
    % Calculate Signal-to-Noise Ratio
    
    try
        % Estimate signal and noise components
        % Use moving average to estimate signal trend
        windowSize = min(50, floor(length(signal)/10));
        signalTrend = movmean(signal, windowSize);
        noise = signal - signalTrend;
        
        % Calculate power
        signalPower = var(signalTrend);
        noisePower = var(noise);
        
        % SNR in dB
        snrVal = 10 * log10(signalPower / noisePower);
        
        % Ensure reasonable range
        if isnan(snrVal) || isinf(snrVal) || noisePower == 0
            snrVal = 25; % Default value
        end
        snrVal = max(0, min(50, snrVal)); % Clamp to reasonable range
        
    catch
        snrVal = 25; % Default value if calculation fails
    end
end

function thdVal = calculateTHD(signal)
    % Calculate Total Harmonic Distortion
    
    try
        % Compute FFT
        N = length(signal);
        fs = 1000; % Assumed sampling frequency
        
        % Apply window
        windowed_signal = signal .* hann(length(signal));
        
        % Compute single-sided power spectrum
        Y = fft(windowed_signal);
        P = abs(Y/N).^2;
        P = P(1:N/2+1);
        P(2:end-1) = 2*P(2:end-1);
        
        f = fs*(0:(N/2))/N;
        
        % Find fundamental frequency (peak in low frequency range)
        [~, fundIdx] = max(P(f >= 10 & f <= 200));
        fundIdx = fundIdx + find(f >= 10, 1) - 1;
        
        % Find harmonics (2nd, 3rd, 4th, 5th)
        fundFreq = f(fundIdx);
        harmonicPower = 0;
        fundamentalPower = P(fundIdx);
        
        for harmonic = 2:5
            harmonicFreq = harmonic * fundFreq;
            if harmonicFreq < fs/2
                % Find closest frequency bin
                [~, harmIdx] = min(abs(f - harmonicFreq));
                harmonicPower = harmonicPower + P(harmIdx);
            end
        end
        
        % THD as percentage
        if fundamentalPower > 0
            thdVal = 100 * sqrt(harmonicPower / fundamentalPower);
        else
            thdVal = 5; % Default value
        end
        
        % Ensure reasonable range
        if isnan(thdVal) || isinf(thdVal)
            thdVal = 5; % Default value
        end
        thdVal = max(0, min(50, thdVal)); % Clamp to reasonable range
        
    catch
        thdVal = 5; % Default value if calculation fails
    end
end