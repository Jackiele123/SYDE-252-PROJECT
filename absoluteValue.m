function [absArray] = absoluteValue(inputSoundArray)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
%outputArg1 = abs(inputSoundArray);

    absArray = zeros(rows, cols);

    for i = 1:rows
        for j = 1:cols
            absArray(i, j) = abs(inputSoundArray(i, j));
        end
    end
end