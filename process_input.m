function y = process_input(filepath, i, target_fs)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [x, fs] = audioread(filepath);
    if size(x, 2) == 2 % if stereo
        x = sum(x, 2); % add channels --> mono
    end
    %sound(x, fs);
    y = resample(x, target_fs, fs); % resample
    filename = ['newsounds\sample', num2str(i), '.wav'];
    audiowrite(filename,y,target_fs); % rewrite
end

