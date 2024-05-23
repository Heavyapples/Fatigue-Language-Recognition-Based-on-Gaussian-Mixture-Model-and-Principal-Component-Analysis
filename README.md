# 基于高斯混合模型（GMM）和主成分分析（PCA）的疲劳语音识别

## 系统要求
建议使用 MATLAB 2021b 或以上版本。

## 数据集格式
如需更换数据，数据集格式请保持和【语音数据.zip】一致的格式。

调整 `trans_to_wav.m`、`data.m`、`get_feature.m` 文件中第二行的 `rootDir` 参数为数据集主文件夹的路径。

## 项目运行流程
1. 运行 `trans_to_wav.m`：转化语音文件格式
2. 运行 `data.m`：预处理数据
3. 运行 `get_feature.m`：提取特征
4. 运行 `train.m`：训练模型

其余代码文件为辅助函数或脚本，无需打开或修改。

## 可视化界面
项目包含两个可视化界面文件 `gui.mlapp`、`show.mlapp`，其中集成了训练以及检测推理功能，方便用户使用。

## 使用说明
1. 下载并解压项目文件。
2. 打开 MATLAB，并将当前文件夹设置为项目根目录。
3. 按照上述运行流程执行对应的 MATLAB 文件。
4. 运行 `gui.mlapp`、`show.mlapp` 以使用可视化界面进行训练和检测推理。

## 联系我们
如果您在使用过程中有任何问题，请通过以下方式联系我：
- 邮箱：w1372988970@gmail.com
