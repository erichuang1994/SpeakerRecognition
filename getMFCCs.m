function [ MFCCs ] = getMFCCs( stuid )
%UNTITLED6 此处显示有关此函数的摘要
% 获取一个student 的MFCCs 序列,第20个不参与训练作为测试集
% 上面的方法估计过拟合了
% 改成训练全部除了语音和start这两个词 语音和start作为测试集不训练
files = dir(strcat('./dataset/',stuid,'/'));
MFCCs = [];
for i=1:size(files)
%     [y,fs] = audioread('dataset/14307130345/14307130345_语音_01.wav')
%     if length(files(i).name)>11 && ~strcmp(files(i).name(length(files(i).name)-5:length(files(i).name)-4),'20')
%     if length(files(i).name)>11
    if length(files(i).name)>11 && ~strcmp(files(i).name(length(files(i).name)-8:length(files(i).name)-7),'语音') &&...
            ~strcmp(files(i).name(length(files(i).name)-11:length(files(i).name)-7),'start')&&...
            ~strcmp(files(i).name(length(files(i).name)-11:length(files(i).name)-7),'Start')
        disp(files(i).name);
        [y,fs] = audioread(strcat('dataset/',stuid,'/',files(i).name));
        [x1,x2] = vad(y,0);
%         plot(y);
%         hold on;
        FrameLen = 240;%指定帧长
        FrameInc = 80;
%         plot([x1 x1]*FrameInc+FrameLen-FrameInc,[-1 1],'b');
%         plot([x2 x2]*FrameInc+FrameLen-FrameInc,[-1 1],'b');
        ny = y(FrameLen-FrameInc+x1*FrameInc:FrameLen-FrameInc+x2*FrameInc);
%         sound(ny);
%         if(isempty(ny))
%             continue
%         end
        [ MFCC, FBEs, frames ] = mymfcc(ny, fs );
%         %差分参数
%         m = MFCC';
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
%         [ MFCC ] = newmfcc(ny, fs );
        MFCCs= [MFCCs MFCC];
%         MFCCs= [MFCCs ccc'];
   
%         disp('---------------------MFCC---------------');
%         size(MFCC)
        % plot([x1(1) x1(1)]*FrameInc,[-1 1],'b')
        % plot([x1(2) x1(2)]*FrameInc,[-1 1],'b')
        % plot([x2(1) x2(1)]*FrameInc,[-1 1],'r')
        % plot([x2(2) x2(2)]*FrameInc,[-1 1],'r')
%         hold off;
%         w = waitforbuttonpress;
    end 
end 
end

