% 加载特征数据
load('energy_features.mat');
load('intensity_features.mat');
load('mfcc_features.mat');
load('harmonic_ratio_features.mat');
load('transition_ratio_features.mat');
load('st_am_features.mat');
load('st_zcr_features.mat');

% 准备训练数据和标签
features = [st_am_features,st_zcr_features];
labels = repmat([1, 2, 3, 4], 1, 9)'; % 假设1-精神(睡眠充足)，2-一般精神(强制12小时无睡眠)，3-轻度疲劳(强制24小时无睡眠)，4-重度疲劳(强制36小时无睡眠)

% 划分训练集和测试集
cv = cvpartition(labels, 'HoldOut', 0.2);
idxTrain = training(cv);
idxTest = test(cv);

XTrain = features(idxTrain, :);
YTrain = labels(idxTrain);
XTest = features(idxTest, :);
YTest = labels(idxTest);

% 可尝试的高斯分量数量和PCA降维数
numComponentsList = 2:6;
reducedDimensionList = 2:6;

bestAccuracy = 0;
bestNumComponents = 0;
bestReducedDimension = 0;

for numComponents = numComponentsList
    for reducedDimension = reducedDimensionList
        % 使用PCA降维
        coeff = pca(XTrain);
        XTrain_pca = XTrain * coeff(:, 1:reducedDimension);
        XTest_pca = XTest * coeff(:, 1:reducedDimension);

        % 训练高斯混合模型
        gmmModels = cell(4, 1);

        for i = 1:4
            gmmModels{i} = fitgmdist(XTrain_pca(YTrain == i, :), numComponents, 'RegularizationValue', 1e-6, 'Options', statset('MaxIter', 5000));
        end

        % 对测试数据进行预测
        YTest_pred = zeros(size(YTest));

        for i = 1:length(YTest)
            log_likelihoods = zeros(4, 1);

            for j = 1:4
                log_likelihoods(j) = sum(log(pdf(gmmModels{j}, XTest_pca(i, :))));
            end

            [~, YTest_pred(i)] = max(log_likelihoods);
        end

        % 计算分类准确率
        accuracy = sum(YTest_pred == YTest) / length(YTest);
        
        % 更新最佳参数和准确率
        if accuracy > bestAccuracy
            bestAccuracy = accuracy;
            bestNumComponents = numComponents;
            bestReducedDimension = reducedDimension;

            % 保存模型
            if bestAccuracy >= 0.8
                save('best_gmm_model.mat', 'gmmModels', 'coeff', 'bestReducedDimension');
            end
        end
    end
end

fprintf('最佳GMM分类器准确率：%.2f%% (高斯分量数：%d, PCA降维数：%d)\n', bestAccuracy * 100, bestNumComponents, bestReducedDimension);

