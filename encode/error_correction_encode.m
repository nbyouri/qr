% Crée la chaine de correction d'erreurs, ici comme on utilise un QRv1-H
% on a 30% de correction, ce qui est le mieux pour un QRv1. Un calcul
% savant est opéré à partir des valeurs base10 des bytes de données
% contenues dans l'encodage du message.
function [ error_correction_bytes ] = error_correction_encode(string)
    message_data = str2bytes2dec(string);
    ecc = get_error_correction_blocks(message_data);
    % cells of strings -> string
    ecc = strjoin(ecc);
    % enlève les espaces
    error_correction_bytes = ecc(~isspace(ecc));
    print_bytes(error_correction_bytes);
end

% Récupère les blocs de correction d'erreurs par la division polynomiale
% Utilise les valeurs du message séparées en bytes et du nombre de blocs de
% correction d'erreurs désirés, QRv1-H en utilise 9. Exemple pour
% l'encodage de 'ephec' en QRv1-H, 
% http://www.thonky.com/qr-code-tutorial/show-division-steps
% Ici on utilise un outil externe pour faire l'opération.
function [error_bytes] = get_error_correction_blocks(bytes)
    str = num2str(bytes);
    [status, cmdout] = system(sprintf('./ecc.sh %s', str));
    if status == 1
        error('Échec du lancement du shell script.');
    end
    ecc_numbers = textscan(cmdout, '%d %*1d');
    ecc_numbers = ecc_numbers{1}';
    error_bytes = ecc_binary_string(ecc_numbers);
end

% Affiche les numéros en une chaine binaire
function [ ecc_bin ] = ecc_binary_string(numbers)
    ecc_bin = cell(1,numel(numbers));
    for i = 1:numel(numbers)
        ecc_bin{i} = dec2bin(numbers(i), 8);
    end
end

% Séparer une chaine binaire en bytes puis les convertir en entiers
function [ decbytes ] = str2bytes2dec(string)
    bytes = zeros(1, length(string)/8);
    byte = dec2bin(0, 8);
    j = 1;
    k = 1;
    for i = 1:length(string)
        % On sépare par octet de données
        if i > 1 && rem(i, 8) == 1
            j = j + 1;
            k = 1;
        end
        byte(k) =  string(i);
        bytes(j) = bin2dec(byte);
        k = k + 1;
    end
    decbytes = bytes;
end

% Affiche la chaine de données
function print_bytes(data_bytes)
    fprintf('%s', 'ECC data base02 : ');
    for i = 1:length(data_bytes)
        % On sépare par octet de données
        if i > 1 && rem(i, 8) == 1
            fprintf(' ');
        end
        fprintf('%c', data_bytes(i));
    end
    fprintf('\n');
    fprintf('%s', 'ECC data base10 : ');
    for i = 1:17
        byte = '00000000';
        for j = 1:8
            byte(j) = data_bytes(((i * 8) - 8) + j);
        end
        fprintf('%d ', bin2dec(byte));
    end
    fprintf('\n');
end