% global
source = 'Audio Files';
processed = 'newsounds';
FS = 16000;

% read, resample, and rewrite audio files
original_sounds = dir(fullfile(source, '*.m4a'));
for i = 1:length(original_sounds)
    filePath = fullfile(source, original_sounds(i).name);
    y = process_input(filePath,i,FS);
end

% verified resampling by listening to new files
filename = [processed, '\sample6.wav'];
[x, fs] = audioread(filename);
disp(fs);
sample_num = 1:length(x);
figure(1); % This plot is in the report
plot(sample_num, x)
xlabel('Sample');
ylabel('Amplitude');
title('Sound Waveform');
grid on;

% cos
n = round((2 * fs) / 1000);
t = (0:n) / fs;
signal = cos(2 * pi * 1000 * t);
%sound(signal, fs);
figure(2); % This plot is in the report
plot(t, signal);
xlabel('Time (s)');
ylabel('Amplitude');
title('Signal');
grid on;




