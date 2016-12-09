%% VARIABLES D'ENTREES
% Fonction min utilis?e pour restreindre le domaine des variables.
% ex: taux_incapacit? = min([0, 100]): 0 est la variable d'entr?e, 
% 100 est le seuil max qu'on ne peut d?passer.

taux_incapacite = min([0, 100]);
personnes_charge = min([0, 4]);
mois_stage = min([13, 18]);
annees_etudes = min([5, 8]);
toxicite = min([10, 10000]);
age = 20; %pas encore utilis?

SF_ETUDES = readfis('fuzzy_systems/etudes.fis');
SF_PERSONNES = readfis('fuzzy_systems/personnes_charge.fis');
SF_SITUATION = readfis('fuzzy_systems/situation_perso.fis');
SF_INCAPACITE = readfis('fuzzy_systems/taux_incap.fis');
SF_INFLUENCE = readfis('fuzzy_systems/influence_perso.fis');
SF_TOXICITE = readfis('fuzzy_systems/toxicite.fis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%% Inf?rence floue symbolique ETUDES
%%%% A OPTIMISER 

[sortie, irr1, orr, arr] = evalfis([annees_etudes, mois_stage], SF_ETUDES);
declenchementSF_ETUDES = min(irr1, [], 2); % min de chaque ligne

nbruleSF_ETUDES = length(SF_ETUDES.rule); % Nombre de r?gles
nbCsqSF_ETUDES = length(SF_ETUDES.output.mf); % Nombre de classes de sortie
csqSF_ETUDES = zeros(1,nbCsqSF_ETUDES);
for i = 1:nbruleSF_ETUDES,
    csqSF_ETUDES(SF_ETUDES.rule(i).consequent) = max(csqSF_ETUDES(SF_ETUDES.rule(i).consequent),declenchementSF_ETUDES(i));
end;

CsqSF_ETUDESTxt = 'Cons?quence SF_ETUDES = {';
for i = 1:nbCsqSF_ETUDES,
    CsqSF_ETUDESTxt = [CsqSF_ETUDESTxt, '(', SF_ETUDES.output.mf(i).name, ';', num2str(csqSF_ETUDES(i)), '), '];
end;
CsqSF_ETUDESTxt = [CsqSF_ETUDESTxt(1:end-2), '}']; 
disp(CsqSF_ETUDESTxt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%% Inf?rence floue symbolique PERSONNES A CHARGE

[sortie, irr2, orr, arr] = evalfis([personnes_charge], SF_PERSONNES);
declenchementSF_PERSONNES = min(irr2, [], 2); % min de chaque ligne

nbruleSF_PERSONNES = length(SF_PERSONNES.rule); % Nombre de r?gles
nbCsqSF_PERSONNES = length(SF_PERSONNES.output.mf); % Nombre de classes de sortie
csqSF_PERSONNES = zeros(1,nbCsqSF_PERSONNES);
for i = 1:nbruleSF_PERSONNES,
    csqSF_PERSONNES(SF_PERSONNES.rule(i).consequent) = max(csqSF_PERSONNES(SF_PERSONNES.rule(i).consequent),declenchementSF_PERSONNES(i));
end;

CsqSF_PERSONNESTxt = 'Cons?quence SF_PERSONNES = {';
for i = 1:nbCsqSF_PERSONNES,
    CsqSF_PERSONNESTxt = [CsqSF_PERSONNESTxt, '(', SF_PERSONNES.output.mf(i).name, ';', num2str(csqSF_PERSONNES(i)), '), '];
end;
CsqSF_PERSONNESTxt = [CsqSF_PERSONNESTxt(1:end-2), '}']; 
disp(CsqSF_PERSONNESTxt);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%% Inf?rence floue symbolique: SITUATION PERSONNELLE

nbruleSF_SITUATION = length(SF_SITUATION.rule); % Nombre de r?gles
nbCsqSF_SITUATION = length(SF_SITUATION.output.mf); % Nombre de classes de sortie
for i = 1:nbruleSF_SITUATION, % Boucle sur les r?gles
    irr3(i,1) = csqSF_PERSONNES(SF_SITUATION.rule(i).antecedent(1));
    irr3(i,2) = csqSF_ETUDES(SF_SITUATION.rule(i).antecedent(2)); 
end;

declenchementSF_SITUATION = min(irr3, [], 2); % min de chaque ligne

%%%%%%%%%%
%% Cons?quence Finale : par max-union de toutes les cons?quences floues %% partielles
% Initialisation de la cons?quence finale

csqSF_SITUATION = zeros(1,nbCsqSF_SITUATION);
for i = 1:nbruleSF_SITUATION,
    csqSF_SITUATION(SF_SITUATION.rule(i).consequent) = max(csqSF_SITUATION(SF_SITUATION.rule(i).consequent), declenchementSF_SITUATION(i));
end;

% Affichage de la cons?quence finale de SF3 % Concat?nation de texte
CsqSF_SITUATIONTxt = 'Cons?quence SITUATION PERSONNELLE = {';
for i = 1:nbCsqSF_SITUATION,
    CsqSF_SITUATIONTxt = [CsqSF_SITUATIONTxt, '(', SF_SITUATION.output.mf(i).name, ';', num2str(csqSF_SITUATION(i)), '), '];
end;

CsqSF_SITUATIONxt = [CsqSF_SITUATIONTxt(1:end-2), '}']; 
disp(CsqSF_SITUATIONTxt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%% Inf?rence floue symbolique TAUX INCAPACITE

[sortie, irr4, orr, arr] = evalfis([taux_incapacite], SF_INCAPACITE);
declenchementSF_INCAPACITE = min(irr4, [], 2); % min de chaque ligne

nbruleSF_INCAPACITE = length(SF_INCAPACITE.rule); % Nombre de r?gles
nbCsqSF_INCAPACITE = length(SF_INCAPACITE.output.mf); % Nombre de classes de sortie
csqSF_INCAPACITE = zeros(1,nbCsqSF_INCAPACITE);
for i = 1:nbruleSF_INCAPACITE,
    csqSF_INCAPACITE(SF_INCAPACITE.rule(i).consequent) = max(csqSF_INCAPACITE(SF_INCAPACITE.rule(i).consequent),declenchementSF_INCAPACITE(i));
end;

CsqSF_INCAPACITETxt = 'Cons?quence SF_INCAPACITE = {';
for i = 1:nbCsqSF_INCAPACITE,
    CsqSF_INCAPACITETxt = [CsqSF_INCAPACITETxt, '(', SF_INCAPACITE.output.mf(i).name, ';', num2str(csqSF_INCAPACITE(i)), '), '];
end;
CsqSF_INCAPACITETxt = [CsqSF_INCAPACITETxt(1:end-2), '}']; 
disp(CsqSF_INCAPACITETxt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%% Inf?rence floue symbolique: INFLUENCE PERSONNELLE


nbruleSF_INFLUENCE = length(SF_INFLUENCE.rule); % Nombre de r?gles
nbCsqSF_INFLUENCE = length(SF_INFLUENCE.output.mf); % Nombre de classes de sortie

for i = 1:nbruleSF_INFLUENCE, % Boucle sur les r?gles
    irr5(i,1) = csqSF_INCAPACITE(SF_INFLUENCE.rule(i).antecedent(1));
    irr5(i,2) = csqSF_SITUATION(SF_INFLUENCE.rule(i).antecedent(2)); 
end;

declenchementSF_INFLUENCE = min(irr5, [], 2); % min de chaque ligne

%%%%%%%%%%
%% Cons?quence Finale : par max-union de toutes les cons?quences floues %% partielles
% Initialisation de la cons?quence finale

csqSF_INFLUENCE = zeros(1,nbCsqSF_INFLUENCE);
for i = 1:nbruleSF_INFLUENCE,
    csqSF_INFLUENCE(SF_INFLUENCE.rule(i).consequent) = max(csqSF_INFLUENCE(SF_INFLUENCE.rule(i).consequent), declenchementSF_INFLUENCE(i));
end;

% Affichage de la cons?quence finale de SF3 % Concat?nation de texte
CsqSF_INFLUENCETxt = 'Cons?quence INFLUENCE PERSONNELLE = {';
for i = 1:nbCsqSF_INFLUENCE,
    CsqSF_INFLUENCETxt = [CsqSF_INFLUENCETxt, '(', SF_INFLUENCE.output.mf(i).name, ';', num2str(csqSF_INFLUENCE(i)), '), '];
end;

CsqSF_INFLUENCETxt = [CsqSF_INFLUENCETxt(1:end-2), '}']; 
disp(CsqSF_INFLUENCETxt);

% DEFUZZIFICATION SUGENO
numerateur = 0;
denominateur = 0;
for i = 1:nbCsqSF_INFLUENCE,
    CsqSF_INFLUENCETxt = [CsqSF_INFLUENCETxt, '(', SF_INFLUENCE.output.mf(i).name, ';', num2str(csqSF_INFLUENCE(i)), '), '];
    numerateur = numerateur + SF_INFLUENCE.output.mf(i).params(2) * csqSF_INFLUENCE(i);
    denominateur = denominateur + csqSF_INFLUENCE(i);
end;

score = numerateur / denominateur;
disp(['Influence Personnelle finale: ', num2str(score)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%% Inf?rence floue symbolique TOXICITE

[sortie, irr6, orr, arr] = evalfis([toxicite], SF_TOXICITE);
declenchementSF_TOXICITE = min(irr6, [], 2); % min de chaque ligne

nbruleSF_TOXICITE= length(SF_TOXICITE.rule); % Nombre de r?gles
nbCsqSF_TOXICITE = length(SF_TOXICITE.output.mf); % Nombre de classes de sortie
csqSF_TOXICITE = zeros(1,nbCsqSF_TOXICITE);
for i = 1:nbruleSF_TOXICITE,
    csqSF_TOXICITE(SF_TOXICITE.rule(i).consequent) = max(csqSF_TOXICITE(SF_TOXICITE.rule(i).consequent),declenchementSF_TOXICITE(i));
end;

CsqSF_TOXICITETxt = 'Cons?quence SF_TOXICITE = {';
for i = 1:nbCsqSF_TOXICITE,
    CsqSF_TOXICITETxt = [CsqSF_TOXICITETxt, '(', SF_TOXICITE.output.mf(i).name, ';', num2str(csqSF_TOXICITE(i)), '), '];
end;
CsqSF_TOXICITETxt = [CsqSF_TOXICITETxt(1:end-2), '}']; 
disp(CsqSF_TOXICITETxt);
