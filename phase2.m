% global
processed = 'newsounds';
FS = 16000;

% read, resample, and rewrite audio files
resampled_sounds = dir(fullfile(processed, '*.wav'));
for i = 1:length(resampled_sounds)
    filePath = fullfile(processed, resampled_sounds(i).name);
    disp(filePath);
    [x, fs] = audioread(filePath);

    y = fft(x);

    n = length(x);  % num samples
    f = (0:n-1)*(fs/n);  % frequency range
    %{
    The lowest frequency possible in this range is 1 cycle/
    %}
    power = abs(y).^2/n;  % power of the DFT

    figure(i);

    subplot(1,2,1);
    plot(f(1:floor(n/2)),power(1:floor(n/2)));
    xlabel('Frequency');
    ylabel('Power');
    title('Power Spectrum');

    subplot(1,2,2);
    plot(1:length(x), x);
    xlabel('Sample')
    ylabel('Amplitude')
    title(filePath);
end




