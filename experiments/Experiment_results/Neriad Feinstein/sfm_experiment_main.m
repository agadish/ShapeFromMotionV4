close all;
clear all;
clc;
%Please enter your name
Name = 'Snir Vardi';
Date = datestr(now,30);

% We will perform experiment type 2 twice, and type 3 twice
Exp_Type = 3;

%When you're ready please press F5
sfm_experiment2(Name,Date,Exp_Type);

%Good Luck