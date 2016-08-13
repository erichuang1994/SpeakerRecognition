function [x1,x2] = vad(x,debug)
%端点检测
y=x;
L2=x(:);
%%对声道进行小波去噪
[thr,sorh,keepapp]=ddencmp('den','wv',L2);
% L3=wdencmp('gbl',L2,'coif5',5,thr,'s',keepapp);
L3=wdencmp('gbl',L2,'coif5',5,thr,'s',keepapp);
x=L3;
%幅度归一化到[-1,1]
x = double(x);
x = x / max(abs(x));
%常数设置
%帧长30ms
%point=samplerate*FrameLen;
%FrameInc=round(point*0.4); %由帧移得比值为0.4
FrameLen= 240; %30ms
FrameInc = 80; %10ms
amp1 = 3;
% amp2 = 0.5;
amp2 = 0.2;
zcr1 = 10;
zcr2 = 0;
% zcr2 = 3;
maxsilence = 20; % 20*10ms = 200ms
minlen = 35; % 30*10ms = 300ms
status = 0;
count = 0;
silence = 0;
%计算过零率
tmp1 = enframe(x(1:end-1), FrameLen, FrameInc);
tmp2 = enframe(x(2:end) , FrameLen, FrameInc);
signs = (tmp1.*tmp2)<0;
diffs = (tmp1 -tmp2)>0.02;
zcr = sum(signs.*diffs, 2);
% disp(zcr);
%计算短时能量
amp = sum(abs(enframe(filter([1 -0.9375], 1, x), FrameLen, FrameInc)), 2);
% disp(amp);
% disp(size(amp));
%调整能量门限
amp1 = min(amp1, max(amp)/4);
amp2 = min(amp2, max(amp)/8);
% if amp2>0.01
%     amp2=0.01;
% end
% plot(amp);
% w = waitforbuttonpress;
% disp(length(zcr));
%开始端点检测
x1 = 0;
% x2 = 0;
% disp(amp);
% fprintf('amp1=%d\n',amp1);
% fprintf('amp2=%d\n',amp2);
for n=1:length(zcr)
    %     goto = 0;
    %     fprintf('n=%d\n',n);
    switch status
        case {0,1} % 0 = 静音, 1 = 可能开始
            if amp(n) > amp1 || zcr(n)>zcr1 % 确信进入语音段
                %                 disp('here');
                x1 = max(n-count-1,1);
                status = 2;
                silence = 0;
                count = count + 1;
            elseif amp(n) > amp2 || ... % 可能处于语音段
                    zcr(n) > zcr2
                status = 1;
                count = count + 1;
            else % 静音状态
                status = 0;
                count = 0;
            end
        case 2, % 2 = 语音段
            if amp(n) > amp2 || ... % 保持在语音段
                    zcr(n) > zcr2
                count = count + 1;
                %                 silence = floor(silence/2); %似乎是改进？
                silence = 0; %似乎是改进？
            else % 语音将结束
                silence = silence+1;
                if silence < maxsilence % 静音还不够长，尚未结束
                    count = count + 1;
                elseif count < minlen % 语音长度太短，认为是噪声
                    status = 0;
                    silence = 0;
                    count = 0;
                else % 语音结束
                    %                     disp('here');
                    status = 3;
                end
            end
        case 3,
            break;
    end
end
% fprintf('count=%d\n',count);
count = count-silence/2;
x2 = x1 + count -1;
% while zcr(x2) == 0
%     x2 = x2 -1;
% end
% while zcr(x1) == 0
%     x1 = x1 + 1;
% end
if debug == 1
%     subplot(211);
%     plot(amp);
%     hold on
%     plot([x1 x1],[-1 1],'b');
%     plot([x2 x2],[-1 1],'b');
%     hold off
%     title('短时能量');
%     %     w = waitforbuttonpress;
%     subplot(212);
%     plot(zcr);
% %     disp(zcr);
%     title('过零率');
%     w = waitforbuttonpress;
    subplot(211);
    plot(y);
    title('原始信号波形');
    subplot(212);
    plot(y);
    hold on;
    plot(FrameLen-FrameInc+[x1 x1]*FrameInc,[-1 1],'b');
    plot(FrameLen-FrameInc+[x2 x2]*FrameInc,[-1 1],'b');
    hold off;
    title('端点检测结果');
    w = waitforbuttonpress;
    close;
end
end
