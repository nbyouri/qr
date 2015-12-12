% Applique le Format String
%  Le format string dépend de la version de la
%  correction d'erreurs utilisée et du masque utilisé
%  une explication détaillée est disponible à 
%  http://www.thonky.com/qr-code-tutorial/format-version-information
function matrix = format_string()
    matrix = ones(21);
    H_0 = [ 0 0 1 0 1 1 0 1 0 0 0 1 0 0 1 ];
    H_1 = [	0 0 1 0 0 1 1 1 0 1 1 1 1 1 0 ];
    H_2 = [	0 0 1 1 1 0 0 1 1 1 0 0 1 1 1 ];
    H_3 = [	0 0 1 1 0 0 1 1 1 0 1 0 0 0 0 ];
    H_4 = [	0 0 0 0 1 1 1 0 1 1 0 0 0 1 0 ];
    H_5 = [ 0 0 0 0 0 1 0 0 1 0 1 0 1 0 1 ];
    H_6 = [ 0 0 0 1 1 0 1 0 0 0 0 1 1 0 0 ];
    H_7	= [ 0 0 0 1 0 0 0 0 0 1 1 1 0 1 1 ];
    
    %  Disposition du format string sur la matrice,
    %  voir http://www.thonky.com/qr-code-tutorial/format-layout.png
    %   Partie 1
    %    Partie de droite
    format = ~fliplr(H_1);
    for i = 1:6
        matrix(i, 9) = format(i);
    end
    %    On passe le timing pattern
    matrix(8,9) = format(7);
    matrix(9,9) = format(8);
    %    Partie du dessous
    matrix(9,8) = format(9);
    %    On passe le timing pattern
    for i = 6:-1:1
        matrix(9,i) = format(16-i);
    end
    
    %   Partie 2
    %    Partie du dessous
    %    On passe le Dark Module
    for i = 15:21
        matrix(i,9) = format((8+i)-14);
    end
    %    Partie de droite
    for i = 21:-1:14
        matrix(9,i) = format(22-i);
    end
end