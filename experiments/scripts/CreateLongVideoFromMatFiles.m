% This script takes collection of .mat files of the frames (with the grains) 
% and create one long Frame matrix. An AVI movie will be produced from these
% frames.
clearvars

IsColor = 1;
amount_frames_for_each_file = 100;
amount_of_files = 2;

for k=1:amount_of_files
    name = strcat('results\colorDance2\dancing_woman',num2str(k+2),'\Frames.mat');
    load(name);
    if ~IsColor
        fullVid(:,:,(((k-1)*amount_frames_for_each_file)+1):(k*amount_frames_for_each_file)) = Frames;
    else
        fullVid(:,:,:,(((k-1)*amount_frames_for_each_file)+1):(k*amount_frames_for_each_file)) = Frames;
    end
    clearvars Frames Final_Grains_Locations;
end
frames_amount = amount_of_files*amount_frames_for_each_file;
CreateVideo('results\FullDanceColorShort.avi',fullVid,150,IsColor);