function [ ConfigFileName] = Configuration(rand_flag, IsObjVideo, debug_mode)
%% Create structs
VideoFlags = struct('COLOR_STIMULI_FLAG',0, 'GRAY_STIMULI_FLAG',1,'DEBUG_MODE',0,'NUMBER_OF_OBJ',1);
FrameConfig = struct('NUMBER_ROWS',0, 'NUMBER_COLUMNS', 0,'NUMBER_OF_FRAMES',0,'FPS',0);
ColorConfig = struct('NUMBER_OF_COLORS', 0, 'IS_ISOLUMINANT',0 ,'COLOR_OF_BACKGROUND',0, 'BG_COLOR_1', 0, 'BG_COLOR_2', 0, 'BG_COLOR_3', 0, 'BG_COLOR_4', 0, 'BG_COLOR_5', 0, 'BG_COLOR_6', 0, 'OBJ_COLOR',0);
ObjectConfig = struct('NAME','Shapes\RectA.png','INITIAL_ROW_LOCATION', 0, 'INITIAL_COLUMN_LOCATION', 0, 'INITIAL_OBJ_RATIO_SIZE', 0, 'FINAL_OBJ_RATIO_SIZE',0, 'OBJ_OPACITY',0);
Object2Config = struct('NAME','Shapes\RectB.png','TOP_OBJ',2);
GrainsConfig = struct('NUMBER_OF_GRAINS',0, 'GRAIN_OBJ_FACTOR',0,'CHANGE_GRAIN_SIZE',1);
StatisticsConfig = struct('IS_POISSON',0,'MEAN_NOF_BACKGROUND',0,'SD_NOF_BACKGROUND',0,'LAMBDA_NOF_BACKGROUND',0,'MEAN_NOF_OBJ',0,'SD_NOF_OBJ',0,'MEAN_NOF_OBJ2',0,'SD_NOF_OBJ2',0,'MEAN_NOF_OBJ_COLOR',0,'SD_NOF_OBJ_COLOR',0,'MEAN_GRAIN_SIZE',0,'SD_GRAIN_SIZE',0);
MotionConfig = struct ('MOTION_FLAG', 0, 'FRAMES_PER_MOTION', 1, 'RIGHT_STEP', 0, 'DOWN_STEP',0);
RotationConfig = struct ('ROTATION_FLAG', 0, 'NUM_CHANGE_ROTATE_DIRECTION', 0, 'ROTATE_ANGEL_PER_FRAME', 0,'STARTING_ANGEL',0);
VideoConfig = struct('NAME','MyVid.avi');

%% Define flags
VideoFlags.COLOR_STIMULI_FLAG = 0; %indicate if colored stimulate will be created: 1 yes, 0 no
VideoFlags.DEBUG_MODE = debug_mode;
VideoFlags.NUMBER_OF_OBJ = 2;

%% Define the configuration of the frames
% Define the size of each frame
if ~IsObjVideo
    FrameConfig.NUMBER_ROWS = 600;
    FrameConfig.NUMBER_COLUMNS = 800;
else
    load(ObjectConfig.NAME); % load objVideo to workspace
    FrameConfig.NUMBER_ROWS = size(objVideo(:,:,1),1);
    FrameConfig.NUMBER_COLUMNS = size(objVideo(:,:,1),2);
end

% Define the video frames parameters
FrameConfig.NUMBER_OF_FRAMES = 180; % It is recommanded to set below 150.
FrameConfig.FPS = 30; %Frame rate. MATLAB default=30, Nominal=25. 

%% Define the amount of colors of the grains and the background color.
ColorConfig.NUMBER_OF_COLORS = 6;   % 6,3 or 2
ColorConfig.IS_ISOLUMINANT = 0; % 0= regular colors, 1= Isoluminant colors 
ColorConfig.COLOR_OF_BACKGROUND = 7; %Background color 0-black, 7-white, 1 to 6 - grains color
ColorConfig.OBJ_COLOR = 1;
if ColorConfig.IS_ISOLUMINANT==0
    ColorConfig.COLORS= [0 0 255;255 0 0;0 255 0;0 255 255;255 255 0;255 0 255;255 255 255]; %each row is different color
else 
    ColorConfig.COLORS= [120 120 255;0 233 0;255 85 85;0 195 195;154 154 0;255 53 255;255 255 255]; %each row is different color    
end

%% Define grains configuration
GrainsConfig.NUMBER_OF_GRAINS = 8000; %number of grains in each frame
GrainsConfig.GRAIN_OBJ_FACTOR = 60; % the ration between mean size of grain and the object. if 0 the the program uses mean_grain and sd_grain
GrainsConfig.CHANGE_GRAIN_SIZE = 1; % 1-change , 0-Don't change

%% Define the statistics parameters
StatisticsConfig.IS_POISSON = 0; % Background grains distribution , 0-normal , 1-poisson

