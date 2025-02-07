function [Matrice_resultat ] = TNT_3_difficulties_hdt_KEYBOARD(Sujet)
% Summary : fonction Toulouse-N-back-Task : 0-back, 1-back et 2-back.
% Paramètre : Sujet = numéro du sujet; Sorties : Res= Structure résultat,
% Matrice_resultat = matrice de résulat avec (condition, nombre de
% sitmulus, nombre de réponses correctes, nombre de réponses incorrectes,
% sans réponse, vrais positifs, vrais négatifs, faux positifs, faux
% négatifs, temps de réaction moyen pour les réponses correctes)
set(0,'PointerLocation', [0 0])



% Clears the workspace, screen, variables, and command prompt
Screen('CloseAll');
Screen('Preference','SkipSyncTests', 1);
Screen('Preference', 'VisualDebugLevel', 0);
% Establishes keys to be used in the program
KbName('UnifyKeyNames');
%CedrusResponseBox('CloseAll'); % remet à 0 tous les ports cedrus
%myBox = CedrusResponseBox('Open', 'COM3');

%créer la variable "letter" utilisée pour vérifier le bouton (vert ou
%rouge) pour répondre lors de la réalisation de la TNT
letter = ''; 

% 
% while true
%     % Check for key press
%     [keyIsPressed, ~, keyCode] = KbCheck;
%     
%     if keyIsPressed
%         % Check if the Esc key is pressed
%         if keyCode(KbName('Escape'))
%             fprintf('Esc key pressed! Exiting...\n');
%             break; % Break the loop if Esc key is pressed
%         else


% Informations d'affichage
% Initiates Psychtoolbox boilerplate operations
PsychDefaultSetup(2)
% HideCursor; % permet de cacher la souris

% Timing Info
isiTimeSecs = 1;            % Temps inter-stimulus en seconde
StimulusDuration = 2;      % Temps de présentation du stimulus en seconde
numStimsAct = 12;          % Nombre de stimuli présenté par sujet (max 12)
numStimsRest = 6;          % Nombre de stimuli de repos '00+00' (max 6)
InstructionTextSize = 35;   % Taille de la police pour les consignes
InstructionTextSize2 = 25;   % Taille de la police pour les consignes
TaskTextSize = 100;          % Taille de police pour la tâche
InstructionDisplayTime = 5; % Temps d'affichage des consignes avec compte à rebours
wrapat = 75 ;               % Nombre de caractère avant un retour à la ligne
vSpacing = 2 ;              % Interligne

% Select the external screen if it is present, else revert to the native screen
screens = Screen('Screens');
screenNumber = max(screens);
%screenNumber = 2; % 0 pour mono-poste, 1 pour double poste, 2 pour triple poste : 2 affichage sur écran de gauche

% Defines black, white, and grey
white = WhiteIndex(screenNumber);
grey = white / 2;
black = BlackIndex(screenNumber);
couleur_police = white;

% Opens the experiment window, colors it grey
%[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);
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

% % Establishes keys to be used in the program
% KbName('UnifyKeyNames');
% escapeKey = KbName('ESCAPE');
% spaceKey = KbName('SPACE');
% 
% % Wait for a key press to exit
% 
% 
%             % Handle other key presses as needed
%             % ...
%         end
%     end
% end
% 
% % Close the screen
% sca;



%Charge les listes de stimuli
load('ListeStim_Subject');      % Liste des stimuli n-back

% Expérience principale
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%    Main Experiment    %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Matrice_resultat = [];
% Shuffle des 3 difficultés
Backs = [0 1 2];

%C1=1;
% step=0;
%while C1
%    Backs = Shuffle(Backs);
%    C1= ~isempty(find(Backs(1:end-1)==Backs(2:end)));
%    %     step=step+1;
%end
% disp(['Nb step = ' num2str(step)])
%%

%Compteurs des n-back
num_back = [0 1 2 3 4 5 6 7 8 9]; % il y a 12 opérations par conditions mais je met de 0 à 9 parce qu'on va incrémenter le compteur de +3 donc = 12
num_back = Shuffle(num_back);
cpteZero = num_back(1);
cpteOne = num_back(1);
cpteTwo= num_back(1);


% créer une matrice de 0 et 1 de la taille 2* nombre de sons aversives ????
Conditions = mat2cell(zeros(1,2*length(Backs)), 1, ones(1,2*length(Backs)));
for k=1:length(Backs)  
    switch Backs(k)
        case 0
            cpteZero = cpteZero + 1;
            Conditions(k*2-1) = {['Zeroback' num2str(cpteZero)]};
            Conditions(k*2) = {'Rest'};
        case 1
            cpteOne = cpteOne + 1;
            Conditions(k*2-1) = {['Oneback' num2str(cpteOne)]};
            Conditions(k*2) = {'Rest'};
        case 2
            cpteTwo = cpteTwo + 1;
            Conditions(k*2-1) = {['Twoback' num2str(cpteTwo)]};
            Conditions(k*2) = {'Rest'};
    end
