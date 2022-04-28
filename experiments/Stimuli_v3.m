function [IsError] = Stimuli_v3( config_file_name)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    IsError = 0;
    load(config_file_name);
    clearvars ConfigFileName;
    
    if ~IsObjVideo
        ORIGINAL_OBJ = CreateBinImage(ObjectConfig.NAME, (ObjectConfig.OBJ_OPACITY~=0), ObjectConfig.OBJ_OPACITY, RotationConfig.STARTING_ANGEL);
        [OBJ_IMG,IsError] = ResizeObj(ORIGINAL_OBJ, ObjectConfig, FrameConfig);
        if IsError
            return;
        end
        if RotationConfig.ROTATION_FLAG
            OBJ_IMG = CreateRotation(OBJ_IMG,RotationConfig,FrameConfig);
        end
        if MotionConfig.MOTION_FLAG
            OBJ_IMG = CreateMotion(OBJ_IMG,MotionConfig,FrameConfig);
        end       
    else
        OBJ_IMG = objVideo(:,:,1:FrameConfig.NUMBER_OF_FRAMES);
        clearvars 'objVideo';
    end
    
    BG_IMG = 1-OBJ_IMG;
    
    %Loading 2nd object
    if VideoFlags.NUMBER_OF_OBJ == 2
        OBJ2_IMG = CreateBinImage(Object2Config.NAME, (ObjectConfig.OBJ_OPACITY~=0), ObjectConfig.OBJ_OPACITY, RotationConfig.STARTING_ANGEL);        
        [OBJ2_IMG,IsError]=ResizeObj(OBJ2_IMG, ObjectConfig, FrameConfig);
        if IsError
            return;
        end
        OBJ2_BG = 1 - OBJ2_IMG;
    end
    
    if VideoFlags.DEBUG_MODE
        CreateVideo('results\bin_video.avi',OBJ_IMG,FrameConfig,VideoFlags.COLOR_STIMULI_FLAG);
        imshowpair(OBJ_IMG(:,:,1),BG_IMG(:,:,1),'montage');
    end
    
    % create a vector, each cell define the size of the grain for each frame
    ratio=linspace(ObjectConfig.INITIAL_OBJ_RATIO_SIZE,ObjectConfig.FINAL_OBJ_RATIO_SIZE,FrameConfig.NUMBER_OF_FRAMES);
    Tamplate_size = [FrameConfig.NUMBER_ROWS FrameConfig.NUMBER_COLUMNS];
    if GrainsConfig.GRAIN_OBJ_FACTOR==0
        grain_mean_size_factor=StatisticsConfig.MEAN_GRAIN_SIZE*ones(1,FrameConfig.NUMBER_OF_FRAMES);
    else
        grain_mean_size_factor=min(Tamplate_size)/(GrainsConfig.GRAIN_OBJ_FACTOR*30);
        grain_mean_size_factor=grain_mean_size_factor.*ratio;
    end    

    [Obj_Grains_Locations, Obj_Grains_Types, Obj_Grains_Sizes] = CreateLocationTypeSize(config_file_name,VideoFlags.DEBUG_MODE,1,grain_mean_size_factor);
    if VideoFlags.NUMBER_OF_OBJ == 2
        [Obj2_Grains_Locations, Obj2_Grains_Types, Obj2_Grains_Sizes] = CreateLocationTypeSize(config_file_name,VideoFlags.DEBUG_MODE,2,grain_mean_size_factor);
    end
    [BG_Grains_Locations, BG_Grains_Types, BG_Grains_Sizes] = CreateLocationTypeSize(config_file_name,VideoFlags.DEBUG_MODE,0,grain_mean_size_factor);
    
    Final_Grains_Locations = OBJ_IMG.*Obj_Grains_Locations + BG_IMG.*BG_Grains_Locations;
    Final_Grains_Types= OBJ_IMG.*Obj_Grains_Types + BG_IMG.*BG_Grains_Types;
    Final_Grains_Sizes= OBJ_IMG.*Obj_Grains_Sizes + BG_IMG.*BG_Grains_Sizes;
    
    if VideoFlags.NUMBER_OF_OBJ == 2
        switch (Object2Config.TOP_OBJ)
            case 1
                Final_Grains_Locations = OBJ2_IMG.*Obj2_Grains_Locations + OBJ2_BG.*BG_Grains_Locations;
                Final_Grains_Types= OBJ2_IMG.*Obj2_Grains_Types + OBJ2_BG.*BG_Grains_Types;
                Final_Grains_Sizes= OBJ2_IMG.*Obj2_Grains_Sizes + OBJ2_BG.*BG_Grains_Sizes;
                Final_Grains_Locations = OBJ_IMG.*Obj_Grains_Locations + BG_IMG.*Final_Grains_Locations;
                Final_Grains_Types= OBJ_IMG.*Obj_Grains_Types + BG_IMG.*Final_Grains_Types;
                Final_Grains_Sizes= OBJ_IMG.*Obj_Grains_Sizes + BG_IMG.*Final_Grains_Sizes;
            case 2
                Final_Grains_Locations = Final_Grains_Locations.*OBJ2_BG + OBJ2_IMG.*Obj2_Grains_Locations;
                Final_Grains_Types     = Final_Grains_Types.*OBJ2_BG     + OBJ2_IMG.*Obj2_Grains_Types;
                Final_Grains_Sizes     = Final_Grains_Sizes.*OBJ2_BG     + OBJ2_IMG.*Obj2_Grains_Sizes;
            otherwise
                Disp('Error: please choose TOP OBJ in config');
        end
    end
    
    if VideoFlags.DEBUG_MODE
        CreateVideo('results\STARS.avi',Final_Grains_Locations,FrameConfig,VideoFlags.COLOR_STIMULI_FLAG);
        return;
    end
    
    [Frames,IsError] = PasteGrainsByType(config_file_name, VideoFlags.DEBUG_MODE, Final_Grains_Locations,...
                               Final_Grains_Types,Final_Grains_Sizes);
    if IsError
        return;
    end                       
    CreateVideo(VideoConfig.NAME,Frames,FrameConfig,VideoFlags.COLOR_STIMULI_FLAG);
    
    clearvars -except Frames Final_Grains_Locations OBJ_IMG
    save('results\Frames.mat')
                           
end

