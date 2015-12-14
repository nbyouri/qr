% La s�quence de bits de donn�es utilisateur contient le mode
% mode = 0100 , mode byte sur 4 bits
% et le nombre de caract�res du message, maximum 7 pour QRv1
% 'ephec' = 00000101, sur 8 bits
% puis sont les caract�res, valeur num�rique ascii
% 'e' = '01100101' sur 8 bits
% la table ascii: http://www.asciitable.com/
% on rajoute ensuite un terminator de 0 � 4 0 pour compl�ter le byte
% On rajoute ensuite une chaine de padding jusqu'a ce que la chaine de donn�es
% soit pleine, pour le QRv1-H, c'est 72 bits. 
% La sp�cification QR indique que la chaine de padding final doit �tre
% 11101100 00010001.
function [ data_bytes ] = data_encode(string)  
    % Le tableau de bits de data de 72 caract�res
    data_bytes = sprintf('%072d', 0);
    
    % Le mode 4 byte doit �tre repr�sent� en binaire sur 4 bits
    mode = dec2bin(4,4);
    for i = 1:4
       data_bytes(i) = mode(i);
    end
    
    % Le nombre de caract�res du message doit �tre repr�sent� sur 8 bits
    nbcar = dec2bin(length(string), 8);
    j = 1;
    for i = 5:12
        data_bytes(i) = nbcar(j);
        j = j + 1;
    end
    
    % Calcul du message avec les valeurs alphanum�riques comme expliqu� au
    % d�but du fichier
    ascii_values = zeros(1, length(string));
    
    for i = 1:length(string)
        ascii_values(i) = get_ascii_value(string(i));
    end
            
    % Insertion des bits du message sur 8 bits par couple de caract�res �
    % partir de la position 14, apr�s le mode et ncar
    j = 1;
    k = 1;
    for i = 1:(8*length(ascii_values))
        bin = dec2bin(ascii_values(j), 8);
        data_bytes(12 + i) = bin(k);
        k = k + 1;
   
        % Tous les multiples de 8, on passe au prochain couple de
        % caract�res du message
        if rem(k, 8) == 1
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
    
    position = position - 1;
    
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
    get_dec_bytes(data_bytes);
end

% Retourne la valeur num�rique d'un caract�re ASCII
function x = get_ascii_value(c)
    hex = sprintf('%x', c);
    x = hex2dec(hex);
end


% Affiche la chaine de donn�es
function print_bytes(data_bytes)
    fprintf('%s', 'Message data base02 : ');
    for i = 1:length(data_bytes)
        % On s�pare par octet de donn�es
        if i > 1 && rem(i, 8) == 1
            fprintf(' ');
        end
        fprintf('%c', data_bytes(i));
    end
    fprintf('\n');
end

% Extrait des d�cimales de bytes de la chaine
function get_dec_bytes(data_bytes)
    fprintf('%s', 'Message data base10 : ');
    for i = 1:9
        binstr = '00000000';
        for j = 1:8
            binstr(j) = data_bytes(((i * 8) - 8) + j);
        end
        fprintf('%d ', bin2dec(binstr));
    end
    fprintf('\n');
end