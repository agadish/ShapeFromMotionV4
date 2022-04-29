function sfm_experiment2 (Name, Date, ExpIndex) 
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

stimuli_long_movie = {'experiment\Exp\Rect A full rect.avi'...
           'experiment\Exp\Rect B full rect.avi'...
           'experiment\Exp\Shared A  is faster.avi'...
           'experiment\Exp\Shared B is faster.avi'...
           'experiment\Exp\No TJ.avi'};
       
stimuli_short_movie = {'experiment\Exp\Rect_A_full_rect.diff_mean_7.avi'...
           'experiment\Exp\Rect_B_full_rect.diff_mean_7.avi'...
           'experiment\Exp\Shared.A_is_faster.diff_mean_7.avi'...
           'experiment\Exp\Shared.B_is_faster.diff_mean_7.avi'...
           'experiment\Exp\No_TJ.diff_mean_7.avi'};
       
stimuli_small_diff = {'experiment\Exp\Rect_A_full_rect.diff_mean_2.avi'...
           'experiment\Exp\Rect_B_full_rect.diff_mean_2.avi'...
           'experiment\Exp\Shared.A_is_faster.diff_mean_2.avi'...
           'experiment\Exp\Shared.B_is_faster.diff_mean_2.avi'...
           'experiment\Exp\No_TJ.diff_mean_2.avi'};

switch ExpIndex
    case 1
        stimuli=stimuli_long_movie;
    case 2
        stimuli=stimuli_short_movie;
    case 3
        stimuli=stimuli_small_diff;
end
% Make the vector which will determine the order of the trial and randomise it
numTrials = size(stimuli ,2);
exp_order = 1:numTrials;

%----------------------------------------------------------------------
%                     Make a response matrix
%----------------------------------------------------------------------

% This is a six row matrix for the users responses:
% first row - which object covered the other 1 for right 0 for left
% second row - number of replays

maxLoop = 5;
respMat = nan(5*maxLoop+1, numTrials);
%----------------------------------------------------------------------
%                           The Experiment
%----------------------------------------------------------------------

% First run
text = 'Thank you for participating in Dana & Niv final project expiriment\n\n\n\nPlease press any key to begin';
DrawFormattedText(window,text,'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;
for loopNum = 0:maxLoop-1
    respMat(loopNum*5 + 1,:)=loopNum+1;
    respMat(loopNum*5 + 3,:) = 0;
    respMat(loopNum*5 + 4,:) = 0;
    
    shuffler = Shuffle(1:numTrials);
    exp_order = exp_order(shuffler);
    % Animation loop: we loop for the total number of trials
    for trial = 1:numTrials
        % Play stimulus
        if trial == 1 && loopNum == 0
            text = ['You will be shown a number of stimuli\n\n\n'...
                    'Please observe it carefully\n\n'...
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
                elapsedTime=toc(timeval);
                if keyCode(rightKey)
                    respMat(loopNum*5 + 2,i) = 1;
                else
                    respMat(loopNum*5 + 2,i) = 0;
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
                    elapsedTime=toc(timeval);
                    respMat(loopNum*5 + 2,i) = 1;
                    resp_main = false;
                elseif keyCode(leftKey)
                    elapsedTime=toc(timeval);
                    resp_main = false;
                    respMat(loopNum*5 + 2,i) = 0;
                elseif keyCode(replayKey)
                    respMat(loopNum*5 + 3,i)= 1 + respMat(loopNum*5 + 3,i);
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
                            if keyIsDown && (keyCode(rightKey) || keyCode(leftKey))
                                elapsedTime=toc(timeval);
                                if keyCode(rightKey)
                                    respMat(loopNum*5 + 2,i) = 1;
                                else
                                    respMat(loopNum*5 + 2,i) = 0;
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
                else
                    text = ['R and Left arrow keys are the only legal options\n\n\n'...
                            'Right arrow for right, and Left arrow for left\n\n\n'...
                            'to replay the video please press R'];
                    DrawFormattedText(window,text,'center', 'center', white);
                    Screen('Flip', window);
                end         
            end
        end
        respMat(loopNum*5 + 4,i) = elapsedTime;
        respMat(loopNum*5 + 5,i) = nan;
    end
end
%fill in video number for data processing
for i=1:numTrials
   respMat(loopNum*5 + 6,i) = i; 
end


text = 'The experiment has ended\n\nThank you for participating\n\n\n\nPlease press any key to exit';
DrawFormattedText(window,text,'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;
sca;


if ~isdir(strcat('Experiment_results\',Name))
    mkdir(strcat('Experiment_results\',Name));
end
file_name = strcat('Experiment_results\',Name,'\',Name,'_',Date,'_','ExpTypy',num2str(ExpIndex));
  
xlswrite(strcat(file_name,'_response.xls'),respMat);

save(strcat(file_name,'.mat'),'*Mat','exp_order');

end