function [Grains_Locations, Grains_Types, Grains_Sizes] = CreateLocationTypeSize(config_file_name,debug_mode,Is_obj,grain_mean_size_factor)     
    load(config_file_name);
    Tamplate_size = [FrameConfig.NUMBER_ROWS FrameConfig.NUMBER_COLUMNS FrameConfig.NUMBER_OF_FRAMES];
    num_of_changing_NOF = 0;
    
    if debug_mode 
        if (Is_obj == 1 || Is_obj == 2)
            disp('Working on Object');
        else
            disp('Working on Background');
        end
    end
     % initialize   
    Grains_Locations=zeros(Tamplate_size);
    Grains_Sizes=zeros(Tamplate_size);
    Grains_Types=zeros(Tamplate_size);
    
    NOF = zeros(1, GrainsConfig.NUMBER_OF_GRAINS);
    row_grain = zeros(1, GrainsConfig.NUMBER_OF_GRAINS);
    col_grain = zeros(1, GrainsConfig.NUMBER_OF_GRAINS);
    Grain_Type = zeros(1, GrainsConfig.NUMBER_OF_GRAINS);
    Grain_Gray_Lvl = zeros(1, GrainsConfig.NUMBER_OF_GRAINS);
    Grain_size = zeros(1, GrainsConfig.NUMBER_OF_GRAINS);

    % Create mean objects arrays
    mean_nof_obj1_delta = (StatisticsConfig.FINAL_MEAN_NOF_OBJ - StatisticsConfig.INITIAL_MEAN_NOF_OBJ) / (FrameConfig.NUMBER_OF_FRAMES - 1);
    if (0 == mean_nof_obj1_delta)
        mean_nof_obj1 = StatisticsConfig.FINAL_MEAN_NOF_OBJ * ones(FrameConfig.NUMBER_OF_FRAMES, 1);
    else
        mean_nof_obj1 = [StatisticsConfig.INITIAL_MEAN_NOF_OBJ : mean_nof_obj1_delta : StatisticsConfig.FINAL_MEAN_NOF_OBJ];
    end
    mean_nof_obj2_delta = (StatisticsConfig.FINAL_MEAN_NOF_OBJ2 - StatisticsConfig.INITIAL_MEAN_NOF_OBJ2) / (FrameConfig.NUMBER_OF_FRAMES - 1);
    if (0 == mean_nof_obj2_delta)
        mean_nof_obj2 = StatisticsConfig.FINAL_MEAN_NOF_OBJ2 * ones(FrameConfig.NUMBER_OF_FRAMES, 1);
    else
        mean_nof_obj2 = [StatisticsConfig.INITIAL_MEAN_NOF_OBJ2 : mean_nof_obj2_delta : StatisticsConfig.FINAL_MEAN_NOF_OBJ2];
    end


    % Create sd objects arrays
    sd_nof_obj1_delta = (StatisticsConfig.FINAL_SD_NOF_OBJ - StatisticsConfig.INITIAL_SD_NOF_OBJ) / (FrameConfig.NUMBER_OF_FRAMES - 1);
    if (0 == sd_nof_obj1_delta)
        sd_nof_obj1 = StatisticsConfig.FINAL_SD_NOF_OBJ * ones(FrameConfig.NUMBER_OF_FRAMES, 1);
    else
        sd_nof_obj1 = [StatisticsConfig.INITIAL_SD_NOF_OBJ : sd_nof_obj1_delta : StatisticsConfig.FINAL_SD_NOF_OBJ];
    end
    sd_nof_obj2_delta = (StatisticsConfig.FINAL_SD_NOF_OBJ2 - StatisticsConfig.INITIAL_SD_NOF_OBJ2) / (FrameConfig.NUMBER_OF_FRAMES - 1);
    if (0 == sd_nof_obj2_delta)
        sd_nof_obj2 = StatisticsConfig.FINAL_SD_NOF_OBJ2 * ones(FrameConfig.NUMBER_OF_FRAMES, 1);
    else
        sd_nof_obj2 = [StatisticsConfig.INITIAL_SD_NOF_OBJ2 : sd_nof_obj2_delta : StatisticsConfig.FINAL_SD_NOF_OBJ2];
    end
    
    for Curr_frame = 1: FrameConfig.NUMBER_OF_FRAMES
        if debug_mode
            fprintf('Working on frame num:%d\n', Curr_frame);
        end
        v_NOF = find(NOF==0);
        if (~isempty(v_NOF))

            row_grain(v_NOF) = randi(FrameConfig.NUMBER_ROWS,1,length(v_NOF));
            col_grain(v_NOF) = randi(FrameConfig.NUMBER_COLUMNS,1,length(v_NOF));
            Grain_Type(v_NOF) = randi(7,1,length(v_NOF));
            Grain_Gray_Lvl(v_NOF) = randi(ColorConfig.NUMBER_OF_COLORS,1,length(v_NOF))/ColorConfig.NUMBER_OF_COLORS;

            Grain_size(v_NOF)=abs(normrnd(grain_mean_size_factor(Curr_frame),StatisticsConfig.SD_GRAIN_SIZE,[1 length(v_NOF)]));
            if (find(Grain_size<0.001))
                index = find(Grain_size<0.001);
                Grain_size(index)=0.001;
            end

            if Is_obj == 1
                NOF(v_NOF)=round(normrnd(mean_nof_obj1(Curr_frame), sd_nof_obj1(Curr_frame),[1 length(v_NOF)]));      
            else
                if Is_obj == 2
                    NOF(v_NOF)=round(normrnd(mean_nof_obj2(Curr_frame), sd_nof_obj2(Curr_frame),[1 length(v_NOF)]));      
                else
                    if StatisticsConfig.IS_POISSON==0
                        NOF(v_NOF)=round(normrnd(StatisticsConfig.MEAN_NOF_BACKGROUND,StatisticsConfig.SD_NOF_BACKGROUND,[1 length(v_NOF)]));
                    else
                        NOF(v_NOF)=1+poissrnd(StatisticsConfig.LAMBDA_NOF_BACKGROUND,[1 length(v_NOF)]);
                    end
                end
            end
            %%Checking that NOF isn't less then 1
            if (~isempty(find(NOF<1,1)))
                min_NOF = find(NOF<1);
                NOF(min_NOF)=1;
                num_of_changing_NOF = num_of_changing_NOF + size(min_NOF,2);
            end

        end
        idx = sub2ind(size(Grains_Locations),row_grain,col_grain,Curr_frame*ones(size(row_grain)));             
        Grains_Locations(idx)= Grain_Gray_Lvl;
        Grains_Sizes(idx)= Grain_size;
        Grains_Types(idx)= Grain_Type;
        NOF = NOF-1;

        if debug_mode && (Curr_frame == 1)
            figure
            subplot(311);imshowpair(Grains_Locations(:,:,1),1-Grains_Locations(:,:,1),'montage');
            subplot(312);imshowpair(Grains_Sizes(:,:,1),1-Grains_Sizes(:,:,1),'montage');
            subplot(313);imshowpair(Grains_Types(:,:,1),1-Grains_Types(:,:,1),'montage');
        end     
    end 
    if debug_mode
        fprintf('Number of times that NOF has been changed to minimun number: %d\n',num_of_changing_NOF);
    end
end

