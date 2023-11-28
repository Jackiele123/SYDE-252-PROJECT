% global
processed = 'testsounds';
filtered = 'filteredsounds';
lowPassFilterOrder = 5000;
bandPassFilterOrder = 5000;
Fs = 16000; % Sampling Frequency
Fc = 400; % Low Pass cut-off frequency
N = 10; % Number of Filter Banks
resampled_sounds = dir(fullfile(processed, '*.wav'));

lowFreq = 100; % Lower bound
highFreq = 7999.99; % Nyquist frequency

for i = 1:length(resampled_sounds) %length (resampled_sounds)
    audioFilePath = fullfile(processed, resampled_sounds(i).name);
    % Generate the filter banks, Load the audio file
    [audioSignal, Fs] = audioread(audioFilePath);
    audioSignal = audioSignal(1:end,1);
% Task 4 ------------------------------------------------    
    % Calculate the frequency edges for the filter banks
    freqEdges = linspace(lowFreq, highFreq, N+1);

    % Initialize filterBankOutputs
    filterBanks = cell(1, N);
    
    % Iterate through each band and apply bandpass filter
    for j = 1:N
        % Define the band
        lowCutoff = freqEdges(j);
        highCutoff = freqEdges(j+1);
% Task 5 -----------------------------------------------------------
        % design the filter coefficients using fir1 with a Blackman window
        firCoeffs = fir1(bandPassFilterOrder, [lowCutoff, highCutoff]/(Fs/2), 'bandpass', blackman(bandPassFilterOrder+1));

        % Filter the signal using the FIR filter
        filteredSignal = filter(firCoeffs, 1, audioSignal);

        % Store the filtered signal
        filterBanks{j} = filteredSignal;
    end
 % Task 7/8 -------------------------------------------------------
    % Initialize envelope
    envelopes = cell(1,N);
    for j = 1:length(filterBanks)

        % Task 7  Recitify Signal by taking absolute value
        rectifiedSignal = abs(filterBanks{j});
        n = 0:lowPassFilterOrder;
        wc = 2 * pi * Fc / Fs; % Normalized cut-off frequency
        % FIR Low-pass filter design using sinc(x) = sin(pi*x)/(pi*x(
        idealResponse = wc/pi * sinc(wc/pi * (n - (lowPassFilterOrder-1)/2));
    
        % Apply a Hamming window to the coefficients
        hammingWindow = 0.54 - 0.46 * cos(2 * pi * n / (lowPassFilterOrder-1));
        filterCoefficients = idealResponse .* hammingWindow;
    
        % Normalize coefficients so that the sum is 1
        filterCoefficients = filterCoefficients / sum(filterCoefficients); 
        
        % Apply LPF to recitified signal
        envelopes{j} = conv(rectifiedSignal, filterCoefficients, 'same');
    end

% ----------------------------PHASE 3-------------------------------------
    % Task 10/11: Generate Cosine Signals and Amplitude Modulate
    modulatedSignals = cell(1, N);
    for j = 1:N
        % Central frequency for the current band
        centralFreq = (freqEdges(j) + freqEdges(j+1)) / 2;
        % Create time vector
        [nSamples, ~] = size(envelopes{j});
        t = (0:nSamples-1)'/Fs;
        % Generate cosine signal
        cosineSignal = cos(2 * pi * centralFreq * t);

        % Amplitude Modulation
        modulatedSignals{j} = cosineSignal .* abs(envelopes{j});
    end
    
    % Task 12: Summation and Normalization
    combinedSignal = sum(cat(2, modulatedSignals{:}), 2);
    normalizedSignal = combinedSignal / max(abs(combinedSignal));
    
    % Step 13: Play and Save the Output Sound
    % sound(normalizedSignal, Fs);
    outputFilePath = [filtered,'\filtered_',num2str(N),'_',resampled_sounds(i).name];
    audiowrite(outputFilePath, normalizedSignal, Fs);
end

