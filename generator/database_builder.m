function []=database_builder(start_size,end_size,frames)
ratio=linspace(start_size,end_size,frames);
load('grains_type_1.mat');
STR = 'grains\grain_type_';
A=cell(frames,1);
for i=1:size(ratio,2)
    fprintf('Creating new data base item for ratio %f\n',ratio(i));
    result = zeros(ceil(size(grain,1)*ratio(i)),ceil(size(grain,2)*ratio(i)),size(grain,3));
    for j = 1:size(grain,3)
        result(:,:,j)=resize_grain(grain(:,:,j),ratio(i));
    end
    
    result_str= sprintf('%s%f.mat',STR,ratio(i));
    A{i,1}=result;
    save(result_str,'result');

end

save('GrainDataBase.mat','A');
end

%%
% load('grains\grain_type_0.010000.mat');
% load('grains\grain_type_0.020000.mat');
% load('grains\grain_type_0.030000.mat');
% load('grains\grain_type_0.040000.mat');
% load('grains\grain_type_0.050000.mat');
% load('grains\grain_type_0.060000.mat');
% load('grains\grain_type_0.070000.mat');
% load('grains\grain_type_0.080000.mat');
% load('grains\grain_type_0.090000.mat');
% load('grains\grain_type_0.100000.mat');
% load('grains\grain_type_0.110000.mat');
% load('grains\grain_type_0.120000.mat');
% load('grains\grain_type_0.130000.mat');
% load('grains\grain_type_0.140000.mat');
% load('grains\grain_type_0.150000.mat');
%%