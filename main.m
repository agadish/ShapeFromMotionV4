function main(varargin)
    clc; clear all; close all
    
    Time=tic;
    rand_flag = 0; % 1 = rand the initial position, 2 = rand statics and image, 3 = rand only image
    debug_mode = 0; % 0 = debug_mode is off, 1 = debug mode is on.
    IsObjVideo = 0; % 0 = single image, 1= full video (more than one frame.
    if ~isdir('results')
        mkdir('results');
    end
     for obj1_mean = [0.1, 1, 2, 4, 5, 8, 10, 14, 20]
        for obj1_sd = [0.1, 1, 2, 4, 5, 8, 10, 14, 20]
            for obj2_mean = [0.1, 2, 5, 10 20]
                for obj2_sd = [0.1, 2, 5, 10 20]
                    % in case main was called without arguments      
                    config_file_name = Configuration(rand_flag,IsObjVideo,debug_mode, obj1_mean, obj1_sd, obj2_mean, obj2_sd);
                    load(config_file_name);

                    if isfile(VideoConfig.NAME)
                        fprintf('file already exists: %s\n', VideoConfig.NAME)
                        continue;
                    else
                        fprintf("file doesn't exists: %s\n", VideoConfig.NAME)
                    end

                    Stimuli_v3(config_file_name);
                    toc(Time);
                end
            end
        end
     end
end
