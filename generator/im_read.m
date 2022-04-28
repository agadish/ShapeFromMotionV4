function [ im ] = im_read( file_name )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
im=imread(file_name);
im=rgb2gray(im);
im=double(im/max(im(:)));
end

