% Applique les Timing patterns
function matrix = timing_pattern()
    matrix = ones(21);
    for i  = [ 9 11 13 ]
        matrix(i, 7) = 0;
        matrix(7, i) = 0;
    end
end