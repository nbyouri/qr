% Version du code QR
% la version 1 permet 10 caract�res maximum
% 72 bits dont 9 mots de donn�es
version = 1;
size = 21;
% 30% de correction d'erreur
error_code_version = 'H';

% Fixed Patterns, on inverse les 1 et 0 pour faire le or logique
% Le Dark Module est un point noir plac� en 8 en abcisse
% et la version du QR x 4 + 9 en ordonn�e
fixed_patterns = ~(or(~finder_pattern(), ~timing_pattern()));
fixed_patterns(14, 9) = 0;

% Affiche le code QR.
img = imshow(fixed_patterns, 'InitialMagnification','fit');