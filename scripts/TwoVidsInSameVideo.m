load('results\Statistics\Small\diff\Frames.mat')
diff_mean = Frames(1:242,1:234,:);
clearvars Final_Grains_Locations Frames
load('results\Statistics\Small\same\Frames.mat')
same_mean = Frames(1:242,1:234,:);
clearvars Final_Grains_Locations Frames
TwoVids = ones(242,478,100);

TwoVids(:,1:234,:) = diff_mean(:,:,1:100);
% TwoVids(1:580,1:630,101:150) = repmat(diff_mean(:,:,100),[1 1 50]);
% TwoVids(1:580,1:630,151:200) = diff_mean(:,:,101:150);

TwoVids(:,245:478,:) = same_mean(:,:,1:100);
% TwoVids(1:580,641:1260,101:150) = repmat(same_mean(:,:,100),[1 1 50]);
% TwoVids(1:580,641:1260,151:200) = same_mean(:,:,101:150);

CreateVideo('results\StatisticsSmall.avi',TwoVids,75,0);