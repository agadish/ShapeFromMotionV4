function OBJ_IMG_ROTATION = CreateRotation(OBJ_IMG,RotationConfig,FrameConfig)
    different_rotations_frames = sort(randperm(FrameConfig.NUMBER_OF_FRAMES-3,RotationConfig.NUM_CHANGE_ROTATE_DIRECTION)+3);
    direction =1;
    OBJ_IMG_ROTATION = OBJ_IMG(:,:,1);
    lastFrame = OBJ_IMG_ROTATION;
    rot_angle = 0;
    for frame_num=2:FrameConfig.NUMBER_OF_FRAMES
        if ismember(frame_num,different_rotations_frames)
            direction = direction*(-1);          
        end
        currFrame = OBJ_IMG(:,:,frame_num);
        rot_angle = rot_angle + direction*RotationConfig.ROTATE_ANGEL_PER_FRAME;
        currFrame=imrotate(currFrame,rot_angle,'bilinear', 'crop');
        OBJ_IMG_ROTATION(:,:,frame_num) = round(currFrame);
    end
end