% Note: in order to maintain normal distribution, and to avoid negative
% numbers, need to select MEAN and SD according to the following table:
% | MEAN |  MAX_SD_ALLOWED |
% |  1   |      0.1        |
% |  2   |      0.3        |
% |  3   |      0.5        |
% |  4   |      0.8        |
% |  5   |      1.1        |
% |  6   |      1.3        |
% |  7   |      1.7        |
% |  8   |      1.9        |
% |  9   |      2.2        |
% |  10  |      2.5        |

% NOF = Number Of Freames
StatisticsConfig.MEAN_NOF_BACKGROUND = 1; %mean no of frame for BG grain for normanl distribution
StatisticsConfig.SD_NOF_BACKGROUND = 0.1; %standart diviation - frame for BG grain for normanl distribution
StatisticsConfig.LAMBDA_NOF_BACKGROUND = 1 ; %Lammda parameter for poisson dist.

StatisticsConfig.MEAN_NOF_OBJ = 3;  %mean for Object
StatisticsConfig.SD_NOF_OBJ = 0.1;  %sd for Object

StatisticsConfig.MEAN_NOF_OBJ2 = 10;  %mean for Object2
StatisticsConfig.SD_NOF_OBJ2 = 0.1;  %sd for Object2

StatisticsConfig.MEAN_GRAIN_SIZE = 0.2; %each grain size is normally dist.
StatisticsConfig.SD_GRAIN_SIZE = 0.1;

if (rand_flag == 1 || rand_flag == 2)
    %StatisticsConfig.IS_POISSON = randi([0,1]);
    StatisticsConfig = RandStatistics( StatisticsConfig );   
end

%% Difine config name
if debug_mode
   ConfigFileName = 'results\stimuli_config.mat';
else
   ConfigFileName = strcat('results\',datestr(now,30),'_stimuli_config.mat'); 
end

%% Define the configuration of the object

% Define the initial position of the imported object
ObjectConfig.INITIAL_ROW_LOCATION = 301; 
ObjectConfig.INITIAL_COLUMN_LOCATION = 401; 
if rand_flag == 1
    ObjectConfig.INITIAL_ROW_LOCATION = randi([100, FrameConfig.NUMBER_ROWS - 100]);
    ObjectConfig.INITIAL_COLUMN_LOCATION = randi ([100, FrameConfig.NUMBER_COLUMNS - 100]);
end
% Define the ratio size of the imported object
ObjectConfig.INITIAL_OBJ_RATIO_SIZE = 1; %the initial size of the object
ObjectConfig.FINAL_OBJ_RATIO_SIZE = 1; %the final size of the object

% Define the transperency of the object
ObjectConfig.OBJ_OPACITY = 0; %define the transperency of the object, 0 full object, 0.1 - 10% tranperency

if (rand_flag == 1 || rand_flag == 2  || rand_flag == 3) 
    ObjectConfig.NAME = RandObjShape();  
end

%% Motion Config
if rand_flag == 1
    MotionConfig.MOTION_FLAG = randi([0,1]);
    MotionConfig.FRAMES_PER_MOTION = randi([1,10]);
    MotionConfig.RIGHT_STEPS = randi([0,20]);
    MotionConfig.DOWN_STEPS = randi([0,20]);
else
    MotionConfig.MOTION_FLAG = 0;
    MotionConfig.FRAMES_PER_MOTION = 1;
    MotionConfig.RIGHT_STEP = 8;
    MotionConfig.DOWN_STEP = 0;
end

% Rotation config
RotationConfig.ROTATION_FLAG = 0;
RotationConfig.NUM_CHANGE_ROTATE_DIRECTION = 0;
RotationConfig.ROTATE_ANGEL_PER_FRAME =1;
RotationConfig.STARTING_ANGEL = 0;

if ~IsObjVideo
    [~,figure_str] = strtok(ObjectConfig.NAME,'\');
else
    figure_str = 'video_pre_made';
end
VideoConfig.NAME=strcat('results\',figure_str,' #grain ',int2str(GrainsConfig.NUMBER_OF_GRAINS),...
        'BG Stat ',int2str(StatisticsConfig.MEAN_NOF_BACKGROUND),...
        ' 0.',int2str(StatisticsConfig.SD_NOF_BACKGROUND*10),...
        'OBJ Stat',int2str(StatisticsConfig.MEAN_NOF_OBJ),...
        ' 0.',int2str(StatisticsConfig.SD_NOF_OBJ*10),...
        ' size factor',int2str(GrainsConfig.GRAIN_OBJ_FACTOR),...
        ' pois',int2str(StatisticsConfig.IS_POISSON),...
        ' lamda',int2str(StatisticsConfig.LAMBDA_NOF_BACKGROUND));

clearvars debug_mode;
save(ConfigFileName,'-v7.3')
end
