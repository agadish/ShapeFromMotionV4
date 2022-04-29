% This script takes .mat file of binary video and split it to k files, each
% file for different section of the video. Each "child" video name will be the
% with "parent" video name with suffix of the k'th number.

load('video\Goose\GooseSmall.mat');
X = objVideo;
frames_amount = 800;
j=1;
k=1;
while j<=frames_amount
    clearvars 'objVideo';
% The following for loop is to slow down the video.
%     for i=1:2:100
%         objVideo(:,:,i:i+1)=repmat(X(:,:,j),[1 1 2]);
%         j=j+1;
%     end
    for i=1:100
        objVideo(:,:,i)=X(:,:,j);
        j=j+1;
    end
    name = strcat('video\Goose\GooseSmall',num2str(k),'.mat');
    save(name,'objVideo','-v7.3');
    k=k+1;
end