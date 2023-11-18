function filterBankOutputs = generateFilterBank(audioFilePath, N, filterOrder)
    % Load the audio file
    [audioSignal, fs] = audioread(audioFilePath);

    % Determine the frequency range of the audio signal
    lowFreq = 100; % Lower bound of human hearing
    highFreq = 7999; % Nyquist frequency

    % Calculate the frequency edges for the filter banks
    freqEdges = linspace(lowFreq, highFreq, N+1);

    % Initialize filterBankOutputs
    filterBankOutputs = cell(1, N);

    % Iterate through each band and apply bandpass filter
    for i = 1:N
        % Define the band
        lowCutoff = freqEdges(i);
        highCutoff = freqEdges(i+1);

        % design the filter coefficients using fir1 with a Blackman window
        firCoeffs = fir1(filterOrder, [lowCutoff, highCutoff]/(fs/2), 'bandpass', blackman(filterOrder+1));

        % Filter the signal using the FIR filter
        filteredSignal = filter(firCoeffs, 1, audioSignal);

        % Store the filtered signal
        filterBankOutputs{i} = filteredSignal;
    end
end
