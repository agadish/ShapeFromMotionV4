function [ StatisticsConfig ] = RandStatistics( StatisticsConfig )
% Note: in order to maintain normal distribution, and to avoid negative
% numbers, need to select MEAN and SD according to the following table:
% | MEAN |  MAX_SD_ALLOWED |
% |  1   |      0.1        |
% |  2   |      0.3        |
% |  3   |      0.5        |
% |  4   |      0.8        |
% |  5   |      1.1        |
% |  6   |      1.3        |
% |  7   |      1.7        |
% |  8   |      1.9        |
% |  9   |      2.2        |
% |  10  |      2.5        |
    StatisticsConfig.MEAN_NOF_BACKGROUND = randi([1,10]);
    switch (StatisticsConfig.MEAN_NOF_BACKGROUND)
        case 1
            StatisticsConfig.SD_NOF_BACKGROUND = rand()*0.1;
        case 2
            StatisticsConfig.SD_NOF_BACKGROUND = rand()*0.3;
        case 3
            StatisticsConfig.SD_NOF_BACKGROUND = rand()*0.5;
        case 4
            StatisticsConfig.SD_NOF_BACKGROUND = rand()*0.8;
        case 5
            StatisticsConfig.SD_NOF_BACKGROUND = rand()*1.1;
        case 6
            StatisticsConfig.SD_NOF_BACKGROUND = rand()*1.3;
        case 7
            StatisticsConfig.SD_NOF_BACKGROUND = rand()*1.7;
        case 8
            StatisticsConfig.SD_NOF_BACKGROUND = rand()*1.9;
        case 9
            StatisticsConfig.SD_NOF_BACKGROUND = rand()*2.2;
        case 10
            StatisticsConfig.SD_NOF_BACKGROUND = rand()*2.5;
    end
    StatisticsConfig.LAMBDA_NOF_BACKGROUND = 10*rand() ; 

    StatisticsConfig.MEAN_NOF_OBJ = randi([1,10]);
    switch (StatisticsConfig.MEAN_NOF_OBJ)
        case 1
            StatisticsConfig.SD_NOF_OBJ = rand()*0.1;
        case 2
            StatisticsConfig.SD_NOF_OBJ = rand()*0.3;
        case 3
            StatisticsConfig.SD_NOF_OBJ = rand()*0.5;
        case 4
            StatisticsConfig.SD_NOF_OBJ = rand()*0.8;
        case 5
            StatisticsConfig.SD_NOF_OBJ = rand()*1.1;
        case 6
            StatisticsConfig.SD_NOF_OBJ = rand()*1.3;
        case 7
            StatisticsConfig.SD_NOF_OBJ = rand()*1.7;
        case 8
            StatisticsConfig.SD_NOF_OBJ = rand()*1.9;
        case 9
            StatisticsConfig.SD_NOF_OBJ = rand()*2.2;
        case 10
            StatisticsConfig.SD_NOF_OBJ = rand()*2.5;
    end
    StatisticsConfig.SD_NOF_OBJ = rand(); 

    StatisticsConfig.MEAN_NOF_OBJ_COLOR = randi([4,10]);
    StatisticsConfig.SD_NOF_OBJ_COLOR = rand(); 

end

