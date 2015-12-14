% Version du code QR
% la version 1 permet 10 caract�res maximum
% 72 bits dont 9 mots de donn�es
version = 1;
size = 21;
% 30% de correction d'erreur
error_code_version = 'H';

% Input de la chaine alphanum�rique par l'utilisateur
str = input('chaine : ', 's');

% Encodage de la chaine
msg_data = data_encode(str);
ec_data = error_correction_encode(msg_data);

% Fixed Patterns, on inverse les 1 et 0 pour faire le or logique
fixed_patterns = ~(or(~finder_pattern(), ~timing_pattern()));
patterns = ~(or(~fixed_patterns, ~format_string(1)));
data = embed_data(all_patterns, msg_data, ec_data);
all = ~(or(~patterns, ~data));

% Le Dark Module est un point noir plac� en 8 en abcisse
% et la version du QR x 4 + 9 en ordonn�e
all(14, 9) = 0;

% Affiche le code QR.
imshow(mask(all), 'InitialMagnification','fit');