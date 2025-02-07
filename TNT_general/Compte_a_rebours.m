function Compte_a_rebours(temps, passer)
% paramètres : temps = temps en secondes de la durée du compte à rebours
% passer : si = 1, le sujet peut passer le compte à rebours en appuyant sur
% echap, si = 0, le sujet ne peut pas passeer le compte à rebours
sca
Screen('CloseAll');
Screen('Preference','SkipSyncTests', 0);

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Skip sync tests for demo purposes only
Screen('Preference', 'SkipSyncTests', 2);

% Get the screen numbers
screens = Screen('Screens');

% Select the external screen if it is present, else revert to the native
% screen
screenNumber = max(screens);

% Define black
white = WhiteIndex(screenNumber);
grey = white / 2;
black = BlackIndex(screenNumber);

% Opens the experiment window, colors it grey
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);

% Sets the window's priority level to the maximum value
topPriority = MaxPriority(window);

% Sets the text size
TaskTextSize = 30;          % Taille de police pour la tâche
Screen('TextSize', window, TaskTextSize);

% Establishes keys to be used in the program
KbName('UnifyKeyNames');
escapeKey = KbName('ESCAPE');
spaceKey = KbName('SPACE');

 
% Get the nominal framerate of the monitor. For this simple timer we are
% going to change the counterdown number every second. This means we
% present each number for "frameRate" amount of frames. This is because
% "framerate" amount of frames is equal to one second. Note: this is only
% for a very simple timer to demonstarte the principle. You can make more
% accurate sub-second timers based on this.
nominalFrameRate = Screen('NominalFrameRate', window);

% Our timer is going to start at 10 and count down to 0. Here we make a
% list of the number we are going to present on each frame. This way of
% doing things is just for you to see what is going on more easily. You
% could eliminate this step completely by simply keeping track of the time
% and updating the clock appropriately, or by clever use of the Screen Flip command
% However, for this simple demo, this should work fine
presSecs = [sort(repmat(1:temps, 1, nominalFrameRate), 'descend') 0];


% Here is our drawing loop
for i = 1:length(presSecs)

    % Convert our current number to display into a string
    numberString = num2str(presSecs(i));
    if passer
        % Draw our number to the screen
        DrawFormattedText(window,['Pause de 1 min 30 s\n\nSi vous ne voulez pas faire de pause, appuyez sur la touche ''Echap''\n\n\n' numberString], 'center', 'center', white);
    else
        % Draw our number to the screen
        DrawFormattedText(window,['Temps d''adaptation au son de ' num2str(temps) ' secondes\n\n\n' numberString], 'center', 'center', white);
    end
    
    % Flip to the screen
    Screen('Flip', window);
    
    if passer 
        %DrawFormattedText(window, 'Appuyer sur Echap pour passer', 'center', 'right', white);
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown 
            if keyCode(escapeKey)
                break;
            end
        end
    end

end

% Fin du compte à rebours
% Screen('TextSize', window, 50);
% DrawFormattedText(window, 'Appuyer sur un touche lorsque vous êtes pret à continuer', 'center', 'center', white);
% Screen('Flip', window);
% [ keyIsDown, seconds, keyCode ] = KbCheck;
% if keyIsDown
%     if keyCode(escapeKey)
%         close all;
%         sca
%     end
% end

% Clear the screen
close all;
sca
end