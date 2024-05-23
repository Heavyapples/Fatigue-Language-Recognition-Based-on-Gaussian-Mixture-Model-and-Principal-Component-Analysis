% 获取音频文件列表
rootDir = 'C:\Users\13729\Documents\WeChat Files\wxid_a6l9v8idcwc822\FileStorage\File\2023-04\语音1\语音\converted_wav\';
fileList_wav = dir(fullfile(rootDir, '*.wav'));

% 参数设置
nFFT = 512;
nMFCC = 13; % 提取的MFCC特征数量
nFiles = length(fileList_wav); % 获取音频文件数量

% 存储特征的变量
intensity_features = []; % 存储强度特征
energy_features = []; % 存储能量特征
mfcc_features = []; % 存储MFCC特征
harmonic_ratio_features = []; % 存储谐波比例特征
transition_ratio_features = []; % 存储过渡帧比例特征
st_am_features = []; % 存储短时平均幅度特征
st_zcr_features = []; % 存储短时过零率特征

% 循环处理所有帧数据
for i = 1:nFiles
    % 加载已处理的帧数据
    load(fullfile(rootDir, ['processed_', fileList_wav(i).name(1:end-4), '.mat']));
    
    % 平滑参数
    windowSize = 5;

    % 提取强度特征
    smoothed_intensity = movmean(max(abs(frames), [], 2), windowSize);
    intensity_stats = [mean(smoothed_intensity), std(smoothed_intensity), min(smoothed_intensity), max(smoothed_intensity)];
    intensity_features = [intensity_features; intensity_stats];

    % 提取短时能量特征
    smoothed_energy = movmean(sum(frames.^2, 2), windowSize);
    energy_stats = [mean(smoothed_energy), std(smoothed_energy), min(smoothed_energy), max(smoothed_energy)];
    energy_features = [energy_features; energy_stats];
    
    % 提取短时平均幅度特征
    st_am = movmean(mean(abs(frames), 2), windowSize);
    st_am_stats = [mean(st_am), std(st_am), min(st_am), max(st_am)];
    st_am_features = [st_am_features; st_am_stats];
    
    % 提取短时过零率特征
    zcr = sum(abs(diff(frames > 0, 1, 2)), 2) / (2 * frameSize);
    smoothed_zcr = movmean(zcr, windowSize);........
    zcr_stats = [mean(smoothed_zcr), std(smoothed_zcr), min(smoothed_zcr), max(smoothed_zcr)];
    st_zcr_features = [st_zcr_features; zcr_stats];
    
    % 提取MFCC特征
    mfcc = melcepst(mean(frames, 2), fs, '0dD', nMFCC, floor(3*log(fs)), nFFT);
    mfcc_mean = mean(mfcc, 1);
    mfcc_std = std(mfcc, 1);
    mfcc_min = min(mfcc, [], 1);
    mfcc_max = max(mfcc, [], 1);
    mfcc_stats = [mfcc_mean, mfcc_std, mfcc_min, mfcc_max];
    mfcc_features = [mfcc_features; mfcc_stats];

    % 计算谐波比例和过渡帧比例
    [hr, tr] = harmonic_transition_ratio(frames, fs, nFFT);
    harmonic_ratio_features = [harmonic_ratio_features; hr];
    transition_ratio_features = [transition_ratio_features; tr];
end

% 保存提取到的特征
save(fullfile(rootDir, 'intensity_features.mat'), 'intensity_features');
save(fullfile(rootDir, 'energy_features.mat'), 'energy_features');
save(fullfile(rootDir, 'mfcc_features.mat'), 'mfcc_features');
save(fullfile(rootDir, 'harmonic_ratio_features.mat'), 'harmonic_ratio_features');
save(fullfile(rootDir, 'transition_ratio_features.mat'), 'transition_ratio_features');
save(fullfile(rootDir, 'st_am_features.mat'), 'st_am_features');
save(fullfile(rootDir, 'st_zcr_features.mat'), 'st_zcr_features');
