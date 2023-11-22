function [filteredData] = envelopExtraction(filterOrder, inputData)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    %filterOrder = 5000;
    Fc = 400;
    Fs = 16000;

    Wn = Fc/(Fs/2); %Normalizing Fc/Fs then x2 for nyquist frequency

    rectifiedSignal = abs(inputData);

    b = fir1(filterOrder, Wn, 'low', blackman(filterOrder+1));

    filteredData = filter(b, 1, rectifiedSignal);
end