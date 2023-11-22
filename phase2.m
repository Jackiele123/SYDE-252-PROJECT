% global
processed = 'testsounds';
lowPassFilterLength = 100;
bandPassFilterOrder = 100;
Fs = 16000; % Sampling Frequency
Fc = 400; % Low Pass cut-off frequency
N = 10; % Number of Filter Banks
resampled_sounds = dir(fullfile(processed, '*.wav'));

lowFreq = 100; % Lower bound
highFreq = 7999.99; % Nyquist frequency

for i = 1:length(resampled_sounds) %length(resampled_sounds)
    audioFilePath = fullfile(processed, resampled_sounds(i).name);
    % Generate the filter banks% Load the audio file
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
    subplot(2, 1, 1);
    plot(t, lowestFreqOutput);
    title('Lowest Frequency Channel Output');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;

    % Plotting the highest frequency channel output
    subplot(2, 1, 2);
    plot(t, highestFreqOutput);
    title('Highest Frequency Channel Output');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;
 % Task 7/8 -------------------------------------------------------
    % Initialize envelope
    envelopes = cell(1,N);
    % Initialize the fully processed signal
    BPF_Rectifed_LPF_signal = cell(1,N);
    for j = 1:length(filterBanks)
        % % Rectify Signal
        % rectifiedSignal = abs(filterBanks{j});
        % % Lowpass Filter
        % b = fir1(lowPassFilterOrder, Wn, 'low');
        % 
        % filteredSignal = filter(b, 1, rectifiedSignal);
        % BPF_Rectifed_LPF_signal{j} = conv(rectifiedSignal,b,'same');
        % envelope = zeros(size(filteredSignal));
        % % Generate enevelope for each filter
        % for k = 1:length(filteredSignal)
        %     startIdx = max(1, k - floor(envelopeWindow / 2));
        %     endIdx = min(length(filteredSignal), k + floor(envelopeWindow / 2));
        %     envelope(k) = max(rectifiedSignal(startIdx:endIdx));
        % end
        % envelopes{j} = envelope;
        % Design FIR filter coefficients using a window method
        rectifiedSignal = abs(filterBanks{j});
        n = 0:lowPassFilterLength;
        wc = 2 * pi * Fc / Fs;
        idealResponse = wc/pi * sinc(wc/pi * (n - (lowPassFilterLength-1)/2));
    
        % Apply a Hamminh window to the coefficients
        hammingWindow = 0.54 - 0.46 * cos(2 * pi * n / (lowPassFilterLength-1));
        filterCoefficients = idealResponse .* hammingWindow;
    
        % Normalize coefficients so that the sum is 1
        filterCoefficients = filterCoefficients / sum(filterCoefficients);

        envelopes{j} = conv(rectifiedSignal, filterCoefficients, 'same');
    end

    % Envelope of lowest and highest
    envelopelowestFreqOutput = envelopes{1};
    envelopeHighestFreqOutput = envelopes{end};
    
    figure;
    % Plot for the envelope of lowest frequency channel
    subplot(2, 2, 1);
    plot(t, envelopelowestFreqOutput, 'r'); % Plot the envelope in red
    title('Lowest Frequency Channel Envelope Output');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;
    % Plot for zoomed in and overlapping envelope
    subplot(2, 2, 2);
    plot(t(1,10000:15000), lowestFreqOutput(100000:105000,1), 'b')
    hold on;
    plot(t(1,10000:15000), envelopelowestFreqOutput(100000:105000,1), 'r',LineWidth=1); % Plot the envelope in red
    title('Zoomed in Lowest Frequency Channel Output and its Envelope');
    xlabel('Time (s)');
    ylabel('Amplitude');
    legend('Rectified Signal', 'Envelope');
    grid on;
    
    % Plot for the envelope of highest frequency channel
    subplot(2, 2, 3);
    plot(t, envelopeHighestFreqOutput, 'r'); % Plot the envelope in red
    title('Highest Frequency Channel Envelope Output');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;
    % Plot for zoomed in and overlapping envelope
    subplot(2, 2, 4);
    plot(t(1,10000:15000), highestFreqOutput(100000:105000,1), 'b')
    hold on;
    plot(t(1,10000:15000), envelopeHighestFreqOutput(100000:105000,1), 'r',LineWidth=1); % Plot the envelope in red
    title('Zoomed in Highest Frequency Channel Output and its Envelope');
    xlabel('Time (s)');
    ylabel('Amplitude');
    legend('Rectified Signal', 'Envelope');
    grid on;
end