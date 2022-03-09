function [ objVideo ] = convertVideoToObjVideo( inputVidPath )
    inputVid = vision.VideoFileReader(inputVidPath);
    i=1;
    while ~isDone(inputVid)
        currFrame = step(inputVid);
        currFrame = rgb2gray(currFrame);
        currFrame = double(currFrame);
%        currFrameNewSize = currFrame(51:650,201:1000);
%        currFrameNewSize = imresize(currFrameNewSize,0.6);
%        currFrameNewSize(currFrameNewSize>0.5)=1;
%        currFrameNewSize(currFrameNewSize<=0.5)=0;
        objVideo(:,:,i) = currFrame;%NewSize;
        i = i+1;
    end
end

