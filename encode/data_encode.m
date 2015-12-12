% La s�quence de bits de donn�es utilisateur contient le mode
% mode = 0010 en mode alphanum�rique (0->9, a->z, ...) sur 4 bits
% et le nombre de caract�res du message, maximum 10 pour QRv1
% 'ephec' = 000000101, sur 9 bits
% puis sont les caract�res, somme des valeurs num�riques de couples de caract�res 
% 'ep' = (14x45+25), 'he' = (17x45+14), 'c' = (12x45+0)
% 45 fait partie de la sp�cification QR.
% 'ep' = 01010001111, 'he' = 01100001011, 'c' = 01000011100', sur 11 bits
% la table des valeurs alphanum�riques: http://www.thonky.com/qr-code-tutorial/alphanumeric-table
% on rajoute ensuite un terminator de 0000 si la chaine de donn�es est plus
% de 4 bits de trop peu.
% puis en rajoute des 0 jusqu'a ce que la chaine soit un multiple de 8
% Puis on rajoute une chaine de padding jusqu'a ce que la chaine de donn�es
% soit pleine, pour le QRv1-H, c'est 72 bits. 
% La sp�cification QR indique que la chaine de padding finale doit �tre
% 11101100 00010001.
function [ data_bytes ] = data_encode(string)  
    validate_alphanum(string);
 
    % Le tableau de bits de data de 72 caract�res
    data_bytes = sprintf('%072d', 0);
    
    % Le mode 2 alphanum�rique doit �tre repr�sent� en binaire sur 4 bits
    mode = dec2bin(2,4);
    for i = 1:4
       data_bytes(i) = mode(i);
    end
    
    % Le nombre de caract�res du message doit �tre repr�sent� sur 9 bits
    nbcar = dec2bin(length(string), 9);
    j = 1;
    for i = 5:13
        data_bytes(i) = nbcar(j);
        j = j + 1;
    end
    
    % Calcul du message avec les valeurs alphanum�riques comme expliqu� au
    % d�but du fichier
    alphanum_values = zeros(1, ceil(length(string)/ 2));
    
    j = 1;
    for i = 1:2:length(string)
        if rem(length(string), 2) == 1 && i == length(string)
            alphanum_values(j) = ((get_alphanumeric_value(string(i))) * 45);
        else
            alphanum_values(j) = ((get_alphanumeric_value(string(i))) * 45) + get_alphanumeric_value(string(i + 1));
        end
        j = j + 1;
    end
        
    % Insertion des bits du message sur 11 bits par couple de caract�res �
    % partir de la position 14, apr�s le mode et ncar
    j = 1;
    k = 1;
    for i = 1:(11*length(alphanum_values))
        bin = dec2bin(alphanum_values(j), 11);
        data_bytes(13 + i) = bin(k);
        k = k + 1;
   
        % Tous les multiples de 11, on passe au prochain couple de
        % caract�res du message
        if rem(k, 11) == 1
            j = j + 1;
            k = 1;
        end
    end
    
    % La position apr�s le mode, le ncar et le message
    position = i+13;
    
    % Ajout du terminator de maximum 4 bits
    % si on arrive pas au nombre de bits demand�, ici 72 bits car QRv1-H
    for i = 1:4
        if position < 72
            data_bytes(position) = '0';
            position = position + 1;
        end
    end
        
    % Ajout de 0 jusqu'a ce que la position soit un multiple de 8
    while mod(position, 8) ~= 0
        % Attention � ne pas d�passer le nombre max de donn�es pour notre
        % QRv1-H, 72
        if position == 72
            break
        end
        data_bytes(position) = '0';
        position = position + 1;
    end
    
    position = position + 1;
    
    % Ajout de la s�quence de padding r�p�t�e jusque max de donn�es
    % remplies, 72. La s�quence est 11101100 00010001, comme sp�cifi�.
    seq = '1110110000010001';
    i = 1;
    while position <= 72
        data_bytes(position) = seq(i);
        i = i + 1;
        if (i > length(seq))
            i = 1;
        end
        position = position + 1;
    end
       
    print_bytes(data_bytes);
end

% Tableau de valeurs alphanum�riques, find(alphanum == 'X') - 1 retourne
% l'index qui repr�sente la valeur num�rique, pas de distinction entre
% lettres minuscules/majuscules
function x = get_alphanumeric_value(c)
    alphanum = ['0':'9', 'a':'z', ' ', '$', '%', '*', '+', '-', '.', '/', ':'];
    x = (find(alphanum == lower(c)) - 1);
end


% Affiche la chaine de donn�es
function print_bytes(data_bytes)
    for i = 1:length(data_bytes)
        % On s�pare par octet de donn�es
        if i > 1 && rem(i, 8) == 1
            fprintf(' ');
        end
        fprintf('%c', data_bytes(i));
    end
    fprintf('\n');
end

% Valide la chaine en entr�e
function validate_alphanum(string)
    alphanum = ['0':'9', 'a':'z', ' ', '$', '%', '*', '+', '-', '.', '/', ':'];
    for i = 1:length(string)
        result = find(alphanum == string(i));
        if isempty(result)
            error('Chaine pas enti�rement alphanum�rique!');
        end
    end
end