function [ resultat_TNT ] = TNT_2_difficulties(Sujet, condition_son)
% Summary : fonction Toulouse-n-back-task : 0-back et 2-back
% Clears the workspace, screen, variables, and command prompt
% instantiate the LSL library

text = ['Participant ', num2str(Sujet),'condition ', num2str(condition_son)];
disp(text)
disp('Loading library...');
lib = lsl_loadlib();

% make a new LSL stream outlet
disp('Creating a new streaminfo...');
info = lsl_streaminfo(lib,'TNT_MarkerStream','Markers',1,0,'cf_string', ...
    'myuniquesourceid23443');
disp('Opening an outlet...');
outlet = lsl_outlet(info);

% Set markers names
disp('Defining data flags');
markers = struct('Start', {'Start'}, 'Stop', {'Stop'}, ... 
    'True_positive', {'True_positive'}, 'True_negative', {'True_negative'},...
     'False_positive', {'False_positive'}, 'False_negative', {'False_negative'}, ...
     'Instructions_start', {'Instructions_start'}, 'Instructions_end', ...
     {'Instructions_end'}, 'N0_back', {'0_back'}, 'N2_back', {'2_back'},...
     'Block_start', {'Block_start'}, ...
     'Block_end', {'Block_end'}, 'Rest_back', {'Rest_back'}, ...
     'No_answer', {'No_answer'}, 'Stim_display', {'Stim_display'}, ...
     'Button_pressed', {'Button_pressed'});



% Creates a windows that waits for clic before continue
message = 'Cliquez sur OK pour continuer';
title = 'Waiting Box';
waitfor(msgbox(message,title));


Screen('CloseAll');
Screen('Preference','SkipSyncTests', 0);
CedrusResponseBox('CloseAll'); % remet à 0 tous les ports cedrus
myBox = CedrusResponseBox('Open', 'COM22');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % devices = daq.getDevices
% arduino = serial ('COM5'); %check Arduino COM value
% %If error. Use seriallist to check active COM ports
% fopen (arduino);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Informations d'affichage
% Initiates Psychtoolbox boilerplate operations
PsychDefaultSetup(2)
% HideCursor; % permet de cacher la souris

% Timing Info
isiTimeSecs = 1;            % Temps inter-stimulus en seconde
StimulusDuration = 2 ;      % Temps de présentation du stimulus en seconde
numStimsAct = 12 ;          % Nombre de stimuli présenté par bloc (max 12)
numStimsRest = 6 ;          % Nombre de stimuli de repos '00+00' (max 6)
InstructionTextSize = 35;   % Taille de la police pour les consignes
TaskTextSize = 65;          % Taille de police pour la tâche
InstructionDisplayTime = 5; % Temps d'affichage des consignes avec compte à rebours
wrapat = 75;                 % Nombre de caractère avant un retour à la ligne
vSpacing = 2;                % Interligne

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

% Expérience principale
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%    Main Experiment    %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% les differentes conditions
if mod(condition_son,2)==0  % si numéro condtion = pair : le sujet commence par 0-back, sinon il commence par 2-back
    Backs = [0 2 0 2 0 2];
else
    Backs = [2 0 2 0 2 0];
end

%Compteurs des n-back
num_back = [0 1 2 3 4 5 6 7 8 9 ]; % il y a 12 opérations par conditions mais je met de 0 à 9 parce qu'on va incrémenter le compteur de +3 donc = 12
num_back = Shuffle(num_back);
cpteZero = num_back(1);
cpteTwo= num_back(1);


% créer une matrice de 0 et 1 de la taille 2* nombre de sons aversives ????
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

%Affichage des instructions (Appuyez sur un bouton) avant le début de l'essai
outlet.push_sample({markers.Instructions_start}); % Send Instructions_start marker
Screen('TextSize', window, InstructionTextSize);
DrawFormattedText(window, 'Appuyez sur une touche du boîter gris lorsque\n\nlorsque vous êtes prêt à commencer', 'center', 'center', couleur_police);
Screen('Flip', window);
CedrusResponseBox('WaitButtonPress', myBox);
outlet.push_sample({markers.Instructions_end}); % Send Instructions_stop marker


