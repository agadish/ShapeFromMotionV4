function sfm_experiment3 (Name, Date, ExpIndex) 
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
stimuli_2022_mean_plane = {'experiment/mean_exp/rectA.png__obj1_14.0_0.7__obj2_8.0_0.7__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_10.0_0.7__obj2_12.0_0.7__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_6.6_0.1__obj2_6.5_0.1__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_6.0_0.7__obj2_3.5_0.7__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_8.0_1.5__obj2_10.0_1.5__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_8.0_0.1__obj2_10.0_0.1__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_7.0_0.7__obj2_7.7_0.7__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_10.0_1.5__obj2_7.5_1.5__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_5.5_1.5__obj2_6.5_1.5__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_7.0_0.1__obj2_7.7_0.1__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_6.6_1.5__obj2_6.5_1.5__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_10.0_1.5__obj2_12.0_1.5__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_8.0_0.7__obj2_10.0_0.7__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_10.0_0.7__obj2_7.5_0.7__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_14.0_1.5__obj2_8.0_1.5__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_6.0_1.5__obj2_3.5_1.5__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_5.5_0.1__obj2_6.5_0.1__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_10.0_0.1__obj2_7.5_0.1__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_14.0_0.1__obj2_8.0_0.1__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_6.0_0.1__obj2_3.5_0.1__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_5.5_0.7__obj2_6.5_0.7__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_10.0_0.1__obj2_12.0_0.1__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_6.6_0.7__obj2_6.5_0.7__70Hz_3sec__bg_250.0_0.1.avi'...
'experiment/mean_exp/rectA.png__obj1_7.0_1.5__obj2_7.7_1.5__70Hz_3sec__bg_250.0_0.1.avi'};

stimuli_2022_sd_plane = {'experiment/sd_exp/rectA.png__obj1_5.0_2.0__obj2_5.0_0.7__70Hz_3sec__bg_250.0_0.1.avi'...
    'experiment/sd_exp/rectA.png__obj1_15.0_1.5__obj2_15.0_0.1__70Hz_3sec__bg_250.0_0.1.avi'...
    'experiment/sd_exp/rectA.png__obj1_15.0_2.5__obj2_15.0_1.0__70Hz_3sec__bg_250.0_0.1.avi'...
    'experiment/sd_exp/rectA.png__obj1_5.0_1.5__obj2_5.0_0.1__70Hz_3sec__bg_250.0_0.1.avi'...
    'experiment/sd_exp/rectA.png__obj1_15.0_1.3__obj2_15.0_0.3__70Hz_3sec__bg_250.0_0.1.avi'...
    'experiment/sd_exp/rectA.png__obj1_10.0_0.1__obj2_10.0_1.0__70Hz_3sec__bg_250.0_0.1.avi'...
    'experiment/sd_exp/rectA.png__obj1_5.0_1.3__obj2_5.0_0.3__70Hz_3sec__bg_250.0_0.1.avi'...
    'experiment/sd_exp/rectA.png__obj1_10.0_2.0__obj2_10.0_0.7__70Hz_3sec__bg_250.0_0.1.avi'...
    'experiment/sd_exp/rectA.png__obj1_10.0_0.3__obj2_10.0_0.9__70Hz_3sec__bg_250.0_0.1.avi'...
    'experiment/sd_exp/rectA.png__obj1_10.0_1.5__obj2_10.0_0.1__70Hz_3sec__bg_250.0_0.1.avi'...
    'experiment/sd_exp/rectA.png__obj1_10.0_2.5__obj2_10.0_1.0__70Hz_3sec__bg_250.0_0.1.avi'...
    'experiment/sd_exp/rectA.png__obj1_5.0_2.5__obj2_5.0_1.0__70Hz_3sec__bg_250.0_0.1.avi'...
    'experiment/sd_exp/rectA.png__obj1_5.0_0.1__obj2_5.0_1.0__70Hz_3sec__bg_250.0_0.1.avi'...
    'experiment/sd_exp/rectA.png__obj1_15.0_0.1__obj2_15.0_1.0__70Hz_3sec__bg_250.0_0.1.avi'...
    'experiment/sd_exp/rectA.png__obj1_15.0_0.3__obj2_15.0_0.9__70Hz_3sec__bg_250.0_0.1.avi'...
    'experiment/sd_exp/rectA.png__obj1_15.0_2.0__obj2_15.0_0.7__70Hz_3sec__bg_250.0_0.1.avi'...
    'experiment/sd_exp/rectA.png__obj1_5.0_0.3__obj2_5.0_0.9__70Hz_3sec__bg_250.0_0.1.avi'...
    'experiment/sd_exp/rectA.png__obj1_10.0_1.3__obj2_10.0_0.3__70Hz_3sec__bg_250.0_0.1.avi'};

