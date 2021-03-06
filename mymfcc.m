function [ MFCCs, FBEs, frames ] = mymfcc( speech, fs )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
    % Define variables
    Tw = 25;                % analysis frame duration (ms)
    Ts = 10;                % analysis frame shift (ms)
    alpha = 0.97;           % preemphasis coefficient
%     M = 20;                 % number of filterbank channels 
    M = 24;                 % number of filterbank channels 
%     C = 14;                 % number of cepstral coefficients
    C = 16;                 % number of cepstral coefficients
    L = 22;                 % cepstral sine lifter parameter
    LF = 300;               % lower frequency limit (Hz)
    HF = 3700;              % upper frequency limit (Hz)
%     wav_file = 'dataset/14307130345/14307130345_start_01.wav';  % input audio filename
%     wav_file = 'sp10.wav';  % input audio filename


    % Read speech samples, sampling rate and precision from file
%     [ speech, fs] = audioread( wav_file );


    % Feature extraction (feature vectors as columns)
    [ MFCCs, FBEs, frames ] = ...
                    mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
%                 加入一阶差分
%         m = MFCCs';
%         dtm=zeros(size(m));
%         for i=3:size(m,1)-2
%           dtm(i,:)=-2*m(i-2,:)-m(i-1,:)+m(i+1,:)+2*m(i+2,:);
%         end
%         dtm=dtm/3;
% 
%         %合并mfcc参数和一阶差分mfcc参数
%         ccc=[m dtm];
%         %去除首尾两帧，因为这两帧的一阶差分参数为0
%         ccc=ccc(3:size(m,1)-2,:);
%         MFCCs = ccc';
end

