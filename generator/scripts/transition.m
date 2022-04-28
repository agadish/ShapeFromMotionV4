bg = zeros(700,1550,40);
opacity = linspace(0,1,40);

for i=1:40
    a=find(bg(:,:,i)==0);
    temp=randperm(length(a),round(length(a)*opacity(i)));
    ind=a(temp);
    I = bg(:,:,i);
    I(ind)=1;
    bg(:,:,i)=I;
end
transition_bg = zeros(700,1550,3,40);
for i=1:40
    for j=1:3
        transition_bg(:,:,j,i) = bg(:,:,i);
    end
end
clearvars bg
%%
load('results\title\30000 10 4\Frames.mat')
Frames_double = Frames/255;
Frames_double = double(Frames_double);
clearvars Frames
% load('results\title\new2\bin.mat')
obj_bin = zeros(700,1550,3,100);
for i=1:100
    for j=1:3
        obj_bin(:,:,j,i) = OBJ_IMG(:,:,i);
    end
end
clearvars -except transition_bg obj_bin m Frames_double
%%    
output(:,:,:,1:30)=obj_bin(:,:,:,1:30);
output(:,:,:,31:70)= ((1-transition_bg).*obj_bin(:,:,:,31:70))+(transition_bg.*Frames_double(:,:,:,1:40));
output(:,:,:,71:130)=Frames_double(:,:,:,41:100);
output(:,:,:,131:200)=Frames_double(:,:,:,1:70);
CreateVideo('results\fulltitle3.avi',output,200,1);