end

% Affichage des instructions (Appuyez sur un bouton) avant le début de l'essai
Screen('TextSize', window, InstructionTextSize2);
DrawFormattedText(window, ['Toulouse N-back Task - Instructions : \n\n'...
    'Vous avez pour objectif de calculer, mémoriser et comparer les résultats des opérations arithmétiques. \n\nRappel : \n'...
    '   - 0-back : comparez le résultat à 50. \n'...
    '   - 1-back : comparez le résultat au résultat précédent. Pas de réponse attendue pour le premier calcul affiché. \n'...
    '   - 2-back : comparez le résultat au résultat calculé 2 items avant. Pas de réponse attendue pour les deux premiers calculs. \n'...
    'Vous allez utiliser la touche verte pour "VRAI" et la touche rouge pour "FAUX".\n'...
    '\n\nAppuyez sur le bouton vert lorsque vous êtes prêt à commencer'], 'centerblock', 'center', couleur_police, wrapat, [], [], vSpacing);
Screen('Flip', window);
%CedrusResponseBox('WaitButtonPress', myBox);
waitfor(KbName == 'k');

for bloc = 1:size(Conditions,2)
    
    
    % Créer une matrice de réponse de 8 lignes et 12 colonnes (numStimsAct)
    condition=cell2mat(Conditions(bloc));
    
    if strcmp(condition, 'Rest')
        numStims = numStimsRest;
    else
        disp(['Difficulté : ' condition])
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
    elseif strcmp(condition(1:3),'One')
        trialWithoutResponse = 1;
        TextReminder = '1-BACK';
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
        if strcmp(condition,'Rest')
            displayedNum = '00+00';
        else
            displayedNum = numList(trial,2);
        end
        
        if trial == 1
            
            Screen('Flip', window);
            
            if ~strcmp(condition,'Rest')
                for t=InstructionDisplayTime:-1:0 % Compte-à-rebours avant début du Run
                    %                     Screen('TextSize', window, TaskTextSize);
                    
                    Screen('TextSize', window, InstructionTextSize);
                    if strcmp(condition(1:3),'Zer') %compte à rebours avant le début du bloc
                        DrawFormattedText(window, ['0-BACK\n\n commence dans ' num2str(t) ' sec'], 'center', 'center', couleur_police);
                    elseif strcmp(condition(1:3),'One') %compte à rebours av
                        DrawFormattedText(window, ['1-BACK\n\n commence dans ' num2str(t) ' sec'], 'center', 'center', couleur_police);
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
        
        % Triggers
        if strcmp(condition (1:3),'Two')==true
            trigger_number = 2;
        elseif strcmp(condition (1:3),'One')==true
            trigger_number = 1;
        elseif strcmp(condition (1:3),'Zer')==true
            trigger_number = 0;
        elseif strcmp(condition(1:3),'Res')== true
            trigger_number = 7;
        end
        
        %%%Ecriture sur le USBtoparallel
        %         trigger = strcat(num2str(trigger_number) , num2str(condition_son)); %trigger(1,2,7) + condition_son(0,1,2,3,4,5)
        %         fwrite (arduino,str2num(trigger),'uint8'); % Write the number of the trigger int value on arduino port with a 8 bit format.
        
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
            %check key pressed
            if ~isempty(letter) && response == 0 && (GetSecs - t0 > 0.3) % block 300 ms that is not possible psychophysiology
                letter = KbName();
                if letter == 'f' %if first button pressed = 1  Correspond a  bouton de Gauche (RED BUTTON)
                    response = 1;
                elseif letter == 'k' % Correspond a  bouton de Droite (GREEN BUTTON)
                    response = 2;
                end
                %Stops timer, calculates response time
                reactionTime = GetSecs - t0;
            end
            
