close all;
clear all;
clc;

Date = datestr(now,30);
%Please enter your name
Name = 'Assaf';

% We will perform experiment type 1 twice, and type 2 twice
% When you're ready please press F5           

Exp_Type = 1;
sfm_experiment3(Name ,Date,Exp_Type); 
Exp_Type = 2;
sfm_experiment3(Name ,Date,Exp_Type); 
Exp_Type = 1;
sfm_experiment3(Name ,Date,Exp_Type); 
Exp_Type = 2;       
sfm_experiment3(Name ,Date,Exp_Type); 
         
% Good Luck