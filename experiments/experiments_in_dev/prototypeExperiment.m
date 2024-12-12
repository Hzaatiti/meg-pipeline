Screen('Preference', 'SkipSyncTests', 1);

% Clear the workspace and the screen
sca;
close all;
clearvars;


% This script is under development new comment 2

try
    % Setup Psychtoolbox
    PsychDefaultSetup(2);
    
    % Get the screen number
    screenNumber = max(Screen('Screens'));
    
    % Define black color
    blackColor = BlackIndex(screenNumber);
    % Define red color
    redColor = [1 0 0];
    
    % Open the window
    [windowPtr, windowRect] = PsychImaging('OpenWindow', screenNumber, blackColor);
    
    % Get the center coordinates of the screen
    [screenX, screenY] = RectCenter(windowRect);
    
    % Define the rectangle size
    rectWidth = 600;
    rectHeight = 400;
    
    % Define the rectangle coordinates
    rectLeft = screenX - rectWidth / 2;
    rectTop = screenY - rectHeight / 2;
    rectRight = screenX + rectWidth / 2;
    rectBottom = screenY + rectHeight / 2;
    rectCoords = [rectLeft, rectTop, rectRight, rectBottom];
    
    % Draw the red rectangle
    Screen('FillRect', windowPtr, redColor, rectCoords);
    
    % Flip to the screen
    Screen('Flip', windowPtr);
    
    % Wait for a key press to exit
    KbStrokeWait;
    
    % Clear the screen
    sca;
    
catch
    % If there is an error in the try block, close Psychtoolbox and show the error
    sca;
    psychrethrow(psychlasterror);
end
