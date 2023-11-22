% global
processed = 'newsounds';
FS = 16000;
N = 10;
resampled_sounds = dir(fullfile(processed, '*.wav'));
for i = 1:3%length(resampled_sounds)
    filePath = fullfile(processed, resampled_sounds(i).name);
    % Generate the filter banks
    filterBanks = generateFilterBank(filePath, N, 100);
    
    % Extract the lowest and highest frequency channel outputs
    lowestFreqOutput = filterBanks{1};
    highestFreqOutput = filterBanks{end};
    
    % Create time vector for plotting
    [nSamples, ~] = size(lowestFreqOutput);
    t = (0:nSamples-1)/FS;
    
    % Plotting
    figure;
    
    % Envelop Extraction
    envelopelowestFreqOutput = envelopExtraction(5000, lowestFreqOutput);
    envelopeHighestFreqOutput = envelopExtraction(5000, highestFreqOutput);
    
    % Plotting the lowest frequency channel output
    subplot(4, 1, 1);
    plot(t, lowestFreqOutput);
    title('Lowest Frequency Channel Output');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;

    subplot(4, 1, 2);
    plot(t, envelopelowestFreqOutput);
    title('Enveloped Lowest Frequency Channel Output');
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

    subplot(4, 1, 4);
    plot(t, envelopeHighestFreqOutput);
    title('Enveloped Highest Frequency Channel Output');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;


end


