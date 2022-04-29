function [ ShapeName ] = RandObjShape(  )
    switch randi(7)
        case 1 
            ObjectConfig.NAME = 'Shapes\fish.png';
        case 2 
            ObjectConfig.NAME = 'Shapes\butterfly.png';
        case 3 
            ObjectConfig.NAME = 'Shapes\duck.png';
        case 4 
            ObjectConfig.NAME = 'Shapes\bunny.png';
        case 5 
            ObjectConfig.NAME = 'Shapes\horse2.png';
        case 6
            ObjectConfig.NAME = 'Shapes\monster.png';
        case 7
            ObjectConfig.NAME = 'Shapes\elephantBin.png';
        otherwise 
            ObjectConfig.NAME = 'Shapes\fish.png';
    end
end

