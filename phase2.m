% global
processed = 'newsounds';
lowPassFilterOrder = 5000;
bandPassFilterOrder = 100;
envelopeWindow = 500; % Window size envelope detection
Fs = 16000; % Samlping Frequency
Fc = 400; % Low Pass cut-off frequency
Wn = Fc/(Fs/2); %Normalizing Fc/Fs then x2 for nyquist frequency
N = 10; % Number of Filter Banks
resampled_sounds = dir(fullfile(processed, '*.wav'));

lowFreq = 100; % Lower bound
highFreq = 7999.99; % Nyquist frequency

for i = 1:3 %length(resampled_sounds)
    audioFilePath = fullfile(processed, resampled_sounds(i).name);
    % Generate the filter banks% Load the audio file
    [audioSignal, Fs] = audioread(audioFilePath);
    
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
% Task 6 --------------------------------------------------------------    
    % Extract the lowest and highest frequency channel outputs
    lowestFreqOutput = filterBanks{1};
    highestFreqOutput = filterBanks{end};
    
    % Create time vector for plotting
    [nSamples, ~] = size(lowestFreqOutput);
    t = (0:nSamples-1)/Fs;
    
    % Plotting
    figure;

    % Plotting the lowest frequency channel output
    subplot(4, 1, 1);
    plot(t, lowestFreqOutput);
    title('Lowest Frequency Channel Output');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;

    % Plotting the highest frequency channel output
    subplot(4, 1, 3);
    plot(t, highestFreqOutput);
    title('Highest Frequency Channel Output');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;
 % Task 7/8 -------------------------------------------------------
    % Initialize envelope
    envelope = zeros(size(filteredSignal));

    for j = 1:N
        % Rectify Signal
        rectifiedSignal = abs(filterBanks{j});
        % Lowpass Filter
        b = fir1(lowPassFilterOrder, Wn, 'low');
    
        filteredSignal = filter(b, 1, rectifiedSignal);
        % Generate enevelope for each filter
        startIdx = max(1, i - floor(envelopeWindow / 2));
        endIdx = min(length(filteredSignal), i + floor(envelopeWindow / 2));
        envelope(i) = mean(rectifiedSignal(startIdx:endIdx));
    end

    % Envelop Extraction
    envelopelowestFreqOutput = envelope(1);
    envelopeHighestFreqOutput = envelope(end);
    
    subplot(4, 1, 2);
    plot(t, envelopelowestFreqOutput);
    title('Enveloped Lowest Frequency Channel Output');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;

    subplot(4, 1, 4);
    plot(t, envelopeHighestFreqOutput);
    title('Enveloped Highest Frequency Channel Output');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;

end