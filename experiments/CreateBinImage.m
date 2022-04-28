function [ OBJ_I ] = CreateBinImage( I_name, opacity_flag, opacity, starting_angel)    


%% This section changes a given photo to binary.
    OBJ_I=imread(I_name);
    if (size(OBJ_I,3) ~= 1)
        OBJ_I=rgb2gray(OBJ_I);
        threshold = graythresh(OBJ_I);
        OBJ_I = imbinarize(OBJ_I, threshold);
        OBJ_I = double(OBJ_I);
    else
    	OBJ_I = double(ceil(OBJ_I/255));
    end
    if (starting_angel ~= 0)
        OBJ_I = imrotate(OBJ_I,starting_angel);
    end
    %% Create transperency by zero part of the object cells
    if opacity_flag ~= 0
        a=find(OBJ_I>0); %return vector of all the cells that met with the given condition (according to the position in column stuck order).
        temp=randperm(length(a),round(length(a)*opacity));
        ind=a(temp);
        OBJ_I(ind)=0;
    end
end

