clc;clear all;
% sound(audioread('dataset/13307130251/13307130251_语音_01.wav'))
GMMs=containers.Map;
stuids = dir('./dataset/');
for i=1:size(stuids)
    disp(stuids(i).name);
   if length(stuids(i).name)==11
%        stuids(i).name = '13307130230';
       disp(['begin train gmmodel for ' stuids(i).name]);
       MFCCs = getMFCCs(stuids(i).name);
       disp('get MFCCs success ');
       disp(size(MFCCs));
       options = statset('MaxIter',500);
       GMMs(stuids(i).name) = fitgmdist(MFCCs',14,'Options',options);
   end
end
save GMMs GMMs
