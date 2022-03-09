function main(varargin)
    clc; clear all; close all
    
    Time=tic;
    rand_flag = 0; % 1 = rand the initial position, 2 = rand statics and image, 3 = rand only image
    debug_mode = 0; % 0 = debug_mode is off, 1 = debug mode is on.
    IsObjVideo = 0; % 0 = single image, 1= full video (more than one frame.
    if ~isdir('results')
        mkdir('results');
    end
    switch nargin
        case 0  
            % in case main was called without arguments
            config_file_name = Configuration(rand_flag,IsObjVideo,debug_mode); 
        case 1
            % in case main was called with confif file name
            config_file_name = varargin{1};
    end
    load(config_file_name);
    Stimuli_v3(config_file_name);
    toc(Time);
end
