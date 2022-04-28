function main(varargin)
    clc; clear all; close all
    
    Time=tic;
    rand_flag = 0; % 1 = rand the initial position, 2 = rand statics and image, 3 = rand only image
    debug_mode = 0; % 0 = debug_mode is off, 1 = debug mode is on.
    IsObjVideo = 0; % 0 = single image, 1= full video (more than one frame.
    if ~isdir('results')
        mkdir('results');

    % Mean
    for obj_mean = [[7, 7.7]; [8, 10] ; [10, 12] ; [14, 8]; [5.5, 6.5]; [6.6, 6.5]; [10, 7.5]; [6, 3.5]]'
        obj1_mean = obj_mean(1);
        obj2_mean = obj_mean(2);
        for obj1_sd = [0.1, 0.7, 1.5]
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
%                 end
        end
     end
    end

    % SD
    for obj_sd = [[1.5, 0.1] ; [2, 0.7] ; [0.3, 0.9]; [1.3, 0.3]; [2.5, 1]; [0.1, 1]]'
      obj1_sd = obj_sd(1);
      obj2_sd = obj_sd(2);
      for obj_mean = [5, 10, 15]
                    % in case main was called without arguments      
                    config_file_name = Configuration(rand_flag,IsObjVideo,debug_mode, obj_mean, obj1_sd, obj_mean, obj2_sd);
                    load(config_file_name);

                    if isfile(VideoConfig.NAME)
                        fprintf('file already exists: %s\n', VideoConfig.NAME)
                        continue;
                    else
                        fprintf("file doesn't exists: %s\n", VideoConfig.NAME)
                    end

                    Stimuli_v3(config_file_name);
                    toc(Time);
%                 end
        end
     end
end
