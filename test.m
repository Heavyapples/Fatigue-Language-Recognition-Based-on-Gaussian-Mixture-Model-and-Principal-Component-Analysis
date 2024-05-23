% 加载特征数据
load('energy_features.mat');
load('intensity_features.mat');
load('mfcc_features.mat');
load('harmonic_ratio_features.mat');
load('transition_ratio_features.mat');
load('st_am_features.mat');
load('st_zcr_features.mat');

% 准备数据和标签
features = [st_am_features, st_zcr_features];
labels = repmat([1, 2, 3, 4], 1, 9)'; % 假设1-精神(睡眠充足)，2-一般精神(强制12小时无睡眠)，3-轻度疲劳(强制24小时无睡眠)，4-重度疲劳(强制36小时无睡眠)

% 加载最佳GMM模型和PCA系数
load('best_gmm_model.mat', 'gmmModels', 'coeff', 'bestReducedDimension');

% 使用PCA降维
features_pca = features * coeff(:, 1:bestReducedDimension);

% 对整个数据集进行预测
labels_pred = zeros(size(labels));

for i = 1:length(labels)
    log_likelihoods = zeros(4, 1);

    for j = 1:4
        log_likelihoods(j) = sum(log(pdf(gmmModels{j}, features_pca(i, :))));
    end

    [~, labels_pred(i)] = max(log_likelihoods);
end

% 计算分类准确率
accuracy = sum(labels_pred == labels) / length(labels);
fprintf('整个数据集的准确率：%.2f%%\n', accuracy * 100);
