function [  ] = CreateVideo( Name_Str,Frames, FrameConfig,IsColor )
    StimuliVid = VideoWriter(Name_Str);
    StimuliVid.FrameRate = FrameConfig.FPS;
        open(StimuliVid);
        for k=1:FrameConfig.NUMBER_OF_FRAMES
            if IsColor
                currframe = Frames(:,:,:,k);
            else
                currframe = Frames(:,:,k);
            end
            writeVideo(StimuliVid,currframe);
        end
        close(StimuliVid);
end
