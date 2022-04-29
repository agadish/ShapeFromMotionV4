% Clear the workspace
close all;
clear all;
sca;

% Setup PTB with some default values
PsychDefaultSetup(2);

% Set the screen number to the external secondary monitor if there is one
% connected
screenNumber = max(Screen('Screens'));
% Screen('Preference', 'SkipSyncTests', 1);
% help SyncTrouble

% Define black, white and grey
white = WhiteIndex(screenNumber);
grey = white / 2;
black = BlackIndex(screenNumber);

% Activate this for debugging
% PsychDebugWindowConfiguration;

% Open the screen
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [], 32, 2);

% Flip to clear
Screen('Flip', window);

% Set the text size
Screen('TextSize', window, 40);

% Query the maximum priority level
topPriorityLevel = MaxPriority(window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Hide the mouse cursor
HideCursor;

%----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------

% Define the keyboard keys that are listened for. 
% We will be using the y,n and 1-4 keys (only on the right side of the keyboard) 
% as response keys for the task and the escape key as an exit/reset key
escKey = KbName('ESCAPE');
yesKey = KbName('y');
noKey = KbName('n');
oneKey = KbName('1');
twoKey = KbName('2');
threeKey = KbName('3');
fourKey = KbName('4');

% Enable only the keys above in the trial
% RestrictKeysForKbCheck([escapeKey,yesKey,noKey,oneKey,twoKey,threeKey,fourKey,spaceKey]);

%-------------------------------------------------------------------------------
%                     Stimuli, snapshots and templates matrices
%-------------------------------------------------------------------------------

stimuli = {'\experiment\stimuli\noise_cyan.avi', '\experiment\stimuli\noise_blue.avi', '\experiment\stimuli\noise_yellow.avi', '\experiment\stimuli\noise_yellow_30.avi', '\experiment\stimuli\noise_yellow_60.avi', '\experiment\stimuli\noise_lum_red.avi',...
           '\experiment\stimuli\bunny_cyan.avi', '\experiment\stimuli\bunny_blue.avi', '\experiment\stimuli\bunny_yellow.avi', '\experiment\stimuli\bunny_yellow_30.avi', '\experiment\stimuli\bunny_yellow_60.avi', '\experiment\stimuli\bunny_gray.avi',...
           '\experiment\stimuli\butterfly_cyan.avi', '\experiment\stimuli\butterfly_blue.avi', '\experiment\stimuli\butterfly_yellow.avi', '\experiment\stimuli\butterfly_yellow_30.avi', '\experiment\stimuli\butterfly_yellow_60.avi', '\experiment\stimuli\butterfly_lum_red.avi',...
           '\experiment\stimuli\dolphin_cyan.avi', '\experiment\stimuli\dolphin_blue.avi', '\experiment\stimuli\dolphin_yellow.avi', '\experiment\stimuli\dolphin_yellow_30.avi', '\experiment\stimuli\dolphin_yellow_60.avi', '\experiment\stimuli\dolphin_gray.avi',...
           '\experiment\stimuli\duck_cyan.avi', '\experiment\stimuli\duck_blue.avi', '\experiment\stimuli\duck_yellow.avi', '\experiment\stimuli\duck_yellow_30.avi', '\experiment\stimuli\duck_yellow_60.avi', '\experiment\stimuli\duck_lum_red.avi',...
           '\experiment\stimuli\amorph_cyan.avi', '\experiment\stimuli\amorph_blue.avi', '\experiment\stimuli\amorph_yellow.avi'};
% stimuli = {'\experiment\stimuli\bunny_cyan.avi', '\experiment\stimuli\bunny_blue.avi', '\experiment\stimuli\bunny_yellow.avi', '\experiment\stimuli\bunny_yellow_30.avi', '\experiment\stimuli\bunny_yellow_60.avi'};

snap_before = {'experiment/snapshots/noise cyan snap.png','experiment/snapshots/noise blue snap.png','experiment/snapshots/noise yellow snap.png','experiment/snapshots/noise 30% snap.png','experiment/snapshots/noise 60% snap.png','experiment/snapshots/noise lum snap.png',...
               'experiment/snapshots/bunny_cyan snap 2.png','experiment/snapshots/bunny_blue snap 1.png','experiment/snapshots/bunny_yellow snap 4.png','experiment/snapshots/bunny_yellow 30% snap 3.png','experiment/snapshots/bunny_yellow 60% snap 1.png','experiment/snapshots/bunny_gray snap 1.png',...
               'experiment/snapshots/butterfly_cyan snap 3.png','experiment/snapshots/butterfly_blue snap 2.png','experiment/snapshots/butterfly_yellow snap 1.png','experiment/snapshots/butterfly_yellow 30% snap 2.png','experiment/snapshots/butterfly_yellow 60% snap 2.png','experiment/snapshots/butterfly_lum snap 1.png',...
               'experiment/snapshots/dolphin_cyan snap 2.png','experiment/snapshots/dolphin_blue snap 2.png','experiment/snapshots/dolphin_yellow snap 3.png','experiment/snapshots/dolphin_yellow 30% snap 1.png','experiment/snapshots/dolphin_yellow 60% snap 3.png','experiment/snapshots/dolphin_gray snap 1.png',...
               'experiment/snapshots/duck_cyan snap 2.png','experiment/snapshots/duck_blue snap 1.png','experiment/snapshots/duck_yellow snap 2.png','experiment/snapshots/duck_yellow 30% snap 1.png','experiment/snapshots/duck_yellow 60% snap 1.png','experiment/snapshots/duck_lum snap 2.png',...
               'experiment/snapshots/amorph_cyan snap 3.png','experiment/snapshots/amorph_blue snap 4.png','experiment/snapshots/amorph_yellow snap 1.png'};
% snap_before = {'experiment/snapshots/bunny_cyan snap 2.png','experiment/snapshots/bunny_blue snap 1.png','experiment/snapshots/bunny_yellow snap 4.png','experiment/snapshots/bunny_yellow 30% snap 3.png','experiment/snapshots/bunny_yellow 60% snap 1.png'};

snap_after = {'experiment/snapshots/noise cyan snap 2.png','experiment/snapshots/noise blue snap 2.png','experiment/snapshots/noise yellow snap 2.png','experiment/snapshots/noise 30% snap 2.png','experiment/snapshots/noise 60% snap 2.png','experiment/snapshots/noise lum snap 2.png',...
              'experiment/snapshots/bunny_cyan snap 3.png','experiment/snapshots/bunny_blue snap 4.png','experiment/snapshots/bunny_yellow snap 44.png','experiment/snapshots/bunny_yellow 30% snap 4.png','experiment/snapshots/bunny_yellow 60% snap 4.png','experiment/snapshots/bunny_gray snap 2.png',...
              'experiment/snapshots/butterfly_cyan snap 33.png','experiment/snapshots/butterfly_blue snap 3.png','experiment/snapshots/butterfly_yellow snap 4.png','experiment/snapshots/butterfly_yellow 30% snap 3.png','experiment/snapshots/butterfly_yellow 60% snap 3.png','experiment/snapshots/butterfly_lum snap 4.png',...
              'experiment/snapshots/dolphin_cyan snap 3.png','experiment/snapshots/dolphin_blue snap 4.png','experiment/snapshots/dolphin_yellow snap 4.png','experiment/snapshots/dolphin_yellow 30% snap 4.png','experiment/snapshots/dolphin_yellow 60% snap 4.png','experiment/snapshots/dolphin_gray snap 2.png',...
              'experiment/snapshots/duck_cyan snap 4.png','experiment/snapshots/duck_blue snap 4.png','experiment/snapshots/duck_yellow snap 3.png','experiment/snapshots/duck_yellow 30% snap 4.png','experiment/snapshots/duck_yellow 60% snap 4.png','experiment/snapshots/duck_lum snap 4.png',...
              'experiment/snapshots/amorph_cyan snap 4.png','experiment/snapshots/amorph_blue snap 44.png','experiment/snapshots/amorph_yellow snap 2.png'};
% snap_after = { 'experiment/snapshots/bunny_cyan snap 3.png','experiment/snapshots/bunny_blue snap 4.png','experiment/snapshots/bunny_yellow snap 44.png','experiment/snapshots/bunny_yellow 30% snap 4.png','experiment/snapshots/bunny_yellow 60% snap 4.png'};

templates = {'experiment/template pictures bunny.png','experiment/template pictures bunny 2.png',...
             'experiment/template pictures butterfly.png','experiment/template pictures butterfly 2.png',...
             'experiment/template pictures dolphin.png','experiment/template pictures dolphin 2.png',...
             'experiment/template pictures duck.png','experiment/template pictures duck 2.png',...
             'experiment/template pictures amorph.png','experiment/template pictures amorph 2.png'};

% Make the vector which will determine the order of the trial and randomise it
numTrials = size(stimuli);
numTrials = numTrials(2);
exp_order = 1:numTrials;
shuffler = Shuffle(1:numTrials);
exp_order = exp_order(shuffler);

%----------------------------------------------------------------------
%                     Make a response matrix
%----------------------------------------------------------------------

% This is a six row matrix for the users responses:
% first row - whether the user saw an object in the first snapshot
% second row - the place of the object in the first snapshot, if it was seen
% third row - whether the user saw an object moving in the stimulus
% fourth row - the object in the stimulus, if it was seen
% fith row - whether the user saw an object in the second snapshot
% sixth row - the place of the object in the second snapshot, if it was seen

respMat = nan(6, numTrials);

% Matrix of the right answers. 0 = no, 1 = yes, or the location/picture of the object
ansMat = nan(6, numTrials);
ansMat(1,:) = zeros(1,numTrials);
ansMat(2,:) = [zeros(1,6),2 1 4 3 1 0,3 2 1 2 2 1,2 2 3 1 3 0,2 1 2 1 1 2,3 4 1];
% ansMat(2,:) = [2 1 4 3 1];

ansMat(3,:) = ones(1,numTrials);    % unless the noise stimulus was played (checked later), the user should have seen an object
ansMat(5,:) = zeros(1,numTrials);
ansMat(6,:) = [zeros(1,6),3 4 4 4 4 0,3 3 4 3 3 4,3 4 4 4 4 0,4 4 3 4 4 4,4 4 2];
% ansMat(6,:) = [3 4 4 4 4];

ansMat = ansMat(:,shuffler); % reorder the ansMat to be compatible with the exp_order


%----------------------------------------------------------------------
%                           The Experiment
%----------------------------------------------------------------------

% First run
text = ['Welcome to the experiment\n\nand thank you for participating\n\n\n\nPress any key to begin'];
DrawFormattedText(window,text,'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

% Animation loop: we loop for the total number of trials
for trial = 1:numTrials
    % First snapshot is shown
    if trial == 1
        text = ['You will be shown a colorful noise\n\nfor 5 secs.'...
                ' Please see if you detect\n\nany object in the picture\n\n\n\nPress any key to continue'];
    else
        text = ['Noise for 5 secs next'...
                '\n\n\n\nPress key'];
    end
    DrawFormattedText(window,text,'center', 'center', white);
    Screen('Flip', window);
    KbStrokeWait;

    i = exp_order(trial);
    snap = imread(snap_before{i});
    size(snap);
    snapTexture = Screen('MakeTexture',window,snap);
    Screen('DrawTexture',window,snapTexture);
    Screen('Flip',window);
    WaitSecs(4);
    
    if trial == 1
        text = ['You will be shown the same\n\ncolorful noise for 5 secs.'...
                '\n\n\nPlease see if you detect\n\nany object in the picture\n\n\n\nPress any key to continue'];
    else
        text = ['Same noise for 5 secs next'...
                '\n\n\n\nPress key'];
    end
    DrawFormattedText(window,text,'center', 'center', white);
    Screen('Flip', window);
    KbStrokeWait;
    
    snap = imread(snap_before{i});
    size(snap);
    snapTexture = Screen('MakeTexture',window,snap);
    Screen('DrawTexture',window,snapTexture);
    Screen('Flip',window);
    WaitSecs(4);
    
    % Recording the location of the object in the first snapshot if seen
    if trial == 1 
        text = ['Did you see an object in the picture?\n\n\nIf you did press y, otherwise press n'];
    else
        text = ['Saw an object?\n\n\nyes - press y, no - press n'];
    end
    DrawFormattedText(window,text,'center', 'center', white);
    Screen('Flip', window);
    resp_main = true;
    while resp_main == true;
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown
            if keyCode(noKey)
                respMat(1,trial) = 0;
                respMat(2,trial) = 0;
                resp_main = false;
            elseif keyCode(yesKey)
                resp_main = false;
                respMat(1,trial) = 1;
                if (trial == 1 || (sum(respMat(1,1:trial-1))==0 && sum(respMat(5,1:trial-1))==0))  %first trial or the user never pressed yes before
                    text = ['You will be shown next a picture\n\nof the screen'...
                            ' divided to 4 parts.\n\n\nPress the number of the\n\nlocation (1 to 4) of the object'...
                            '\n\n\n\nPress any key to continue'];
                else
                    text = ['Picture of the screen next'...
                            '\n\nPress 1 to 4 for the object''s location'...
                            '\n\n\n\nPress key'];
                end
                DrawFormattedText(window,text,'center','center',white);
                Screen('Flip', window);
                KbStrokeWait;

                location = imread('experiment/template screen.png');
                size(location);
                locTexture = Screen('MakeTexture',window,location);
                Screen('DrawTexture',window,locTexture);
                Screen('Flip',window);
                  
                resp = true;
                while resp == true
                    [keyIsDown, secs, keyCode] = KbCheck;
                    if keyIsDown
                        if keyCode(oneKey)
                            respMat(2,trial) = 1;
                            resp = false;
                        elseif keyCode(twoKey)
                            respMat(2,trial) = 2;
                            resp = false;
                        elseif keyCode(threeKey)
                            respMat(2,trial) = 3;
                            resp = false;
                        elseif keyCode(fourKey)
                            respMat(2,trial) = 4;
                            resp = false;
                        end
                    end
                end
            end
        end
    end
    
    % Play stimulus
    if trial == 1 
        text = ['You will be shown a stimulus'...
                '\n\n\nPlease see if you detect\n\na moving object in the movie\n\n\n\nPress any key to continue'];
    else
        text = ['Stimulus next'...
                '\n\n\n\nPress key'];
    end
    DrawFormattedText(window,text,'center', 'center', white);
    Screen('Flip', window);
    KbStrokeWait;
    
    i = exp_order(trial);  
    path = [pwd, stimuli{i}];
    sound = 0;
    movie = Screen('OpenMovie',window,path);
    Screen('PlayMovie',movie,1,0,sound);
    tex = Screen('GetMovieImage', window, movie);
    while tex > 0
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown && keyCode(escKey)
            break;
        end
        Screen('DrawTexture', window, tex);
        Screen('Flip', window);
        Screen('Close', tex);
        tex = Screen('GetMovieImage', window, movie);
    end
    Screen('PlayMovie',movie, 0);
    Screen('CloseMovie', movie);
    
    
    % Recording the picture of the object in the stimulus if seen
    if trial == 1
        text = ['Did you see an object in the movie?\n\n\nIf you did press y, otherwise press n'];
    else
        text = ['Saw moving object?\n\n\nyes - press y, no press n'];
    end
    DrawFormattedText(window,text,'center', 'center', white);
    Screen('Flip', window);
    
    % if the stimulus is noise the user should'nt have seen an object
    if i >= 1 && i <= 6
        ansMat(3,trial) = 0;
    end
    
    resp_main = true;
    while resp_main == true;
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown
            if keyCode(noKey)
                respMat(3,trial) = 0;
                respMat(4,trial) = 0;
                resp_main = false;
            elseif keyCode(yesKey)
                resp_main = false;
                respMat(3,trial) = 1;
                if (trial == 1 || sum(respMat(3,1:trial-1))==0)  %first trial or the user never pressed yes before
                    text = ['You will be shown next\n\nfour different objects'...
                            '\n\n\nPress the number of the object (1 to 4)\n\nthat you''ve seen'...
                            '\n\n\n\nPress any key to continue'];
                else
                    text = ['Next four different objects\n\nPress 1 to 4 for the object''s picture\n\n\n\nPress key'];
                end
                DrawFormattedText(window,text,'center','center',white);
                Screen('Flip', window);
                KbStrokeWait;
                
                % Checking which object picture template is compatible to the current stimulus
                if (exp_order(trial) >= 1 && exp_order(trial) <= 6)  % noise
                    i = randi([1,10],1);
%                     i = randi([1,2],1);
                elseif (exp_order(trial) >= 7 && exp_order(trial) <= 12) % bunny
                    i = randi([1,2],1);
                elseif (exp_order(trial) >= 13 && exp_order(trial) <= 18) % butterfly
                    i = randi([3,4],1);
                elseif (exp_order(trial) >= 19 && exp_order(trial) <= 24) % dolphin
                    i = randi([5,6],1);
                elseif (exp_order(trial) >= 25 && exp_order(trial) <= 30) % duck
                    i = randi([7,8],1);
                elseif (exp_order(trial) >= 31 && exp_order(trial) <= 33) % amorph
                    i = randi([9,10],1);
                end
                              
                object = imread(templates{i});
                size(object);
                objTexture = Screen('MakeTexture',window,object);
                Screen('DrawTexture',window,objTexture);
                Screen('Flip',window);
        
                resp = true;
                while resp == true
                    [keyIsDown, secs, keyCode] = KbCheck;
                    if keyIsDown
                        if keyCode(oneKey)
                            respMat(4,trial) = 1;
                            resp = false;
                        elseif keyCode(twoKey)
                            respMat(4,trial) = 2;
                            resp = false;
                        elseif keyCode(threeKey)
                            respMat(4,trial) = 3;
                            resp = false;
                        elseif keyCode(fourKey)
                            respMat(4,trial) = 4;
                            resp = false;
                        end
                    end
                end
            end         
        end
    end
    
    % Checking which object picture template is compatible to the
    % current stimulus for ansMat (even if the user didn't see a moving object)
    if (exp_order(trial) >= 1 && exp_order(trial) <= 6)  % noise
        ansMat(4,trial) = 0;
    else
        switch i                    
            case 1  % bunny
                ansMat(4,trial) = 1;
            case 2
                ansMat(4,trial) = 2;
            case 3  % butterfly
                ansMat(4,trial) = 3;
            case 4
                ansMat(4,trial) = 3;
            case 5  % dolphin
                ansMat(4,trial) = 2;
            case 6
                ansMat(4,trial) = 1;
            case 7  % duck
                ansMat(4,trial) = 4;
            case 8
                ansMat(4,trial) = 2;
            case 9  % amorph
                ansMat(4,trial) = 1;
            case 10
                ansMat(4,trial) = 2;
        end
    end
    
    % Second snapshot is shown
    if trial == 1
        text = ['You will be shown a colorful noise\n\nfor 5 secs.'...
                ' Please see if you detect\n\nany object in the picture\n\n\n\nPress any key to continue'];
    else
        text = ['Noise for 5 secs next'...
                '\n\n\n\nPress key'];
    end
    DrawFormattedText(window,text,'center', 'center', white);
    Screen('Flip', window);
    KbStrokeWait;
    
    i = exp_order(trial);
    snap = imread(snap_after{i});
    size(snap);
    snapTexture = Screen('MakeTexture',window,snap);
    Screen('DrawTexture',window,snapTexture);
    Screen('Flip',window);
    WaitSecs(4);
    
    if trial == 1
        text = ['You will be shown the same\n\ncolorful noise for 5 secs.'...
                '\n\n\nPlease see if you detect\n\nany object in the picture\n\n\n\nPress any key to continue'];
    else
        text = ['Same noise for 5 secs next'...
                '\n\n\n\nPress key'];
    end
    DrawFormattedText(window,text,'center', 'center', white);
    Screen('Flip', window);
    KbStrokeWait;
    
    snap = imread(snap_after{i});
    size(snap);
    snapTexture = Screen('MakeTexture',window,snap);
    Screen('DrawTexture',window,snapTexture);
    Screen('Flip',window);
    WaitSecs(4);
    
    % Recording the location of the object in the second snapshot if seen
    if trial == 1
        text = ['Did you see an object in the picture?\n\n\nIf you did press y, otherwise press n'];
    else
        text = ['Saw an object?\n\n\nyes - press y, no - press n'];
    end
    DrawFormattedText(window,text,'center', 'center', white);
    Screen('Flip', window);
    resp_main = true;
    while resp_main == true;
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown
            if keyCode(noKey)
                respMat(5,trial) = 0;
                respMat(6,trial) = 0;
                resp_main = false;
            elseif keyCode(yesKey)
                resp_main = false;
                respMat(5,trial) = 1;
                if (trial == 1 || (sum(respMat(1,1:trial))==0 && sum(respMat(5,1:trial-1))==0))  %first trial or the user never pressed yes before
                    text = ['You will be shown next a picture\n\nof the screen'...
                            ' divided to 4 parts.\n\n\nPress the number of the\n\nlocation (1 to 4) of the object'...
                            '\n\n\n\nPress any key to continue'];
                else
                    text = ['Picture of the screen next'...
                            '\n\nPress 1 to 4 for the object''s location'...
                            '\n\n\n\nPress key'];
                end
                DrawFormattedText(window,text,'center','center',white);
                Screen('Flip', window);
                KbStrokeWait;

                location = imread('experiment/template screen.png');
                size(location);
                locTexture = Screen('MakeTexture',window,location);
                Screen('DrawTexture',window,locTexture);
                Screen('Flip',window);
                  
                resp = true;
                while resp == true
                    [keyIsDown, secs, keyCode] = KbCheck;
                    if keyIsDown
                        if keyCode(oneKey)
                            respMat(6,trial) = 1;
                            resp = false;
                        elseif keyCode(twoKey)
                            respMat(6,trial) = 2;
                            resp = false;
                        elseif keyCode(threeKey)
                            respMat(6,trial) = 3;
                            resp = false;
                        elseif keyCode(fourKey)
                            respMat(6,trial) = 4;
                            resp = false;
                        end
                    end
                end
            end
        end
    end
end
      
text = ['The experiment has ended\n\nThank you for participating\n\n\n\nPress any key to exit'];
DrawFormattedText(window,text,'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

sca;

% Statistics matrix of the experiment
% 0 = the user didn't answer as expected
% 1 = the user answered as expected 
% 2 = the user was wrong (user didn't answer as expected) - for second and sixth row in ansMat/respMat
% 3 = the user was right (user didn't answer as expected) - for second and sixth row in ansMat/respMat
statMat = zeros(6, numTrials);
statMat(1,:) = ~respMat(1,:);
statMat(3,:) = respMat(3,:)==ansMat(3,:);
statMat(4,:) = respMat(4,:)==ansMat(4,:);
statMat(5,:) = ~respMat(5,:);
statMat(2,respMat(2,:)==ansMat(2,:)) = 3;
statMat(2,respMat(2,:)~=ansMat(2,:)) = 2;
statMat(2,respMat(2,:)==0) = 1; 
statMat(6,respMat(6,:)==ansMat(6,:)) = 3;
statMat(6,respMat(6,:)~=ansMat(6,:)) = 2;
statMat(6,respMat(6,:)==0) = 1; 

xlswrite('statistics_viki.xls',statMat);    
xlswrite('resp_viki.xls',respMat);
xlswrite('ans_viki.xls',ansMat);

save('viki.mat','*Mat','exp_order');
