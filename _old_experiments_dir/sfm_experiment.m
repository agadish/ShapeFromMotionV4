function sfm_experiment (Name, Date) 
% Clear the workspace
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
% [window, windowRect] = Screen('OpenWindow', screenNumber, grey, [], 32, 2);

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
rightKey = KbName('RightArrow');
leftKey = KbName('LeftArrow');
replayKey = KbName('r');

% Enable only the keys above in the trial
% RestrictKeysForKbCheck([escapeKey,yesKey,noKey,oneKey,twoKey,threeKey,fourKey,spaceKey]);

%-------------------------------------------------------------------------------
%                     Stimuli, snapshots and templates matrices
%-------------------------------------------------------------------------------

stimuli = {'experiment\Exp\Ethan\1.avi'...
           'experiment\Exp\Ethan\3.avi'};

% Make the vector which will determine the order of the trial and randomise it
numTrials = size(stimuli ,2);
exp_order = 1:numTrials;
shuffler = Shuffle(1:numTrials);
exp_order = exp_order(shuffler);

%----------------------------------------------------------------------
%                     Make a response matrix
%----------------------------------------------------------------------

% This is a six row matrix for the users responses:
% first row - which object covered the other 1 for right 0 for left
% second row - number of replays


respMat = nan(3, numTrials);
respMat(2:3,:) = 0; 

%----------------------------------------------------------------------
%                           The Experiment
%----------------------------------------------------------------------

% First run
text = "Thank you for participating in Ethan & Liza's Final Project experiment\n\n\n\nPlease press any key to begin";
DrawFormattedText(window,text,'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

% Animation loop: we loop for the total number of trials
for trial = 1:numTrials
    % Play stimulus
    if trial == 1 
        text = ['You will be shown a number of stimuli\n\n\n'...
                'Please observe them carefully\n\n'...
                'Determine which of the objects covers the other\n\n\n'...
                'Please press any key to continue'];
    else
        text = ['Next Stimulus'...
                '\n\n\n\nPlease press any key to continue'];
    end
    DrawFormattedText(window,text,'center', 'center', white);
    Screen('Flip', window);
    KbStrokeWait;
    
    i = exp_order(trial);  
    path = strcat(pwd, '\',stimuli{i});
    %No sound
    sound = 0;
   try
       movie = Screen('OpenMovie',window,path);
   catch ME
       fprintf('Error');
       ME.getReport
   end
    Screen('PlayMovie',movie,1,0,sound);
    tex = Screen('GetMovieImage', window, movie);
    resp_main = true;
    timeval = tic;
    while tex > 0
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown && (keyCode(rightKey) || keyCode(leftKey))
            toc(timeval);
            if keyCode(rightKey)
                respMat(1,trial) = 1;
            else
                respMat(1,trial) = 0;
            end 
            resp_main = false;
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
    if resp_main
    text = ['Which of the objects covered the other?\n\n\n'...
            'Right arrow for right, and Left arrow for left\n\n\n'...
            'to replay the video please press R'];
    DrawFormattedText(window,text,'center', 'center', white);
    Screen('Flip', window);
    end
    
%User response
    
    while resp_main == true
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown
            %1 is Right, 0 is left
            if keyCode(rightKey)
                toc(timeval);
                respMat(1,trial) = 1;
                resp_main = false;
            elseif keyCode(leftKey)
                toc(timeval);
                resp_main = false;
                respMat(1,trial) = 0;
            elseif keyCode(replayKey)
                respMat(2,trial)= 1 + respMat(2,trial);
                try
                       movie = Screen('OpenMovie',window,path);
                catch ME
                       fprintf('Error');
                       ME.getReport
                end
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

                text = ['Which of the objects covered the other?\n\n\n'...
                        'Right arrow for right, and Left arrow for left\n\n\n'...
                        'to replay the video please press R'];
                DrawFormattedText(window,text,'center', 'center', white);
                Screen('Flip', window);
            else
                text = ['R and Left arrow keys are the only legal options\n\n\n'...
                        'Right arrow for right, and Left arrow for left\n\n\n'...
                        'to replay the video please press R'];
                DrawFormattedText(window,text,'center', 'center', white);
                Screen('Flip', window);
            end         
        end
    end
    respMat(3,trial) = timeval;
    
end
      
text = ['The experiment has ended\n\nThank you for participating\n\n\n\nPlease press any key to exit'];
DrawFormattedText(window,text,'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;
sca;


if ~isdir(strcat('Experiment_results\',Name))
    mkdir(strcat('Experiment_results\',Name));
end
file_name = strcat('Experiment_results\',Name,'\',Name,'_',Date);
  
xlswrite(strcat(file_name,'_response.xls'),respMat);

save(strcat(file_name,'.mat'),'*Mat','exp_order');

end