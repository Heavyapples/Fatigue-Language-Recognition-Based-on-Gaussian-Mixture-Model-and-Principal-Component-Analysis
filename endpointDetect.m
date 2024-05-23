function [startPoint, endPoint] = endpointDetect(audioData, fs)
    % 参数设置
    frameSize = 256;
    frameShift = 128;
    energyThreshold = 0.03;
    zeroCrossingRateThreshold = 0.05;

    % 计算帧数
    numFrames = floor((length(audioData) - frameSize) / frameShift) + 1;

    % 初始化
    energy = zeros(1, numFrames);
    zeroCrossingRate = zeros(1, numFrames);

    % 计算能量和过零率
    for i = 1:numFrames
        startIdx = (i - 1) * frameShift + 1;
        endIdx = startIdx + frameSize - 1;
        frameData = audioData(startIdx:endIdx);
        
        energy(i) = sum(frameData.^2);
        zeroCrossingRate(i) = sum(abs(diff(frameData > 0))) / (2 * frameSize);
    end

    % 确定起始点和结束点
    startPoint = find(energy > max(energy) * energyThreshold & zeroCrossingRate > max(zeroCrossingRate) * zeroCrossingRateThreshold, 1, 'first');
    startPoint = max(1, startPoint * frameShift - frameSize);
    endPoint = find(energy > max(energy) * energyThreshold & zeroCrossingRate > max(zeroCrossingRate) * zeroCrossingRateThreshold, 1, 'last');
    endPoint = min(length(audioData), endPoint * frameShift + frameSize);
end
