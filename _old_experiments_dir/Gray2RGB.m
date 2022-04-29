function [ RGBFrame ] = Gray2RGB( GrayFrame,ColorConfig )
    FrameSize = size(GrayFrame);
    RGBFrame = uint8(zeros(FrameSize(1),FrameSize(2),3)); 
    
    GrayFrame = round(GrayFrame*ColorConfig.NUMBER_OF_COLORS);
   
    if ColorConfig.COLOR_OF_BACKGROUND == 7
        GrayFrame(GrayFrame==0)=7;
    end
    
    RedFrame = uint8(GrayFrame);
    GreenFrame = uint8(GrayFrame);
    BlueFrame = uint8(GrayFrame);

    for i=1:7
        RedFrame(RedFrame==i) = ColorConfig.COLORS(i,1);
        GreenFrame(GreenFrame==i) = ColorConfig.COLORS(i,2);
        BlueFrame(BlueFrame==i) = ColorConfig.COLORS(i,3);
    end

    RGBFrame(:,:,1)=RedFrame;
    RGBFrame(:,:,2)=GreenFrame;
    RGBFrame(:,:,3)=BlueFrame;

end

