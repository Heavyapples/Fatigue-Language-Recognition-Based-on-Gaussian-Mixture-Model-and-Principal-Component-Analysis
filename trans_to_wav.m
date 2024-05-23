% 读取文件列表
rootDir = 'C:\\Users\\13729\\Documents\\WeChat Files\\wxid_a6l9v8idcwc822\\FileStorage\\File\\2023-04\\语音1\\语音\\';
fileList_m4a = dir(fullfile(rootDir, '*.m4a'));
fileList_aac = dir(fullfile(rootDir, '*.aac'));
fileList_mp3 = dir(fullfile(rootDir, '*.mp3'));
fileList = [fileList_m4a; fileList_aac; fileList_mp3];
nFiles = length(fileList);

% 转换文件格式
for i = 1:nFiles
    % 读取语音文件
    [audioData, fs] = audioread(fullfile(rootDir, fileList(i).name));
    
    % 转换为 WAV 格式
    outputFileName = fullfile(rootDir, 'converted_wav', [fileList(i).name(1:end-4), '.wav']);
    audiowrite(outputFileName, audioData, fs);
end
