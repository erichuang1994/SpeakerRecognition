function [ res ] = testvoice( filepath )
load GMMs

stuids = dir('./dataset/');
temp = [];
for i=1:size(stuids)
    if length(stuids(i).name)==11
        temp=[temp ;stuids(i)];
    end
end
stuids = temp;
try
    [y,fs] = audioread(filepath);
catch ME
    disp(filepath);
    rethrow(ME);
end
[x1,x2] = vad(y,0);
FrameLen = 240;%指定帧长
FrameInc = 80;
ny = y(FrameLen-FrameInc+x1*FrameInc:FrameLen-FrameInc+x2*FrameInc);
[ MFCC, FBEs, frames ] = mymfcc(ny, fs );
testdatas = MFCC';
votes = zeros(size(stuids));
for j=1:size(testdatas,1)
    counts = zeros(size(stuids));
    for i=1:size(stuids)
%         disp(stuids(i).name);
        counts(i) = pdf(GMMs(stuids(i).name),testdatas(j,:));
    end
    [~,tmpi] = max(counts);
    votes(tmpi) = votes(tmpi) + 1;
end
[~,pdfi] = max(votes);
fprintf('%s predict=%s\n',filepath,stuids(pdfi).name);
res = stuids(pdfi).name;
end

