function [Frames, IsError] = PasteGrainsByType(config_file_name, debug_mode, Final_Grains_Locations,...
                                    Final_Grains_Types,Final_Grains_Sizes)
    load(config_file_name);
    clearvars ConfigFileName;
    load('GrainDataBase.mat');
    load('grains_type_1.mat');
    IsError = 0;
    if VideoFlags.COLOR_STIMULI_FLAG
        Frames = zeros([FrameConfig.NUMBER_ROWS FrameConfig.NUMBER_COLUMNS 3 FrameConfig.NUMBER_OF_FRAMES]);
        Frames = uint8(Frames);
    else
        Frames = zeros([FrameConfig.NUMBER_ROWS FrameConfig.NUMBER_COLUMNS FrameConfig.NUMBER_OF_FRAMES]);
    end
    first_run_flag = 1;
    First_size_rate=ceil(30*mean(mean(Final_Grains_Sizes(:,:,1))));
    for Curr_Frame = 1 : FrameConfig.NUMBER_OF_FRAMES
        fprintf('Creating Frame Num #%d\n',Curr_Frame);
        BuildFrame = zeros([FrameConfig.NUMBER_ROWS FrameConfig.NUMBER_COLUMNS]);
        [row ,col] = find(Final_Grains_Locations(:,:,Curr_Frame)>0);
        
        for l=1:length(row)

            row_curr_grain=row(l);
            col_curr_grain=col(l);
            if first_run_flag
                First_size_rate=ceil(30*Final_Grains_Sizes(row_curr_grain,col_curr_grain,Curr_Frame));
                first_run_flag = 0;
            end
            CurrGrainType =Final_Grains_Types(row_curr_grain,col_curr_grain,Curr_Frame);
            if (CurrGrainType<1) || (CurrGrainType>7)
                fprintf('The grain type must be in range [1,7] and the value is %d for frame: %d, location: [%d,%d]\n', CurrGrainType,Curr_Frame,row_curr_grain,col_curr_grain);
                IsError = 1;
                return;
            end
%             G=grain(:,:,CurrGrainType);
%             G=resize_grain(G,Final_Grains_Sizes(row_curr_grain,col_curr_grain,Curr_Frame));
            grain_pixel_size= ceil(30*Final_Grains_Sizes(row_curr_grain,col_curr_grain,Curr_Frame));
            if (grain_pixel_size > 60)
                disp('Error:Currently support up to tiwce the grain size please increase database');
                IsError = 1;
                return;
            end
            if ~GrainsConfig.CHANGE_GRAIN_SIZE
                grain_pixel_size = First_size_rate; 
            end
            
            G=A{grain_pixel_size,1};
            G=G(:,:,CurrGrainType);
            
            G_new_size=size(G);
            
            i = row_curr_grain+size(G_new_size,1);
            j = col_curr_grain+size(G_new_size,1);
            start_row   = i - floor(G_new_size(1)/2);
            stop_row    = i - floor(G_new_size(1)/2)+ G_new_size(1)-1;
            start_col   = j - floor(G_new_size(2)/2);
            stop_col    = j - floor(G_new_size(2)/2)+ G_new_size(2)-1;
            
            if ((start_row>=1) && (stop_row<=FrameConfig.NUMBER_ROWS) && (start_col>=1) && (stop_col<=FrameConfig.NUMBER_COLUMNS))
                BuildFrame(start_row:stop_row,start_col:stop_col) = G*Final_Grains_Locations(row_curr_grain,col_curr_grain,Curr_Frame) + (BuildFrame(start_row:stop_row,start_col:stop_col).*(1-G));
%                 Frames( start_row:stop_row,start_col:stop_col,Curr_Frame )=G*Final_Grains_Locations(row_curr_grain,col_curr_grain,Curr_Frame) + (Frames(start_row:stop_row,start_col:stop_col,Curr_Frame).*(1-G));
            end
        end
        if VideoFlags.COLOR_STIMULI_FLAG
            Frames(:,:,:,Curr_Frame) = Gray2RGB(BuildFrame,ColorConfig);
        else
            Frames(:,:,Curr_Frame) = BuildFrame;
        end
        if debug_mode && Curr_Frame==1
                Debug_MATRIX = Frames(:,:,Curr_Frame);
                imshow(Frames(:,:,:,1),'First_Frame.png');
        end
    end
end

