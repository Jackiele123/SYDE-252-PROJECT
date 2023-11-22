function [envelope] = envelopExtraction(filterOrder, inputData)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    %filterOrder = 5000;
    Fc = 400;
    Fs = 16000;

    Wn = Fc/(Fs/2); %Normalizing Fc/Fs then x2 for nyquist frequency

    rectifiedSignal = abs(inputData);

    b = fir1(filterOrder, Wn, 'low', blackman(filterOrder+1));

    filteredSignal = filter(b, 1, rectifiedSignal);

    % Initialize envelope
    envelope = zeros(size(filteredSignal));

    % Apply a simple moving average filter for smoothing
    for i = 1:length(filteredSignal)
        startIdx = max(1, i - floor(windowSize / 2));
        endIdx = min(length(filteredSignal), i + floor(windowSize / 2));
        envelope(i) = mean(rectifiedSignal(startIdx:endIdx));
    end
end