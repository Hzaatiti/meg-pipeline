clear
close all
clc

Sujets = 1:14;

Data_condition=nan(length(Sujets),3,3,8); % Data(Sujet,Conditions,N-back,[nombre de réponses correctes, nombre de réponses incorrectes, sans réponse, vrais positifs, vrais négatifs, faux positifs, faux négatifs, temps de réaction moyen pour les réponses correctes])
Data_time=nan(length(Sujets),3,3,8);

for sujet = Sujets
    load([pwd '\Sujet_' num2str(sujet) '\Conditions_tache.mat']);
    
    Conditions_tache_bis = [];
    for cond = Conditions_tache'
        if cond == 10
            Conditions_tache_bis = [Conditions_tache_bis, 0];
        elseif cond == 11
            Conditions_tache_bis = [Conditions_tache_bis, 1];
        elseif cond == 12
            Conditions_tache_bis = [Conditions_tache_bis, 2];
        end
    end
    
    cmp = 1;
    for C = 1:3      
        load([pwd '\Sujet_' num2str(sujet) '\resultat_TNT_' num2str(Conditions_tache_bis(C)) '.mat']);
        % Matrice_résultat(condition, nombre de stimulus, nombre de réponses correctes, nombre de réponses incorrectes, sans réponse, vrais positifs, vrais négatifs, faux positifs, faux négatfis, temps de réaction moyen pour les réponses correctes)
        
        eval(['resultat = resultat_TNT_' num2str(Conditions_tache_bis(C)) ';']);
        
        for condition_n_back = 0:2
            Data_condition(sujet, Conditions_tache_bis(C)+1, condition_n_back +1, :) = nanmean(resultat(find(resultat(:,1)==condition_n_back),3:10));
            Data_time(sujet, cmp, condition_n_back +1, :) = nanmean(resultat(find(resultat(:,1)==condition_n_back),3:10));
%             disp(['Sujet : ' num2str(sujet) ', condition tâche : ' num2str(Conditions_tache_bis(C)) ', condition n-back : ' num2str(condition_n_back)])
        end
        cmp = cmp +1;
    end
end

% pour réordonner les conditions
% Data_condition= Data_condition (:,[2 3 1],:,:,:);
% Data_condition= Data_condition (:,:,[2 3 1],:,:);
% Data_time= Data_time (:,:,[2 3 1],:,:);

% Data(Sujet,Conditions,N-back,[nombre de réponses correctes, nombre de réponses incorrectes, sans réponse, vrais positifs, vrais négatifs, faux positifs, faux négatifs, temps de réaction moyen pour les réponses correctes])

%% Mise en forme des données pour Statistica
%           1           2               3              4               5                6                7             8
% res = ['Corrects','Incorrects','Sans Réponse','Vrais positifs','Vrais negatifs','Faux positifs','Faux negatifs','RTcorrect']
M_condition = [];
M_time = [];
res =8;

for cond = 1:3
    for nback = 1:3
        M_condition = [M_condition mean(Data_condition(:,cond,nback,res,:),5)];
        M_time = [M_time mean(Data_time(:,cond,nback,res,:),5)];
    end
end
M_time_bis = M_time(:,[1 4 7 2 5 8 3 6 9]); % pour Statistica : [0-back_T1, 0-back_T2, 0-back_T3, 1-back_T1, 1-back_T2, 1-back_T3, 2-back_T1, 2-back_T2, 2-back_T3]
%%
% Nombre de stimuli - nombre de réponses correctes. res = 1
nb_stim = ones(14,9) .* [ 12 11 10  12 11 10 12 11 10];
nb_incorrects = nb_stim - M_condition;

%% Plot des résultats TNT

close all
figure
hold on
grid on

resplot = 'inc'; %'cor' 'TDR' 'inc' % Choix du résultat à ploter : cor = nombre de réponse correcte, TDR = temps de réaction
modalite = 'cond'; % 'temp' 'cond'  % Choix de la modalité à ploter : temp = en fonction du temps, cond = en fonction des conditions


if strcmp(modalite , 'cond')
    M = M_condition;
    M_bis = [1 4 7 2 5 8 3 6 9];
    M = M(:,M_bis);
    
