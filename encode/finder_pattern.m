% Applique les Finder patterns
function matrix = finder_pattern()
matrix = ones(21);
for i = [ 1:7 15:21 ]
    for j = [ 1 7 15 21 ]
        % Ne pas dessiner un quatrième carré
        if j >= 8  && i >= 8
            break
        end
        matrix(j,i) = 0;
        matrix(i,j) = 0;
    end
end

% Les cubes pleins à l'intérieur
for i = [ 3:5 17:19 ]
    for j = [ 3:5 17:19 ]
        % Ne pas dessiner un quatrième carré
        if j >= 8  && i >= 8
            break
        end
        matrix(j,i) = 0;
    end
end

end