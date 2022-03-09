function [ OBJ,IsError ] = ResizeObj( obj,ObjectConfig, FrameConfig)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% Set the parameters   
    M = FrameConfig.NUMBER_COLUMNS;
    N = FrameConfig.NUMBER_ROWS;
    No_Of_Frames = FrameConfig.NUMBER_OF_FRAMES;
    m_loc = ObjectConfig.INITIAL_COLUMN_LOCATION;
    n_loc = ObjectConfig.INITIAL_ROW_LOCATION;
    stop_ratio = ObjectConfig.FINAL_OBJ_RATIO_SIZE;
    start_ratio = ObjectConfig.INITIAL_OBJ_RATIO_SIZE;
    IsError = 0;
%%
    OBJ=zeros(N,M,No_Of_Frames);
    ratio=linspace(start_ratio,stop_ratio,No_Of_Frames); % if start_ratio==stop_ratio then the ratio vector contain the same number at each location
    
    %Changing the size of the object in each frame
    for i=1:No_Of_Frames
        if ratio(i) ~= 1
            temp=imresize(obj,ratio(i));
        else
            temp = obj;
        end
        temp=round(temp);
        x=size(temp);
        center=ceil(x/2);
        obj_start_row = n_loc-center(1);
        obj_end_row = n_loc-center(1)+x(1)-1;
        obj_start_col = m_loc-center(2);
        obj_end_col = m_loc-center(2)+x(2)-1;
        if (obj_end_row>FrameConfig.NUMBER_ROWS) || (obj_start_row<1) || (obj_end_col>FrameConfig.NUMBER_COLUMNS) || (obj_start_col<1)
            disp('Need to change start location of the OBJ.')
            IsError = 1;
            return;
        end
        OBJ( obj_start_row:obj_end_row , obj_start_col:obj_end_col, i)=temp;
    end
end

