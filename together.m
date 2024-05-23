rootDir = 'C:\Users\13729\Documents\WeChat Files\wxid_a6l9v8idcwc822\FileStorage\File\2023-04\'; % 请将这里的路径修改为您实际存放特征文件的目录

% 加载所有特征
intensity_features = load(fullfile(rootDir, 'intensity_features.mat'));
energy_features = load(fullfile(rootDir, 'energy_features.mat'));
mfcc_features = load(fullfile(rootDir, 'mfcc_features.mat'));
harmonic_ratio_features = load(fullfile(rootDir, 'harmonic_ratio_features.mat'));
transition_ratio_features = load(fullfile(rootDir, 'transition_ratio_features.mat'));
st_am_features = load(fullfile(rootDir, 'st_am_features.mat'));
st_zcr_features = load(fullfile(rootDir, 'st_zcr_features.mat'));

% 合并特征
features = [intensity_features.intensity_features, energy_features.energy_features, ...
            mfcc_features.mfcc_features, harmonic_ratio_features.harmonic_ratio_features, ...
            transition_ratio_features.transition_ratio_features, st_am_features.st_am_features, ...
            st_zcr_features.st_zcr_features];

% 生成标签
labels = repmat([1, 2, 3, 4], 1, 9)'; % 假设1-精神(睡眠充足)，2-一般精神(强制12小时无睡眠)，3-轻度疲劳(强制24小时无睡眠)，4-重度疲劳(强制36小时无睡眠)

% 保存合并后的特征和标签
save(fullfile(rootDir, 'features_and_labels.mat'), 'features', 'labels');
