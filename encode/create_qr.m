% Version du code QR
% la version 1 permet 10 caractères maximum
% 72 bits dont 9 mots de données
version = 1;
size = 21;
% 30% de correction d'erreur
error_code_version = 'H';

% Fixed Patterns, on inverse les 1 et 0 pour faire le or logique
fixed_patterns = ~(or(~finder_pattern(), ~timing_pattern()));
all_patterns = ~(or(~fixed_patterns, ~format_string()));
% Le Dark Module est un point noir placé en 8 en abcisse
% et la version du QR x 4 + 9 en ordonnée
all_patterns(14, 9) = 0;

% Affiche le code QR.
img = imshow(all_patterns, 'InitialMagnification','fit');