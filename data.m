% 读取文件列表
rootDir = 'E:\代码接单\疲劳语音识别\语音1\语音\converted_wav\';
fileList_wav = dir(fullfile(rootDir, '*.wav'));
nFiles = length(fileList_wav);

% 预加重参数
preEmphCoeff = 0.97;

% 分帧加窗参数
frameSize = 512; % 帧大小，根据实际需求调整
frameShift = 256; % 帧移，根据实际需求调整
windowType = 'hann';

% 数据增强参数
volumeRange = [0.5, 2]; % 音量调整范围
noiseLevel = 0.05; % 噪声水平

% 循环处理所有语音文件
for i = 1:nFiles
    % 读取语音文件
    [audioData, fs] = audioread(fullfile(rootDir, fileList_wav(i).name));

    % 备份原始音频数据
    originalAudioData = audioData;

    % 数据增强 - 随机调整音量
    scaleFactor = volumeRange(1) + (volumeRange(2) - volumeRange(1)) * rand();
    audioData = audioData * scaleFactor;

    % 数据增强 - 随机添加噪声
    noise = noiseLevel * randn(size(audioData));
    audioData = audioData + noise;

    % 预加重
    audioDataPreEmph = filter([1 -preEmphCoeff], 1, audioData);

    % 端点检测
    [startPoint, endPoint] = endpointDetect(audioDataPreEmph, fs);
    audioDataPreEmph = audioDataPreEmph(startPoint:endPoint);

    % 分帧加窗
    numFrames = floor((length(audioDataPreEmph) - frameSize) / frameShift) + 1;
    frames = zeros(numFrames, frameSize);

    for j = 1:numFrames
        startIdx = (j - 1) * frameShift + 1;
        endIdx = startIdx + frameSize - 1;
        frameData = audioDataPreEmph(startIdx:endIdx);

        % 加窗
        if strcmp(windowType, 'rectangular')
            window = rectwin(frameSize);
        elseif strcmp(windowType, 'hamming')
            window = hamming(frameSize);
        elseif strcmp(windowType, 'hann')
            window = hann(frameSize);
        elseif strcmp(windowType, 'blackman')
            window = blackman(frameSize);
        else
            error('未知的窗类型');
        end

        frameData = frameData(:) .* window(:);
        frames(j, :) = frameData';
    end

    % 显示原始波形和预处理后的波形对比
    figure;
    subplot(2, 1, 1);
    plot((1:length(originalAudioData)) / fs, originalAudioData);
    title('原始波形');
    xlabel('时间 (s)');
    ylabel('幅度');
    xlim([0, length(originalAudioData) / fs]);

    subplot(2, 1, 2);
    plot((1:length(audioDataPreEmph)) / fs, audioDataPreEmph);
    title('预处理后的波形');
    xlabel('时间 (s)');
    ylabel('幅度');
    xlim([0, length(audioDataPreEmph) / fs]);

    % 保存对比图像
    saveas(gcf, fullfile(rootDir, ['comparison_', fileList_wav(i).name(1:end-4), '.png']));

    % 保存处理后的帧数据
    save(fullfile(rootDir, ['processed_', fileList_wav(i).name(1:end-4), '.mat']), 'frames');
    disp(['Type of frames variable: ', class(frames)]);
end