for bloc = 1:size(Conditions,2)
    
    % Créer une matrice de réponse de 8 lignes et 12 colonnes (numStimsAct)
    condition=cell2mat(Conditions(bloc));
    
    if strcmp(condition, 'Rest')
        numStims = numStimsRest;
    else
        numStims = numStimsAct;
        respMatrix.(condition) = NaN(8, numStims);    %créer une matrice de taille 8*12 (numStims) rempli de NaN
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
    outlet.push_sample({markers.Start}); % Send experiment start flag
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
            outlet.push_sample({markers.N2_back}); % Send 2 Back flag
        elseif strcmp(condition (1:3),'Zer')==true
            trigger_number = 0;
            outlet.push_sample({markers.N0_back}); % Send 0 Back flag
        elseif strcmp(condition(1:3),'Res')== true
            trigger_number = 7;
            outlet.push_sample({markers.Rest_back}); % Send Rest Back flag
        end

        %%%Ecriture sur le USBtoparallel
        %trigger = strcat(num2str(trigger_number) , num2str(condition_son)); %trigger(1,2,7) + condition_son(0,1,2,3,4,5)        
        %fwrite (arduino,str2num(trigger),'uint8'); % Write the number of the trigger int value on arduino port with a 8 bit format.

        % Starts reaction timer
        t0 = GetSecs;
        response = 0;
        frame = 0;

        while GetSecs-t0 < StimulusDuration
            if frame == 0
                outlet.push_sample({markers.Stim_display}); % Send Stim display flag
            end
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
                outlet.push_sample({markers.Button_pressed}); % Send Button_pressed flag
                %Stops timer, calculates response time
                reactionTime = GetSecs - t0;
                str_RT = num2str(reactionTime);
                outlet.push_sample({str_RT}); % Send Reaction Time flag
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
                respMatrix.(condition)(2, trial) = cell2mat(numList(trial-2,1)); %recense le nombre presente en 2-back

                % absense de reponse
                if response == 0
                    disp('absence de réponse')
                    miss = miss + 1;
                    outlet.push_sample({markers.No_answer}); % Send No_answer flag
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
                        outlet.push_sample({markers.False_negative}); % Send False_neg flag
                        disp(string(reactionTime));
                    elseif response == 2 % bonne reponse
                        disp('bonne réponse : vrai positif')
                        corrects = corrects + 1;                            %compte les bonnes reponses du sujet
                        true_pos = true_pos + 1;
                        respMatrix.(condition)(4, trial) = 1;               %note bonne rep dans mat de resultats
                        respMatrix.(condition)(6, trial) = reactionTime;    %note le TR
                        totalRT_correct = totalRT_correct + reactionTime;   %en vue de calculer le TR moyen
                        outlet.push_sample({markers.True_positive}); % Send True_positive flag
                        disp(string(reactionTime));
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
                        outlet.push_sample({markers.True_negative}); % Send True_neg flag
                        disp(string(reactionTime));
                    elseif response == 2 % mauvaise reponse et faux positif
                        disp('mauvaise réponse : faux positif')
                        false_pos = false_pos + 1;
                        respMatrix.(condition)(4, trial) = 0;
                        respMatrix.(condition)(5, trial) = 1;               %colonne false positive
                        respMatrix.(condition)(8, trial) = reactionTime;    %note le TR
                        totalRT_incorrect = totalRT_incorrect + reactionTime; %en vue de calculer le TR moyen
                        outlet.push_sample({markers.False_positive}); % Send False_positive flag
                        disp(string(reactionTime));
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
                outlet.push_sample({markers.No_answer}); % Send No_answer flag
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
                    outlet.push_sample({markers.False_negative}); % Send False_neg flag
                    disp(string(reactionTime));
                elseif response == 2 % bonne reponse
                    disp('bonne réponse : vrai positif')
                    corrects = corrects + 1;                                %compte les bonnes reponses du sujet
                    true_pos = true_pos + 1;
                    respMatrix.(condition)(4, trial) = 1;                   %note bonne rep dans mat de resultats
                    respMatrix.(condition)(6, trial) = reactionTime;        %note le TR
                    totalRT_correct = totalRT_correct + reactionTime;       %en vue de calculer le TR moyen
                    outlet.push_sample({markers.True_positive}); % Send True_positive flag
                    disp(string(reactionTime));
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
                    outlet.push_sample({markers.True_negative}); % Send True_neg flag
                    disp(string(reactionTime));
                elseif response == 2                                        % mauvaise reponse et faux positif
                    disp('mauvaise réponse : faux positif')
                    false_pos = false_pos + 1;
                    respMatrix.(condition)(4, trial) = 0;
                    respMatrix.(condition)(5, trial) = 1;                   %colonne false positive
                    respMatrix.(condition)(8, trial) = reactionTime;        %note le TR
                    totalRT_incorrect = totalRT_incorrect + reactionTime;   %en vue de calculer le TR moyen
                    outlet.push_sample({markers.False_positive}); % Send False_positive flag
                    disp(string(reactionTime));
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
        outlet.push_sample({markers.Block_end}); % Send Block end flag

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
    end
end

fclose (arduino);

% enregistre les résultats dans le dossier 'Resultats'
% filename = ['CHEMIN_VERS_LE_DOSSIER_RESULTATS\TNT_Res_' num2str(Sujet) '_' num2str(condition_son) '.mat'];
% 
% assignin('base',['Res' num2str(Sujet)], Res)
% 
% if exist(filename,'file')
%     save(filename,['Res' num2str(Sujet)],'-append');
% else
%     save(filename,['Res' num2str(Sujet)]);
% end
resultat_TNT = Res;

% Debriefs user and prompts user to close the experiment window
Screen('TextSize', window, InstructionTextSize);
DrawFormattedText(window, 'Tâche terminée ! \n\n Appuyez sur une touche pour quitter', 'center', 'center', couleur_police);
Screen('Flip', window);
outlet.push_sample({markers.Stop}); % Send Experiment end flag
CedrusResponseBox('WaitButtonPress', myBox);
sca;
end