%             %recupere l'index du bouton enfonce sur le boitier Cedrus
%             evt = CedrusResponseBox('GetButtons', myBox);
%             if ~isempty(evt) && response == 0 && (GetSecs - t0 > 0.3) % block 300 ms that is not possible psychophysiology
%                 if evt.button == 2 %if first button pressed = 1  Correspond a  bouton de Gauche
%                     response = 1;
%                 elseif evt.button == 8 % Correspond a  bouton de Droite
%                     response = 2;
%                 end
%                 %Stops timer, calculates response time
%                 reactionTime = GetSecs - t0;
%             end
            
            %clear response box events
            %buttons = CedrusResponseBox('FlushEvents', myBox);
            letter = 'o';
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
        
        %%% 1-back CALCULATION
        if strcmp(condition (1:3),'One')
            if trial > 1
                respMatrix.(condition)(2, trial) = cell2mat(numList(trial-1,1)); %recense le nombre presente en 1-back
                
                % absense de reponse
                if response == 0
                    disp('absense de réponse')
                    miss = miss + 1;
                end
                
                % cas ou il y a MATCH
                if str2num(cell2mat(displayedNum)) == cell2mat(numList(trial-1,1))
                    targets = targets + 1; %compte les target
                    respMatrix.(condition)(3, trial) = 1; %recence dans la matrice resultats les matchs
                    
                    %au cas ou c'est un MATCH
                    if response == 1 % mauvaise reponse
                        disp('mauvaise réponse : faux négatif')
                        false_neg = false_neg + 1;
                        respMatrix.(condition)(4, trial) = 0;
                        respMatrix.(condition)(7, trial) = 1; %colonne false positive
                        respMatrix.(condition)(8, trial) = reactionTime; %note le TR
                        
                        totalRT_incorrect = totalRT_incorrect + reactionTime; %en vue de calculer le TR moyen
                    elseif response == 2 % bonne reponse
                        disp('bonne réponse : vrai positif')
                        corrects = corrects + 1; %compte les bonnes reponses du sujet
                        true_pos = true_pos + 1;
                        respMatrix.(condition)(4, trial) = 1; %note bonne rep dans mat de resultats
                        respMatrix.(condition)(6, trial) = reactionTime; %note le TR
                        totalRT_correct = totalRT_correct + reactionTime; %en vue de calculer le TR moyen
                    end
                    
                    % cas ou ce n'est PAS MATCH
                else
                    respMatrix.(condition)(3, trial) = 0; %
                    if response == 1 % bonne reponse
                        disp('bonne réponse : vrai négatif')
                        corrects = corrects + 1; %compte les bonnes reponses du sujet
                        true_neg = true_neg + 1;
                        respMatrix.(condition)(4, trial) = 1; %note bonne rep dans mat de resultats
                        respMatrix.(condition)(6, trial) = reactionTime; %note le TR
                        totalRT_correct = totalRT_correct + reactionTime; %en vue de calculer le TR moyen
                    elseif response == 2 % mauvaise reponse et faux positif
                        disp('mauvaise réponse : faux positif')
                        false_pos = false_pos + 1;
                        respMatrix.(condition)(4, trial) = 0;
                        respMatrix.(condition)(5, trial) = 1;%colonne false positive
                        respMatrix.(condition)(8, trial) = reactionTime;%note le TR
                        totalRT_incorrect = totalRT_incorrect + reactionTime; %en vue de calculer le TR moyen
                    end
                end
            end
        end
        
        %%% 2-back CALCULATION
        if strcmp(condition (1:3),'Two')
            if trial > 2
                respMatrix.(condition)(2, trial) = cell2mat(numList(trial-2,1)); %recense le nombre presenté en 2-back
                
                % absense de reponse
                if response == 0
                    disp('absence de réponse')
                    miss = miss + 1;
                end
                
                % cas ou c'est un MATCH
                if str2num(cell2mat(displayedNum)) == cell2mat(numList(trial-2,1))
                    targets = targets + 1;                                  %compte les target
                    respMatrix.(condition)(3, trial) = 1;                   %recence dans la matrice resultats les matchs
                    
                    if response == 1
                        disp('mauvaise réponse : faux négatif')
                        respMatrix.(condition)(4, trial) = 0;
                        false_neg = false_neg + 1;
                        respMatrix.(condition)(7, trial) = 1;               %colonne false positive
                        respMatrix.(condition)(8, trial) = reactionTime;    %note le TR
                        totalRT_incorrect = totalRT_incorrect + reactionTime; %en vue de calculer le TR moyen
                    elseif response == 2 % bonne reponse
                        disp('bonne réponse : vrai positif')
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
                        disp('bonne réponse : vrai négatif')
                        corrects = corrects + 1;                            %compte les bonnes reponses du sujet
                        true_neg = true_neg + 1;
                        respMatrix.(condition)(4, trial) = 1;               %note bonne rep dans mat de resultats
                        respMatrix.(condition)(6, trial) = reactionTime;    %note le TR
                        totalRT_correct = totalRT_correct + reactionTime;   %en vue de calculer le TR moyen
                    elseif response == 2 % mauvaise reponse et faux positif
                        disp('mauvaise réponse : faux positif')
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
                disp('absence de réponse')
                miss = miss + 1; % absense de reponse
            end
            
            % cas ou c'est un MATCH
            if str2num(cell2mat(displayedNum)) == 50
                %                str2num(cell2mat(displayedNum)) == str2num(condition(9)) % detection de chiffre selon condition
                targets = targets + 1; %compte les target
                respMatrix.(condition)(3, trial) = 1; %recence dans la matrice resultats les matchs
                
                if response == 1    % mauvaise réponse
                    disp('mauvaise réponse : faux négatif ')
                    respMatrix.(condition)(4, trial) = 0;
                    false_neg = false_neg + 1;
                    respMatrix.(condition)(7, trial) = 1;                   %colonne false positive
                    respMatrix.(condition)(8, trial) = reactionTime;        %note le TR
                    totalRT_incorrect = totalRT_incorrect + reactionTime;   %en vue de calculer le TR moyen
                elseif response == 2 % bonne reponse
                    disp('bonne réponse : vrai positif')
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
                    disp('bonne réponse : vrai négatif')
                    corrects = corrects + 1;                                %compte les bonnes reponses du sujet
                    true_neg = true_neg + 1;
                    respMatrix.(condition)(4, trial) = 1;                   %note bonne rep dans mat de resultats
                    respMatrix.(condition)(6, trial) = reactionTime;        %note le TR
                    totalRT_correct = totalRT_correct + reactionTime;       %en vue de calculer le TR moyen
                elseif response == 2                                        % mauvaise reponse et faux positif
                    disp('mauvaise réponse : faux positif')
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
    elseif strcmp(condition(1:3),'One')== true
        back='One Numbers ago';
    elseif strcmp(condition(1:3),'Zer')
        back='Presented Number';
    end
    
    if ~strcmp(condition,'Rest')
        outputHeader = { 'Number', back, 'Match', 'Correctly Identified', 'False_pos', 'Reaction Time correct', 'False_neg', 'Reaction Time incorrect'};
        %output = dataset({respMatrix.(condition)',outputHeader{:}});
        disp(['Vous avez fait ', num2str(corrects), ' réponses correctes sur ', num2str(numStims-trialWithoutResponse) ' et fait ', num2str(false_pos), ' fausses identifications.'])
        disp(['La moyenne de votre temps de réaction est ', num2str(totalRT_correct/corrects), ' secondes.'])
        
        Res_details_struct = struct;
        Res_details_struct.Subject = repmat(Sujet,numStims,1);
        Res_details_struct.Condition = repmat(condition,numStims,1);
        Res_details_struct.Duration = repmat(StimulusDuration,numStims,1);
        Res_details_struct.output = respMatrix.(condition)';
        Res_details_struct.output_header = outputHeader;
        
        
        resMoyensHeader = {'Nombre de Targets' 'Nombre de miss' 'Corrects' 'Incorrects'                             'Vrais positifs' 'Vrais negatifs' 'Faux positifs' 'Faux negatifs' 'RTcorrect' 'RTincorrect'};
        
        res= [              targets             miss            corrects    numStims-corrects-trialWithoutResponse-miss  true_pos          true_neg          false_pos       false_neg (totalRT_correct/corrects) (totalRT_incorrect/(numStims-trialWithoutResponse-corrects-miss))];
        
        Res_moy_struct = struct;
        Res_moy_struct.Subject = Sujet;
        Res_moy_struct.Condition = condition;
        Res_moy_struct.Duration = StimulusDuration;
        Res_moy_struct.res = res;
        Res_moy_struct.res_header = resMoyensHeader;
        
        filename_details=['Sujet' num2str(Sujet) '_' condition '_details'];
        filename_moy=['Sujet' num2str(Sujet) '_' condition '_moy'];
        
        Res.(filename_details)=Res_details_struct;
        Res.(filename_moy)=Res_moy_struct;
        
        % Matrice_résultat(condition, nombre de stimulus, nombre de réponses correctes, nombre de réponses incorrectes, sans réponse, vrais positifs, vrais négatifs, faux positifs, faux positifs, temps de réaction moyen pour les réponses correctes)
        Matrice_resultat = cat(1, Matrice_resultat, [trigger_number, (numStims-trialWithoutResponse), corrects, (numStims-corrects-trialWithoutResponse-miss), trialWithoutResponse, true_pos, true_neg, false_pos, false_neg, (totalRT_correct/corrects)]);
        
    end
end

% fclose (arduino);

% Debriefs user and prompts user to close the experiment window
Screen('TextSize', window, InstructionTextSize);
DrawFormattedText(window, 'Toulouse N-back Task terminée\n\n Appuyez sur la touche rouge pour quitter', 'center', 'center', couleur_police);
Screen('Flip', window);

%CedrusResponseBox('WaitButtonPress', myBox);
waitfor(KbName == 'f');
sca;

end
