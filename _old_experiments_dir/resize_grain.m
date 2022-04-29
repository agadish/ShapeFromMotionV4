function [ b ] = resize_grain( b,b_size )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    b=imresize(b,b_size);
    b=round(b);

end