%     M = reshape(M,14,3,3);
elseif strcmp(modalite,'temp')
    M = M_time;
end

M_bis = squeeze(nanmean(M));
% S = squeeze(nanstd(M))/sqrt(20)*1.96;

grid on

% xe=repmat([-.22 0 .22],3,1) + repmat([1:3]',1,3);
% xe=sort(xe(:));
% xe=reshape(xe,3,3);

M0 = nanmean(M_bis(:,1:3),1);
M1 = nanmean(M_bis(:,4:6),1);
M2 = nanmean(M_bis(:,7:9),1);
% SD1=std(Matrice_resultat_difficulte_temps(:,:,1),[],1); % avec error bar = écart-type
% SD2=std(Matrice_resultat_difficulte_temps(:,:,2),[],1);
S0=std(M(:,1:3))/sqrt(20)*1.96;
S1=std(M(:,4:6))/sqrt(20)*1.96; % avec error bar = intervalle de confiance à 95 %
S2=std(M(:,7:9))/sqrt(20)*1.96;
% cou = [0.98 0.73 0.25];
cou = [0.19 0.73 0.73];
plot(M0,'-s','markersize',10,'markerfacecolor',cou, 'Color', cou)
% plot(M0,'g-s','markersize',10,'markerfacecolor','g')
plot(M1,'b-s','markersize',10,'markerfacecolor','b')
plot(M2,'r-s','markersize',10,'markerfacecolor','r')

errorbar(1:3,M0,S0,'.','Color', cou);
% errorbar(1:3,M0,S0,'.k');
errorbar(1:3,M1,S1,'.b');
errorbar(1:3,M2,S2,'.r');

legend('0-back','1-back', '2-back')
% legend('0-back','1-back', '2-back', 'location', 'best')

% Sigbar
% groups={[1,2],[1,3],[1,4], [1,5],[1,6],...
%     [2,4],[2,5],[2,6]...
%     [3,5]};
% 
% H=sigstar(groups,repmat(0.05, size(groups)));


if strcmp(resplot , 'cor')
    ylim([5 15])
%     yticks([5:1:15])
    ylabel('Nombre de réponses correctes')
elseif strcmp (resplot,'TDR')
    ylim([0.8 1.8])
    ylabel('Temps de réaction (s)')
elseif strcmp(resplot,'inc')
    ylim([-0.25 3])
    yticks(0:3)
    ylabel('Nombre de réponses incorrectes')
end

pos1 = 0.11; pos2 = .15; pos3 = 1-pos1 - 0.05; pos4 = 1-pos2 - 0.05;
set(gca,'Position', [pos1 pos2 pos3 pos4])

if strcmp(modalite , 'cond')
    xlabel('Conditions sonores')
    xticklabels({'silence', 'stationnaire', 'fluctuant'})
    xlim([0.5 3.5])    
elseif strcmp(modalite,'temp')
    xlabel('Temps')
    xticks(1:3)
    xticklabels({'présentation 1', 'présentation 2', 'présentation 3'})
    xlim([0.5 3.5])
end
% set(gca,'FontSize',13, 'FontName', 'Segeo UI')
% set(gca,'xtick',1:3,'xticklabelrotation',45);
set(gca,'xtick',1:3,'FontSize', 14, 'FontName', 'Segoe UI Light')

    saveas(gcf, ['E:\Thèse\Rédaction manuscrit\figures\XPC_TNT_' resplot '_' modalite '.png'])
%%
% Test d'homogénéité des variaences : le rapport de la plus grande sur la
% plus petite doit être inférieur à 4

% data = M_condition(:,7:12);
data = M_time(:,7:12);

V = var(data);
if (max(V)/min(V))<4
    disp('V : Egalité des variances = OK')
else
    disp('V : Egalité des variances : non respecté')
end

% Test de la normalité des données : test de Kolmogorov-Smirnov
[h] = kstest((data-mean(data))/std(data)) % h = 1 : rejet de l'hypothèse nulle à 5% que les données suivent une loi normale; Il faut centré et réduire les données pour faire le test