switch ExpIndex
    case 1
        stimuli=stimuli_2022_mean_plane;
    case 2
        stimuli=stimuli_2022_sd_plane;
end
% Make the vector which will determine the order of the trial and randomise it
numTrials = size(stimuli ,2);
exp_order = 1:numTrials;


%----------------------------------------------------------------------
%                     Make a response matrix
%----------------------------------------------------------------------

% This is a six row matrix for the users responses:
% row # 1 = Expirement number of repetitions.
% row # 2 = which object covered the other 1 for right 0 for left
% row # 3 = number of replays
% row # 4 = time elapsed till the examinee press his decision.
% row # 5 = the order of the movies of the trial.

maxLoop = 1;
respMat = nan(6*maxLoop+1, numTrials);
%----------------------------------------------------------------------
%                           The Experiment
%----------------------------------------------------------------------

% First run
text = 'Thank you for participating in Assaf & Dvir final project experiment\n\n\n\nPlease press any key to begin';
DrawFormattedText(window,text,'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;
for loopNum = 0:maxLoop-1
    respMat(loopNum*6 + 1,:)=loopNum+1;
    respMat(loopNum*6 + 3,:) = 0;
    respMat(loopNum*6 + 4,:) = 0;
    
    shuffler = Shuffle(1:numTrials);
    exp_order = exp_order(shuffler);
    respMat(loopNum*6 + 5,:) = 0;
    % Animation loop: we loop for the total number of trials
    for trial = 1:numTrials
        % Play stimulus
        if trial == 1 && loopNum == 0
            text = ['You will be shown a number of stimuli\n\n\n'...
                    'Please observe them carefully\n\n'...
                    'Determine which object covers the other\n\n\n'...
                    'Please press any key to continue'];
        else
            text = ['Next Stimulus'...
                    '\n\n\n\nPlease press any key to continue'];
        end
        DrawFormattedText(window,text,'center', 'center', white);
        Screen('Flip', window);
        KbStrokeWait;

        i = exp_order(trial);  
        path = strcat(pwd, '/',stimuli{i});
        %respMat(loopNum*6 + 5,:) = stimuli{i};

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
                    respMat(loopNum*6 + 2,i) = 1;
                else
                    respMat(loopNum*6 + 2,i) = 0;
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
        text = ['Which object covered the other?\n\n\n'...
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
                    respMat(loopNum*6 + 2,i) = 1;
                    resp_main = false;
                elseif keyCode(leftKey)
                    elapsedTime=toc(timeval);
                    resp_main = false;
                    respMat(loopNum*6 + 2,i) = 0;
                elseif keyCode(replayKey)
                    respMat(loopNum*6 + 3,i)= 1 + respMat(loopNum*6 + 3,i);
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
                                    respMat(loopNum*6 + 2,i) = 1;
                                else
                                    respMat(loopNum*6 + 2,i) = 0;
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
                        text = ['Which of object covered the other?\n\n\n'...
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
        respMat(loopNum*6 + 4,i) = elapsedTime;
        respMat(loopNum*6 + 6,i) = trial;
    end
end


text = 'The experiment has ended\n\nThank you for participating\n\n\n\nPlease press any key to exit';
DrawFormattedText(window,text,'center', 'center', white);
file_name = 'experiment.xls';
fprintf('saving experiment.xls');


%xlswrite(strcat(file_name,'_response.xls'),respMat);
%xlwrite(strcat(file_name,'_response.xls'),respMat);
writematrix(respMat, file_name);

Screen('Flip', window);
KbStrokeWait;
sca;


if ~isfolder('Experiment_results_2022')
    mkdir('Experiment_results_2022');
end
file_name = sprintf('Experiment_results_2022/%s_%s_ExpType%d.xls' ,Name, Date, ExpIndex);
% xlswrite(strcat(file_name,'_response.xls'),respMat);
%xlwrite(strcat(file_name,'_response.xls'),respMat);
writematrix(respMat, file_name);

save(strcat(file_name,'.mat'),'*Mat','exp_order');

end
