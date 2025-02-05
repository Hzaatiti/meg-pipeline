% Script de déroulement de l'XP : TNT, lecture et horloge

close all
clear
clc

addpath(genpath('Sons'));
InitializePsychSound();

Sujet = input('Identifiant participant (attention à ne pas se tromper) : ');

% Création d'un nouveau dossier dans 'Resultats' pour enregistrer les résultats
try
    mkdir ('Résultats', ['Sujet_' num2str(Sujet)]);
catch
    disp('L''identifiant du sujet existe déjà');
    IDparticipant = input('Enter a number : ');
end

fichier = [ pwd '\Résultats\Sujet_' num2str(Sujet) '\'];
diary([fichier 'diary'])
datetime
disp(['Identifiant sujet : ' num2str(Sujet)])

% Entrainement à la TNT
TNT_entrainement_3diff()

% Entraintement horloge
tache_horloge(30);


% Charge les textes et les randomise
load('Textes.mat')
Conditions_textes = [1 2 10];
Conditions_textes = Shuffle(Conditions_textes);
save([fichier 'Ordre_textes.mat'], 'Conditions_textes');                    % Enregistrement de l'ordre des textes

% Conditions de la tâche
Conditions_tache = [10; 11; 12; 20; 21; 22; 30; 31 ;32];
Conditions_tache = Shuffle(Conditions_tache);
C1=1;   % Filtre pour ne pas avoir deux fois de suite la même tâche
C2=1;   % Filtre pour ne pas avoir deux fois de suite la même condition sonore
C = 1;  % Combine les 2 conditions
% nb_step = 0;
while C
    Conditions_tache = Shuffle(Conditions_tache);
    Conditions_char = num2str(Conditions_tache);
    C1= ~isempty(find(Conditions_char(1:end-1,1)==Conditions_char(2:end,1)));
    C2= ~isempty(find(Conditions_char(1:end-1,2)==Conditions_char(2:end,2)));
    C = ~(C1 == 0 && C2 == 0);
%     nb_step = nb_step +1;
end
% disp(['Nb step : ' num2str(nb_step)])
save([fichier 'Conditions_tache.mat'], 'Conditions_tache');                 % Enregistrement de l'ordre des conditions

niveau_bruit = 1;                                                           % Niveau à 1 = pas d'augmentation du bruit

nb_points_horloge = (5*60)/0.8;

% Questionnaire de fatigue de début d'expérience
[resultat_fatigue_9]=Fatigue() ;
save([fichier 'resultat_fatigue_9.mat'], 'resultat_fatigue_9');


for condition = Conditions_tache' % pour chaque condition
    disp(['Ordre des conditions : ' (num2str(Conditions_tache'))]);
    disp(['Condition : ' num2str(condition)]);
    
    cond = num2str(condition);
    
    fenetre_trigger_faros()
    
    if strcmp(cond(1), '1')                                 % Lancement de la TNT
        disp('Début tâche : Toulouse N-back Task')
        
        if strcmp(cond(2), '1') || strcmp(cond(2), '2')     % Conditions avec lancement d'un son
            disp(['Début son : ' cond(2)])
            
            
            %%%%%%%%%%%%%%%%%%%%% Lancement du son %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            repetitions = 0;        % repetitions = Number of repetitions of the sound. Zero = Repeat forever (until stopped by keypress), 1 = Play once, 2 = Play twice, ....
            % Read WAV file from filesystem:
            [y, freq] = psychwavread(['son' cond(2) '.wav']);
            wavedata = y' * niveau_bruit;
            nrchannels = size(wavedata,1); % Number of rows == number of channels.
            % Make sure we have always 2 channels stereo output. Why? Because some low-end and embedded soundcards only support 2 channels, not 1 channel, and we want to be robust in our demos.
            if nrchannels < 2
                wavedata = [wavedata ; wavedata];
                nrchannels = 2;
            end
            % Open the default audio device [], with default mode [] (==Only playback), and a required latencyclass of zero 0 == no low-latency mode, as well as a frequency of freq and nrchannels sound channels. This returns a handle to the audio device:
            pahandle = PsychPortAudio('Open', [], [], 0, freq, nrchannels);
            % Fill the audio playback buffer with the audio data 'wavedata':
            PsychPortAudio('FillBuffer', pahandle, wavedata);
            % Start audio playback for 'repetitions' repetitions of the sound data, start it immediately (0) and wait for the playback to start, return onset timestamp.
            PsychPortAudio('Start', pahandle, repetitions, 0, 1);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
        end
        
        assignin('base', ['resultat_TNT_' cond(2)], TNT_3_difficulties(Sujet)) ;
        save([fichier 'resultat_TNT_' cond(2) '.mat'], ['resultat_TNT_' cond(2)]);
        
        % Arrêt du son
        if strcmp(cond(2), '1') || strcmp(cond(2), '2')
            PsychPortAudio('Stop', pahandle);
            disp(['Arrêt son : ' cond(2)]);
        end
        
    elseif strcmp(cond(1), '2')                             % Lancement de la tâche de lecture
        disp('Début tâche : tâche de lecture')
        disp(['Texte n°' Conditions_textes(str2num(cond(2))+1)])
        if strcmp(cond(2), '1') || strcmp(cond(2), '2')     % Conditions avec lancement d'un son
            disp(['Début son : ' cond(2)])
            %%%%%%%%%%%%%%%%%%%%% Lancement du son %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            repetitions = 0;        % repetitions = Number of repetitions of the sound. Zero = Repeat forever (until stopped by keypress), 1 = Play once, 2 = Play twice, ....
            % Read WAV file from filesystem:
            [y, freq] = psychwavread(['son' cond(2) '.wav']);
            wavedata = y' * niveau_bruit;
            nrchannels = size(wavedata,1); % Number of rows == number of channels.
            % Make sure we have always 2 channels stereo output. Why? Because some low-end and embedded soundcards only support 2 channels, not 1 channel, and we want to be robust in our demos.
            if nrchannels < 2
                wavedata = [wavedata ; wavedata];
                nrchannels = 2;
            end
            % Open the default audio device [], with default mode [] (==Only playback), and a required latencyclass of zero 0 == no low-latency mode, as well as a frequency of freq and nrchannels sound channels. This returns a handle to the audio device:
            pahandle = PsychPortAudio('Open', [], [], 0, freq, nrchannels);
            % Fill the audio playback buffer with the audio data 'wavedata':
            PsychPortAudio('FillBuffer', pahandle, wavedata);
            % Start audio playback for 'repetitions' repetitions of the sound data, start it immediately (0) and wait for the playback to start, return onset timestamp.
            PsychPortAudio('Start', pahandle, repetitions, 0, 1);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        
        assignin('base', ['resultat_lecture_' cond(2)], affichage_texte(Textes{Conditions_textes(str2num(cond(2))+1)})) ;
        save([fichier 'resultat_lecture_' cond(2) '.mat'], ['resultat_lecture_' cond(2)]);
        
        % Arrêt du son
        if strcmp(cond(2), '1') || strcmp(cond(2), '2')
            PsychPortAudio('Stop', pahandle);
            disp(['Arrêt son : ' cond(2)]);
        end
        
        % Questionnnaire de compréhension du texte
        assignin('base', ['resultat_question_lecture_' cond(2)'], Question_texte(Conditions_textes(str2num(cond(2))+1))) ;
        save([fichier 'resultat_question_lecture_' cond(2) '.mat'], ['resultat_question_lecture_' cond(2)]);
        %
        
    elseif strcmp(cond(1), '3')                             % Lancement de la tâche de l'horloge
        disp('Début tâche : tâche de l''horloge')
        if strcmp(cond(2), '1') || strcmp(cond(2), '2')     % Conditions avec lancement d'un son
            disp(['Début son : ' cond(2)])
            %%%%%%%%%%%%%%%%%%%%% Lancement du son %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            repetitions = 0;        % repetitions = Number of repetitions of the sound. Zero = Repeat forever (until stopped by keypress), 1 = Play once, 2 = Play twice, ....
            % Read WAV file from filesystem:
            [y, freq] = psychwavread(['son' cond(2) '.wav']);
            wavedata = y';
            nrchannels = size(wavedata,1); % Number of rows == number of channels.
            % Make sure we have always 2 channels stereo output. Why? Because some low-end and embedded soundcards only support 2 channels, not 1 channel, and we want to be robust in our demos.
            if nrchannels < 2
                wavedata = [wavedata ; wavedata];
                nrchannels = 2;
            end
            % Open the default audio device [], with default mode [] (==Only playback), and a required latencyclass of zero 0 == no low-latency mode, as well as a frequency of freq and nrchannels sound channels. This returns a handle to the audio device:
            pahandle = PsychPortAudio('Open', [], [], 0, freq, nrchannels);
            % Fill the audio playback buffer with the audio data 'wavedata':
            PsychPortAudio('FillBuffer', pahandle, wavedata);
            % Start audio playback for 'repetitions' repetitions of the sound data, start it immediately (0) and wait for the playback to start, return onset timestamp.
            PsychPortAudio('Start', pahandle, repetitions, 0, 1);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        
        assignin('base', ['resultat_horloge_' cond(2)], tache_horloge(nb_points_horloge)) ;
        save([fichier 'resultat_horloge_' cond(2) '.mat'], ['resultat_horloge_' cond(2)]);
        
        % Arrêt du son
        if strcmp(cond(2), '1') || strcmp(cond(2), '2')
            PsychPortAudio('Stop', pahandle);
            disp(['Arrêt son : ' cond(2)]);
        end
        
    end
    

    fenetre_trigger_faros()
    
    % Questionnaire difficulté de la tâche
    assignin('base', ['resultat_difficulte_' cond], Difficulte()) ;
    save([fichier 'resultat_difficulte_' cond '.mat'], ['resultat_difficulte_' cond]);
    
    % Questionnaire de fatigue
    assignin('base', ['resultat_fatigue_' cond], Fatigue()) ;
    save([fichier 'resultat_fatigue_' cond '.mat'], ['resultat_fatigue_' cond]);
    
    % Questionnaire d'evaluation subjective du bruit
    assignin('base', ['resultat_subj_' cond], Ques_subj());
    save([fichier 'resultat_subj_' cond '.mat'], ['resultat_subj_' cond]);
    
    % Questionnaire d'évaluation de l'état de stress
    assignin('base', ['resultat_SSSQ_' cond], SSSQ());
    save([fichier 'resultat_SSSQ_' cond '.mat'], ['resultat_SSSQ_' cond]);
    
    % pause de 1min30 : fonction compte-a-rebours pour faire une pause de 90 secondes
    if condition == Conditions_tache(end)
        continue
    else
        Compte_a_rebours(90, 1);
    end
end

PsychPortAudio('Close', pahandle);

%%
diary off

disp('Expérience terminée ! =D');
%%durée totale (pauses incluses) = 1heure 21 min