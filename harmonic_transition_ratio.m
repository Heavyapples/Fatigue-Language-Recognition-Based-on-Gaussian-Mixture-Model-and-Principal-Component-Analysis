function [hr, tr] = harmonic_transition_ratio(frames, fs, nFFT)
    % 计算每帧的谐波比例和过渡帧比例
    numFrames = size(frames, 1);
    hr_array = zeros(numFrames, 1);
    tr_array = zeros(numFrames, 1);
    
    for i = 1:numFrames
        frameData = frames(i, :);
        frame_fft = fft(frameData, nFFT);
        
        % 计算谐波比例
        hr_array(i) = harmonic_ratio(frame_fft, fs);
        
        % 计算过渡帧比例
        if i > 1
            tr_array(i) = transition_ratio(frame_fft, previous_frame_fft);
        end
        
        previous_frame_fft = frame_fft;
    end
    
    % 计算谐波比例和过渡帧比例的均值
    hr = mean(hr_array);
    tr = mean(tr_array(2:end));
end

function hr = harmonic_ratio(frame_fft, fs)
    % 计算谐波比例
    half_nfft = length(frame_fft) / 2;
    spectrum = abs(frame_fft(1:half_nfft));
    max_freq = fs / 2;
    freqs = linspace(0, max_freq, half_nfft);
    
    % 计算谐波能量
    harmonic_energy = sum(spectrum(1:2:end).^2);
    
    % 计算总能量
    total_energy = sum(spectrum.^2);
    
    % 计算谐波比例
    hr = harmonic_energy / total_energy;
end

function tr = transition_ratio(current_frame_fft, previous_frame_fft)
    % 计算过渡帧比例
    half_nfft = length(current_frame_fft) / 2;
    current_spectrum = abs(current_frame_fft(1:half_nfft));
    previous_spectrum = abs(previous_frame_fft(1:half_nfft));
    
    % 计算频谱差的平方和
    diff_square_sum = sum((current_spectrum - previous_spectrum).^2);
    
    % 计算频谱的平方和
    current_square_sum = sum(current_spectrum.^2);
    previous_square_sum = sum(previous_spectrum.^2);
    
    % 计算过渡帧比例
    tr = diff_square_sum / (current_square_sum + previous_square_sum);
end
