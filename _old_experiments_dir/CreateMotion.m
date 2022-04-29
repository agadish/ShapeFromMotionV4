function [OBJ_IMG_MOTION] = CreateMotion(OBJ_IMG,MotionConfig,FrameConfig)  
    [a,b,c] = size(OBJ_IMG);
    OBJ_IMG_MOTION = zeros(a,b,c);
    OBJ_IMG_MOTION(:,:,1) = OBJ_IMG(:,:,1);
    down_step = 0;
    right_step = 0;
    for CurrFrame=2:MotionConfig.FRAMES_PER_MOTION:FrameConfig.NUMBER_OF_FRAMES-1
        down_step = down_step + MotionConfig.DOWN_STEP;
        right_step = right_step + MotionConfig.RIGHT_STEP;
        OBJ_IMG_MOTION(:,:,CurrFrame) = circshift(OBJ_IMG(:,:,CurrFrame),[down_step, right_step]);
        OBJ_IMG_MOTION(:,:,CurrFrame:(CurrFrame+MotionConfig.FRAMES_PER_MOTION-1))= repmat(OBJ_IMG_MOTION(:,:,CurrFrame),1,1,MotionConfig.FRAMES_PER_MOTION);
        if ((CurrFrame + MotionConfig.FRAMES_PER_MOTION) >= FrameConfig.NUMBER_OF_FRAMES )
            CurrFrame = FrameConfig.NUMBER_OF_FRAMES - 2 * MotionConfig.FRAMES_PER_MOTION;
        end
    end

%     for frame_num=1:size(OBJ_IMG,3)
%         currFrame=OBJ_IMG(:,:,frame_num);
%         endSectionFrame = frame_num*MotionConfig.FRAMES_PER_MOTION;
%         startSectionFrame = ((frame_num-1)*MotionConfig.FRAMES_PER_MOTION)+1;
%         OBJ_IMG_MOTION(:,:,startSectionFrame:endSectionFrame) = repmat(currFrame,1,1,MotionConfig.FRAMES_PER_MOTION);
%     end
    OBJ_IMG_MOTION = OBJ_IMG_MOTION(:,:,1:FrameConfig.NUMBER_OF_FRAMES);
end

