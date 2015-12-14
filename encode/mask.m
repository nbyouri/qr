% Masque 1 supporté seulement pour l'instant. Le calcul du masque approprié
% sera pour plus tard.  Le masque 1 est (row) mod 2 == 0
% Pour plus d'informations, http://www.thonky.com/qr-code-tutorial/data-masking
% Voir docs/bytes_masks.png
function mat = mask(mat)
    fprintf('Application du masque 1\n');
    % Application du masque 1
    %   zone du dessus
    for y = [ 2 4 6 9 ]
        for x = 10:13
            mat(y,x) = ~mat(y,x);
        end
    end
    
    %   zone de gauche
    for y = 10:13
        if mod(y + 1, 2) == 0
            for x = 1:9
                if x == 7
                    continue
                end
                mat(y,x) = ~mat(y,x);
            end
        end
    end
    
    %   zone de droite et centrale
    for y = 10:21
        if mod(y + 1, 2) == 0
            for x = 10:21
                mat(y,x) = ~mat(y,x);
            end
        end
    end
end

% Masque la donnée selon le type
%function do_mask(type)
%    switch type
%end