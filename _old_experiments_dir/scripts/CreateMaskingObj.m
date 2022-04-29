clear all;
close all;
clc;

SharedAreaType = 2; % 1 = comb technique, 2 = rand pixels technique
A = zeros(600,800);
B = zeros(600,800);
withTJ = 0;
Opacity = 1;
%Frequency of shared obj (for comb technique)
Opacity_freq = 10;
% Opacity in precentage (for rand pixels technique). 0.5 -> 50% opacity
Opacity_value = 0.5;
if withTJ
    A(101:300,201:500) = ones(200, 300);
    B(201:400,301:600) = ones(200, 300);
else
    A(201:400,201:500) = ones(200, 300);
    B(201:400,401:700) = ones(200, 300);
end

% The shared area is [201:300,301:500]
switch SharedAreaType
    case 1
        if Opacity 
            for i=201:2*Opacity_freq:300
                for j=301:2*Opacity_freq:500
                    if (i+2*Opacity_freq-1 > 300) && (j+2*Opacity_freq-1 > 500)
                        break;
                    else
                        A(i:(i+Opacity_freq-1),j:(j+Opacity_freq-1))=zeros(Opacity_freq);
                        B(i:(i+Opacity_freq-1),j+Opacity_freq:(j+2*Opacity_freq-1))=zeros(Opacity_freq);
                        B(i+Opacity_freq:(i+2*Opacity_freq-1),j:(j+Opacity_freq-1))=zeros(Opacity_freq);
                    end
                end
            end
        end
        % removing extra holes
        B(301:400,301:500) = ones(100, 200);
        B(201:300,501:600) = ones(100, 100);
    case 2
        if Opacity
            if withTJ
                SharedArea(1:100,1:200)=1;
            else
                SharedArea(1:200,1:100)=1;
            end
            pixels=find(SharedArea==1);
            temp=randperm(length(pixels),round(length(pixels)*Opacity_value));
            ind=pixels(temp);
            SharedArea(ind)=0;
            if withTJ
                A(201:300,301:500)=SharedArea;
                B(201:300,301:500)=1-SharedArea;      
            else
                A(201:400,401:500)=SharedArea;
                B(201:400,401:500)=1-SharedArea;
            end
            
        end
end

%% Show image and save
imshow(A+B);
figure;
imshowpair(A,B);
imwrite(A,'..\Shapes\RectAShared.png');

imwrite(B,'..\Shapes\RectBShared.png');
