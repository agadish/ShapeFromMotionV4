function CreateImages( )
    steps = 360;
    load('video\Rabbit\Rabbit.mat');
    for i=1:150
        %for rabbit the jumps at: 5-18, 82-95, 105-117, 400-413, 478-490,499-512
        name = strcat('video\Rabbit\images\Frame',num2str(i),'.png');
        frame = padarray(objVideo(:,:,i),[128 171],1); %0.8=[75 100], o.7=[128 171] 0.5=[300 400]
        frame = imresize(frame,0.7);
        frame(frame>0.5)=1;
        frame(frame<=0.5)=0;
        
        if (((i>4)&&(i<19))||((i>81)&&(i<96))||((i>104)&&(i<118))||((i>399)&&(i<414))||((i>477)&&(i<491))||((i>498)&&(i<513)))
            frame = circshift(frame,[0, steps]);
            steps = steps-4;
        else
            frame = circshift(frame,[0, steps]);
        end

        if i<117
            frame(:,1:450)=1;
        else
            frame(:,1:100)=1;
        end
%         if i>62&&i<=157
%             frame(:,401:800)=1;
%         end
        frame = flip(frame,2);
        imwrite(frame,name);     
    end
end

