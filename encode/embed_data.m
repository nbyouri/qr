% Ins�re les donn�es du message et les donn�es de correction d'erreurs
% En QRv1-H on � 9 bytes de message et 17 bytes de correction d'erreurs
% Les donn�es sont agenc�es comme le montre docs/bytes_disposition.png
% 
function [ grid ] = embed_data(mat, msg_data, ec_data)
    % Blocs de donn�es. 9 blocs de 8 bits, incluant le mode, le nombre de 
    % caract�res et le end block. On acc�de aux cellules de la matrice en
    % abcisse puis en ordonn�e. On commence par le premier byte en bas � droite
    %   Bit courant de la chaine binaire du message
    cbit = 1;
    
    %   Direction upwards
    %       Bloc de donn�es 0.5/26 bytes : Mode sur 4 bits
    x = 21;
    for y = 21:-1:20
        mat(y,x) = get_bit(msg_data, cbit);
        cbit = cbit + 1;
        mat(y,x-1) = get_bit(msg_data, cbit);
        cbit = cbit + 1;
    end
    
    %       Bloc de donn�es 1.5/26 : Taille du message sur 8 bits
    for y = 19:-1:16
        mat(y,x) = get_bit(msg_data, cbit);
        cbit = cbit + 1;
        mat(y,x-1) = get_bit(msg_data, cbit);
        cbit = cbit + 1;
    end
    
    %       Bloc de donn�es 2.5/26 : Premier byte : D1
    for y = 15:-1:12
        mat(y,x) = get_bit(msg_data, cbit);
        cbit = cbit + 1;
        mat(y,x-1) = get_bit(msg_data, cbit);
        cbit = cbit + 1;
    end
    
    %   Direction horizontale par le haut
    %       Bloc de donn�es 3.5/26 : D2
    y = 11;
    for x = [ 21 19 ]
        mat(y,x) = get_bit(msg_data, cbit);
        cbit = cbit + 1;
        mat(y,x-1) = get_bit(msg_data, cbit);
        cbit = cbit + 1;
        mat(y-1,x) = get_bit(msg_data, cbit);
        cbit = cbit + 1;
        mat(y-1,x-1) = get_bit(msg_data, cbit);
        cbit = cbit + 1;
    end
    
    %   Direction downwards
    %       Bloc de donn�es 4.5/26 : D3
    for y = 12:15
        mat(y,x) = get_bit(msg_data, cbit);
        cbit = cbit + 1;
        mat(y,x-1) = get_bit(msg_data, cbit);
        cbit = cbit + 1;
    end
    
    %       Bloc de donn�es 5.5/26 : D4
    for y = 16:19
        mat(y,x) = get_bit(msg_data, cbit);
        cbit = cbit + 1;
        mat(y,x-1) = get_bit(msg_data, cbit);
        cbit = cbit + 1;
    end
    
    %   Direction horizontale par le bas
    %       Bloc de donn�es 6.5/26 : D5
    y = 21;
    x = 19;
    mat(y-1,x) = get_bit(msg_data, cbit);
    cbit = cbit + 1;
    mat(y-1,x-1) = get_bit(msg_data, cbit);
    cbit = cbit + 1;
    mat(y,x) = get_bit(msg_data, cbit);
    cbit = cbit + 1;
    mat(y,x-1) = get_bit(msg_data, cbit);
    cbit = cbit + 1;
    
    x = 17;
    mat(y,x) = get_bit(msg_data, cbit);
    cbit = cbit + 1;
    mat(y,x-1) = get_bit(msg_data, cbit);
    cbit = cbit + 1;
    mat(y-1,x) = get_bit(msg_data, cbit);
    cbit = cbit + 1;
    mat(y-1,x-1) = get_bit(msg_data, cbit);
    cbit = cbit + 1;
        
    %   Direction upwards
    %       Bloc de donn�es 7.5/26 : D6
    for y = 19:-1:16
        mat(y,x) = get_bit(msg_data, cbit);
        cbit = cbit + 1;
        mat(y,x-1) = get_bit(msg_data, cbit);
        cbit = cbit + 1;
    end
    
    %       Bloc de donn�es 8.5/26 : D7
    for y = 15:-1:12
        mat(y,x) = get_bit(msg_data, cbit);
        cbit = cbit + 1;
        mat(y,x-1) = get_bit(msg_data, cbit);
        cbit = cbit + 1;
    end
    
    %       Fin des donn�es, 9/26 : end block
    for y = [ 11 10 ]
        mat(y,x) = get_bit(msg_data, cbit);
        cbit = cbit + 1;
        mat(y,x-1) = get_bit(msg_data, cbit);
        cbit = cbit + 1;
    end
    
    % Blocs de correction d'erreurs, pour �crire un code plus concis on
    % fait colonne par colonne ici en partant par la droite en haut.
    %   Direction downwards, colonne 1 : E1,E2,E3 : 12/26
    cbit = 1;
    x = 15;
    for y = 10:21
        mat(y,x) = get_bit(ec_data, cbit);
        cbit = cbit + 1;
        mat(y,x-1) = get_bit(ec_data, cbit);
        cbit = cbit + 1;
    end
    
    %   Direction upwards, colonne 2 : E4,E5,E6,E7,E8 : 17/26
    x = 13;
    for y = 21:-1:1
        if y == 7
            continue;
        end
        mat(y,x) = get_bit(ec_data, cbit);
        cbit = cbit + 1;
        mat(y,x-1) = get_bit(ec_data, cbit);
        cbit = cbit + 1;
    end
    
    %   Direction downwards, colonne 3 : E9,E10,E11,12,E13 : 22/26
    x = 11;
    for y = 1:21
        % skip le Timing pattern
        if y == 7
            continue;
        end
        mat(y,x) = get_bit(ec_data, cbit);
        cbit = cbit + 1;
        mat(y,x-1) = get_bit(ec_data, cbit);
        cbit = cbit + 1;
    end

    %   Direction upwards, colonne 4 : E14 : 23/26
    x = 9;
    for y = 13:-1:10
        mat(y,x) = get_bit(ec_data, cbit);
        cbit = cbit + 1;
        mat(y,x-1) = get_bit(ec_data, cbit);
        cbit = cbit + 1;
    end
    
    %   Direction downwards, colonne 5 : E15 : 24/26
    %       skip Timing Pattern
    x = 6;
    for y = 10:13
        mat(y,x) = get_bit(ec_data, cbit);
        cbit = cbit + 1;
        mat(y,x-1) = get_bit(ec_data, cbit);
        cbit = cbit + 1;
    end
    
    %   Direction upwards, colonne 6 : E16 : 25/26
    x = 4;
    for y = 13:-1:10
        mat(y,x) = get_bit(ec_data, cbit);
        cbit = cbit + 1;
        mat(y,x-1) = get_bit(ec_data, cbit);
        cbit = cbit + 1;
    end
    
    %   Direction downwards, colonne 7 : E17 : 26/26, total de 72 bits
    x = 2;
    for y = 10:13
        mat(y,x) = get_bit(ec_data, cbit);
        cbit = cbit + 1;
        mat(y,x-1) = get_bit(ec_data, cbit);
        cbit = cbit + 1;
    end
    
    %   Inversion des bits du champs sup�rieur
    %   XXX b�rk
    for y = 1:6
        for x = 10:13
            mat(y,x) = ~mat(y,x);
        end
    end
    
    grid = mat;
end

% R�cup�re un bit de la chaine de donn�es en bit
function bit = get_bit(string, pos) 
    bit = ~str2double(string(pos));
end