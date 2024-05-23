% 读取文件列表
rootDir = 'E:\代码接单\疲劳语音识别\语音1\语音\converted_wav\';
fileList_wav = dir(fullfile(rootDir, '*.wav'));
nFiles = length(fileList_wav);

% 预加重参数
preEmphCoeff = 0.97;

% 循环处理所有语音文件
for i = 1:nFiles
    % 读取语音文件
    [audioData, fs] = audioread(fullfile(rootDir, fileList_wav(i).name));

    % 转换为单声道
    if size(audioData, 2) == 2
        audioData = mean(audioData, 2);
    end

    % 备份原始音频数据
    originalAudioData = audioData;

    % 预加重
    audioDataPreEmph = filter([1 -preEmphCoeff], 1, audioData);

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
    %saveas(gcf, fullfile(rootDir, ['comparison_', fileList_wav(i).name(1:end-4), '.png']));

    % 保存处理后的音频数据
    %save(fullfile(rootDir, ['processed_', fileList_wav(i).name(1:end-4), '.mat']), 'audioDataPreEmph');
    %disp(['Type of audioDataPreEmph variable: ', class(audioDataPreEmph)]);
end
