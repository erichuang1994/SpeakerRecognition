% sound(audioread('dataset/13307130251/13307130251_语音_01.wav'))
files = dir('./dataset/14307130345/');
for i=1:size(files)
%     [y,fs] = audioread('dataset/13307130251_Stop_03.wav')
    if length(files(i).name)>11
        disp(files(i).name);
        [y,fs] = audioread(strcat('dataset/14307130345/',files(i).name));
        [x1,x2] = vad(y,1);
        fprintf('x1=%d x2=%d\n',x1,x2);
        plot(y);
        hold on;
        FrameLen = 240;%指定帧长
        FrameInc = 80;
        plot(FrameLen-FrameInc+[x1 x1]*FrameInc,[-1 1],'b');
        plot(FrameLen-FrameInc+[x2 x2]*FrameInc,[-1 1],'b');
        sound(y(x1*FrameInc+FrameLen-FrameInc:x2*FrameInc+FrameLen-FrameInc));
        % plot([x1(1) x1(1)]*FrameInc,[-1 1],'b')
        % plot([x1(2) x1(2)]*FrameInc,[-1 1],'b')
        % plot([x2(1) x2(1)]*FrameInc,[-1 1],'r')
        % plot([x2(2) x2(2)]*FrameInc,[-1 1],'r')
        hold off;
        w = waitforbuttonpress;
        
    end 
end 
% testbyword('13307130248','start')