% Version du code QR
% la version 1 permet 10 caractères maximum
% 72 bits dont 9 mots de données
version = 1;
size = 21;
% 30% de correction d'erreur
error_code_version = 'H';
% Le masque 1 est supporté
mask_version = 1;

% Input de la chaine alphanumérique par l'utilisateur
str = input('chaine [1:7]: ', 's');
if length(str) > 7
    error('Chaine trop longue!');
end

% Encodage de la chaine
msg_data = data_encode(str);
ec_data = error_correction_encode(msg_data);

% Fixed Patterns, on inverse les 1 et 0 pour faire le or logique
fixed_patterns = ~(or(~finder_pattern(), ~timing_pattern()));
patterns = ~(or(~fixed_patterns, ~format_string(mask_version)));
data = embed_data(patterns, msg_data, ec_data);
all = ~(or(~patterns, ~data));

% Le Dark Module est un point noir placé en 8 en abcisse
% et la version du QR x 4 + 9 en ordonnée
all(14, 9) = 0;

% Affiche le code QR.
imshow(mask(all), 'InitialMagnification','fit');