function TNT_entrainement_2diff()
% Summary : fonction pour entrainement à la Toulouse-n-back-task : 0-back et 2-back

% Clears the workspace, screen, variables, and command prompt
Screen('CloseAll');
Screen('Preference','SkipSyncTests', 0);
CedrusResponseBox('CloseAll'); % remet à 0 tous les ports cedrus
myBox = CedrusResponseBox('Open', 'COM22');

% Informations d'affichage
% Initiates Psychtoolbox boilerplate operations
PsychDefaultSetup(2)
% HideCursor; % permet de cacher la souris

% Timing Info
isiTimeSecs = 1;            % Temps inter-stimulus en seconde
StimulusDuration = 2 ;      % Temps de présentation du stimulus en seconde
numStimsAct = 10 ;          % Nombre de stimuli présenté par bloc (max 12)
numStimsRest = 5 ;          % Nombre de stimuli de repos '00+00'
InstructionTextSize = 35;   % Taille de la police pour les consignes
InstructionTextSize2 = 25;
TaskTextSize = 65;          % Taille de police pour la tâche
InstructionDisplayTime = 5; % Temps d'affichage des consignes avec compte à rebours
wrapat = 75 ;               % Nombre de caractère avant un retour à la ligne
vSpacing = 2 ;              % Interligne

% Select the external screen if it is present, else revert to the native screen
screens = Screen('Screens');
screenNumber = max(screens);
% screenNumber = 2; % 0 pour mono-poste, 1 pour double poste, 2 pour triple poste : 2 affichage sur écran de gauche

% Defines black, white, and grey
white = WhiteIndex(screenNumber);
grey = white / 2;
black = BlackIndex(screenNumber);
couleur_police = white;

% Opens the experiment window, colors it grey
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);

% Sets the window's priority level to the maximum value
topPriority = MaxPriority(window);

% Sets the text size
Screen('TextSize', window, TaskTextSize);

% Measures the screen's vertical refresh rate (ifi = 1 / hertz)
ifi = Screen('GetFlipInterval', window);

isiTimeFrames = round(isiTimeSecs / ifi);

% Number of frames to wait before re-drawing
waitframes = 1;

% Establishes keys to be used in the program
KbName('UnifyKeyNames');
escapeKey = KbName('ESCAPE');
spaceKey = KbName('SPACE');

%Charge les listes de stimuli
load('ListeStim_Subject');      % Liste des stimuli n-back  
recommencer = 1;
while recommencer == 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%     Practice trial     %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Backs = [0 2];
    
    %Compteurs des n-back
    num_back = [0 1 2 3 4 5 6 7 8 9 10 11]; % il y a 12 opérations par conditions
    num_back = Shuffle(num_back);
    cpteZero = num_back(1);
    cpteTwo= num_back(1);
    
    
    Conditions = mat2cell(zeros(1,2*length(Backs)), 1, ones(1,2*length(Backs)));
    for k=1:length(Backs)
        switch Backs(k)
            case 0
                cpteZero = cpteZero + 1;
                Conditions(k*2-1) = {['Zeroback' num2str(cpteZero)]};
                Conditions(k*2) = {'Rest'};
            case 2
                cpteTwo = cpteTwo + 1;
                Conditions(k*2-1) = {['Twoback' num2str(cpteTwo)]};
                Conditions(k*2) = {'Rest'};
        end
    end
    
    
    
    %Affichage des instructions
    Screen('TextSize', window, InstructionTextSize2);
    
    DrawFormattedText(window,['Entraînement à la Toulouse N-back Task\n\nCette tâche va vous permettre de vous entraîner à la Toulouse N-back Task. ' ...
        'Vous avez pour objectif de calculer, mémoriser et comparer les résultats d''opérations arithmétiques avec les items précédents. ' ...
        'Les opérations consistent en des additions ou des soustractions de multiples de 5 compris entre 10 et 95 (par exemple : 15 + 40 ou 90 - 35).' ...
        '\n\n\nAppuyez sur une touche du boîter gris pour continuer.'], 'centerblock', 'center', couleur_police, wrapat, [], [], vSpacing);
    Screen('Flip', window);
    CedrusResponseBox('WaitButtonPress', myBox);
    DrawFormattedText(window, ['Il existe deux niveaux de difficulté pour cette tâche :\n\n-   0-back : vous devez comparer le résultat ' ...
        'de l''opération au chiffre 50. Si le résultat est égal à 50 appuyez sur le bouton vert. Si le résultat n''est pas égal à 50, ' ...
        'appuyez sur le bouton rouge.\n\n-   2-back : vous devez comparez le résultat de l''opération à celui calculé 2 items avant. ' ...
        'S''ils sont égaux, appuyez sur le bouton vert, sinon appuyez sur le bouton rouge.\n\nUne condition supplémentaire a été ajoutée ' ...
        'à la fin de chaque niveau, lorsque vous verrez l''opération '' 00 + 00 '' appuyez simplement sur le bouton vert.\n\nAppuyez sur une ' ...
        'touche pour continuer.'], 'centerblock', 'center', couleur_police,  wrapat, [], [], vSpacing);
    Screen('Flip', window);
    CedrusResponseBox('WaitButtonPress', myBox);
    
    
    DrawFormattedText(window, ['Votre temps de réponse est limité : vous pouvez répondre seulement durant le temps de présentation de l''opération ' ...
        'qui est de 2 secondes.\n\n Si vous avez bien compris les consignes et n''avez pas de questions, appuyez sur une touche pour commencer '...
        'la tâche.'], 'centerblock', 'center', couleur_police, wrapat, [], [], vSpacing);
    Screen('Flip', window);
    CedrusResponseBox('WaitButtonPress', myBox);
    
    for bloc = 1:size(Conditions,2)
        
        % Créer une matrice de réponse de 8 lignes et 12 colonnes (numStimsAct)
        condition=cell2mat(Conditions(bloc));
        
        if strcmp(condition, 'Rest')
            numStims = numStimsRest;
        else
            numStims = numStimsAct;
            respMatrix.(condition) = NaN(8, numStims);    %créer une matrice de taille 8*9 (numStims) rempli de NaN
            numList=eval(condition);                      %liste de stim correspondant à la premiere condition
            %Création des variables résumé
            targets = 0;
            corrects = 0;
            true_pos = 0;
            true_neg = 0;
            false_pos = 0;
            false_neg = 0;
            totalRT_correct = 0;
            totalRT_incorrect = 0;
            miss = 0;
        end
        
        TextReminder = '';
        
        if strcmp(condition,'Rest')
            TextReminder = '#-BACK';
        elseif strcmp(condition(1:3),'Two')
            trialWithoutResponse = 2;
            TextReminder = '2-BACK';
        elseif strcmp(condition(1:3),'Zer')
            trialWithoutResponse = 0;
            TextReminder = '0-BACK';
        end
        
        
        
        %waitTime = StimulusDuration;
        
        %% Once per run
        
        time = 0;
        time0 = GetSecs;
        %pause(1);
        
        
        % Initialisation de l'expérience
        for trial = 1:numStims
            %disp(trial);
            
            %Displays instructions before the first trial begins
            if trial == 1
                Screen('TextSize', window, InstructionTextSize2);
                if strcmp(condition(1:3),'Zer')== true
                    DrawFormattedText(window, 'Entrainement au calcul 0-back \n\nAppuyez sur le bouton vert lorsque le résultat du calcul est égal à 50. Sinon appuyez sur le bouton rouge.\n\nAppuyez sur un bouton pour commencer', 'centerblock', 'center', couleur_police,  wrapat, [], [], vSpacing);
                    Screen('Flip', window);
                    CedrusResponseBox('WaitButtonPress', myBox);
                elseif strcmp(condition(1:3),'Two')== true
                    DrawFormattedText(window, 'Entrainement au calcul 2-back \n\nAppuyez sur le bouton vert lorsque le résultat du calcul est égal à celui obtenu 2 essais avant. Sinon appuyez sur le bouton rouge.\n\nAppuyez sur un bouton pour commencer', 'centerblock', 'center', couleur_police,  wrapat, [], [], vSpacing);
                    Screen('Flip', window);
                    CedrusResponseBox('WaitButtonPress', myBox);
                end
                Screen('TextSize', window, TaskTextSize);
            end
            
            if strcmp(condition,'Rest')
                displayedNum = '00+00';
            else
                displayedNum = numList(trial,2);
            end
            
            
            if trial == 1
                
                Screen('Flip', window);
                
                if ~strcmp(condition,'Rest')
                    for t=InstructionDisplayTime:-1:0 % Compte-à-rebours avant début du Run
                        %Screen('TextSize', window, TaskTextSize);
                        
                        Screen('TextSize', window, InstructionTextSize);
                        if strcmp(condition(1:3),'Zer') %compte à rebours avant le début du bloc
                            DrawFormattedText(window, ['0-BACK\n\n commence dans ' num2str(t) ' sec'], 'center', 'center', couleur_police);
                            
                        elseif strcmp(condition(1:3),'Two') %compte à rebours avant le début du bloc
                            DrawFormattedText(window, ['2-BACK\n\n commence dans ' num2str(t) ' sec'], 'center', 'center', couleur_police);
                        end
                        
                        Screen('Flip', window);
                        pause(1);
                    end
                    
                    Screen('TextSize', window, TaskTextSize);
                end
                
                
                Screen('Flip', window);
            end
            
            vbl = Screen('Flip', window);
            t0 = GetSecs;  % récupère le temps à la présentation du stimulus
            while GetSecs-t0 < isiTimeSecs
                time = (GetSecs - time0);
                Screen('Flip', window);
            end
            
            
            % Starts reaction timer
            t0 = GetSecs;
            response = 0;
            frame = 0;
            
            while GetSecs-t0 < StimulusDuration
                frame = frame + 1;
                
                % Displays the number
                %         if strcmp (condition(4:end),'Digi')== true
                %         DrawFormattedText(window, num2str(displayedNum), 'center', 'center');
                %         else
                DrawFormattedText(window, char(displayedNum), 'center', 'center');
                %         end
                Screen('Flip', window);
                %recupere l'index du bouton enfonce sur le boitier Cedrus
                evt = CedrusResponseBox('GetButtons', myBox);
                if ~isempty(evt) && response == 0 && (GetSecs - t0 > 0.3) % block 300 ms that is not possible psychophysiology
                    if evt.button == 2 %if first button pressed = 1  Correspond a  bouton de Gauche
                        response = 1;
                    elseif evt.button == 8 % Correspond a  bouton de Droite
                        response = 2;
                    end
                    %Stops timer, calculates response time
                    reactionTime = GetSecs - t0;
                end
                
                %clear response box events
                buttons = CedrusResponseBox('FlushEvents', myBox);
                time = time + ifi;
            end
            
            if trial == numStims
                vbl = Screen('Flip', window);
                t0 = GetSecs;
                while GetSecs-t0 < isiTimeSecs
                    time = (GetSecs - time0);
                    Screen('Flip', window);
                end
            end
            
            % if subject did not answer
            if response == 0
                reactionTime = NaN;
            end
            
            % Records each trial's data in the response matrix
            if ~strcmp(condition,'Rest')
                respMatrix.(condition)(1, trial) = str2num(cell2mat(displayedNum));
            end
            
            
            %%% 2-back CALCULATION
            if strcmp(condition (1:3),'Two')
                if trial > 2
                    respMatrix.(condition)(2, trial) = cell2mat(numList(trial-2,1)); %recense le nombre presenté en 2-back
                    
                    % absense de reponse
                    if response == 0
                        miss = miss + 1;
                    end
                    
                    % cas ou c'est un MATCH
                    if str2num(cell2mat(displayedNum)) == cell2mat(numList(trial-2,1))
                        targets = targets + 1;                                  %compte les target
                        respMatrix.(condition)(3, trial) = 1;                   %recence dans la matrice resultats les matchs
                        
                        if response == 1
                            respMatrix.(condition)(4, trial) = 0;
                            false_neg = false_neg + 1;
                            respMatrix.(condition)(7, trial) = 1;               %colonne false positive
                            respMatrix.(condition)(8, trial) = reactionTime;    %note le TR
                            totalRT_incorrect = totalRT_incorrect + reactionTime; %en vue de calculer le TR moyen
                        elseif response == 2 % bonne reponse
                            corrects = corrects + 1;                            %compte les bonnes reponses du sujet
                            true_pos = true_pos + 1;
                            respMatrix.(condition)(4, trial) = 1;               %note bonne rep dans mat de resultats
                            respMatrix.(condition)(6, trial) = reactionTime;    %note le TR
                            totalRT_correct = totalRT_correct + reactionTime;   %en vue de calculer le TR moyen
                        end
                    else
                        % cas ou ce n'est PAS MATCH
                        respMatrix.(condition)(3, trial) = 0; %
                        if response == 1 % bonne reponse
                            corrects = corrects + 1;                            %compte les bonnes reponses du sujet
                            true_neg = true_neg + 1;
                            respMatrix.(condition)(4, trial) = 1;               %note bonne rep dans mat de resultats
                            respMatrix.(condition)(6, trial) = reactionTime;    %note le TR
                            totalRT_correct = totalRT_correct + reactionTime;   %en vue de calculer le TR moyen
                        elseif response == 2 % mauvaise reponse et faux positif
                            false_pos = false_pos + 1;
                            respMatrix.(condition)(4, trial) = 0;
                            respMatrix.(condition)(5, trial) = 1;               %colonne false positive
                            respMatrix.(condition)(8, trial) = reactionTime;    %note le TR
                            totalRT_incorrect = totalRT_incorrect + reactionTime; %en vue de calculer le TR moyen
                        end
                    end
                end
            end
            
            
            %%% 0-back CALCULATION
            if strcmp(condition (1:3),'Zer')
                respMatrix.(condition)(2, trial) = cell2mat(numList(trial,1)); %recense le nombre presente en 0-back
                
                if response == 0
                    miss = miss + 1; % absense de reponse
                end
                
                % cas ou c'est un MATCH
                if str2num(cell2mat(displayedNum)) == 50
                    %                str2num(cell2mat(displayedNum)) == str2num(condition(9)) % detection de chiffre selon condition
                    targets = targets + 1; %compte les target
                    respMatrix.(condition)(3, trial) = 1; %recence dans la matrice resultats les matchs
                    
                    if response == 1    % mauvaise réponse
                        respMatrix.(condition)(4, trial) = 0;
                        false_neg = false_neg + 1;
                        respMatrix.(condition)(7, trial) = 1;                   %colonne false positive
                        respMatrix.(condition)(8, trial) = reactionTime;        %note le TR
                        totalRT_incorrect = totalRT_incorrect + reactionTime;   %en vue de calculer le TR moyen
                    elseif response == 2 % bonne reponse
                        corrects = corrects + 1;                                %compte les bonnes reponses du sujet
                        true_pos = true_pos + 1;
                        respMatrix.(condition)(4, trial) = 1;                   %note bonne rep dans mat de resultats
                        respMatrix.(condition)(6, trial) = reactionTime;        %note le TR
                        totalRT_correct = totalRT_correct + reactionTime;       %en vue de calculer le TR moyen
                    end
                    
                else
                    respMatrix.(condition)(3, trial) = 0; %
                    % cas ou ce n'est PAS MATCH
                    if response == 1 % bonne reponse
                        corrects = corrects + 1;                                %compte les bonnes reponses du sujet
                        true_neg = true_neg + 1;
                        respMatrix.(condition)(4, trial) = 1;                   %note bonne rep dans mat de resultats
                        respMatrix.(condition)(6, trial) = reactionTime;        %note le TR
                        totalRT_correct = totalRT_correct + reactionTime;       %en vue de calculer le TR moyen
                    elseif response == 2                                        % mauvaise reponse et faux positif
                        false_pos = false_pos + 1;
                        respMatrix.(condition)(4, trial) = 0;
                        respMatrix.(condition)(5, trial) = 1;                   %colonne false positive
                        respMatrix.(condition)(8, trial) = reactionTime;        %note le TR
                        totalRT_incorrect = totalRT_incorrect + reactionTime;   %en vue de calculer le TR moyen
                    end
                end
            end
        end
        
        
        
        
        % Formats and displays experiment results for user
        if strcmp(condition(1:3),'Two')== true
            back='Two Numbers ago';
        elseif strcmp(condition(1:3),'Zer')
            back='Presented Number';
        end
        
        
        if ~strcmp(condition,'Rest')
            outputHeader = { 'Number', back, 'Match', 'Correctly Identified', 'False_pos', 'Reaction Time correct', 'False_neg', 'Reaction Time incorrect'};
            %output = dataset({respMatrix.(condition)',outputHeader{:}});
            disp(['Vous avez fait ', num2str(corrects), ' réponses correctes sur ', num2str(numStims-trialWithoutResponse) ' et fait ', num2str(false_pos), ' fausses identifications.'])
            disp(['La moyenne de votre temps de réaction est ', num2str(totalRT_correct/corrects), ' secondes.'])
            
        end
        Screen('TextSize', window, TaskTextSize);
    end

    WaitSecs(2);
    Screen('TextSize', window, InstructionTextSize2);
    DrawFormattedText(window, 'Voulez-vous recommencer l''entrainement ?\n\n Appuyez sur la touche verte si oui sinon appuyez sur la touche rouge.', 'centerblock', 'center', couleur_police, wrapat, [], [], vSpacing);
    
    Screen('Flip', window);
    WaitSecs(2);
    % recupere l'index du bouton enfonce sur le boitier Cedrus
    evt = CedrusResponseBox('WaitButtons', myBox);
    disp(['Reponse Cedrus : ' evt.button])
    
    if evt.button == 2 %if first button pressed = 1  Correspond a  bouton de Gauche
        recommencer = 0;
    elseif evt.button == 8 % Correspond a  bouton de Droite
        recommencer = 1;
    end
    disp(['recommencer = ' num2str(recommencer)]);
    
    % clear response box events
    WaitSecs(0.5);
    evt = CedrusResponseBox('FlushEvents', myBox);
 
    
end
% 
% Screen('TextSize', window, InstructionTextSize2);
% DrawFormattedText(window,['Vous n''aurez pas vos résultats lors de la véritable expérience.\nVous avez fait ' num2str(corrects) ...
%     ' réponses correctes sur ' num2str(numStims-trialWithoutResponse) ' et fait ' num2str(false_pos) ' fausses identifications.' ...
%     '\nLa moyenne de votre temps de réaction est ' num2str(totalRT_correct/corrects) ' secondes.\n\nAppuyez sur un bouton pour continuer'],...
%     'center', 'center', couleur_police, wrapat, [], [], vSpacing);
% Screen('Flip', window);
% CedrusResponseBox('WaitButtonPress', myBox);


% Debriefs user and prompts user to close the experiment window
Screen('TextSize', window, InstructionTextSize);
DrawFormattedText(window, 'Tâche terminée !', 'center', 'center', couleur_police);
Screen('Flip', window);
WaitSecs(1);

sca;
end
