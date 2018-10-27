colony_size = 2;
num_angles = 9;
angle_step = 15;

% 0 - Female
% 1 - Male
% Two thirds of the population is Male.
% Create and array of 0's and 1 with 2/3 of the entries filled with 1's
gender = rand(1, colony_size) < 2/3
%gender = ones(1, colony_size)
gender(1) = 1;

% 0 - Hexagon
% 1 - Circle
% 70% of the time we detect the correct shape.
% 70% of the time the second random array will have a 1
% So if the second randome array has a 1
%       Keep the gender unchanged
% Else,
%      Change the gender
% gender    2nd Random Array       Detected Gender
%     0                  0                              1
%     0                  1                              0
%     1                  0                              0
%     1                  1                              1
% This is xnor = not xor
shape = ~xor(gender, rand(1, colony_size) < 0.7)

%sum(shape)
%[~xor(0, 1); ~xor(1, 1); ~xor(0, 0); ~xor(1, 0);]

% Cumulative probabilities for female inner angles
F_CP_RIAA = [0, 0, 1/9, 4/9, 1]
F_CP_RILA = [1/9, 3/9, 6/9, 8/9, 1]

% Cumulative probabilities for male inner angles
M_CP_RIAA = [1/9, 3/9, 6/9, 8/9, 1]
M_CP_RILA = [5/9, 8/9, 1, 0, 0]

% Cumulative probabilities for outer angles
OA = [3/11, 5/11, 6/11, 8/11, 1]

% Angle meassurment error cumulative probabilities
ERR = [0.1, 0.3, 0.7, 0.9, 1]

gender_label = '';

for i = 1 : colony_size
    if gender(i)    % Male
        CP_RIAA = M_CP_RIAA
        CP_RILA = M_CP_RILA
        gender_label = 'Male'
    else                % Female
        CP_RIAA = F_CP_RIAA
        CP_RILA = F_CP_RILA
        gender_label = 'Female'
    end
    
    %a = M_RIAA >= rand()
    %b = M_RILA >= rand()
    
    % Find which cumulative probability bin (index of the array) the random number falls into
    % Since probabilities for bins 1 and 2 are zero, we have to add 2 to
    % find the correct bin
    riaa = find( CP_RIAA >= rand(), 1) + 2
    rila = find( CP_RILA >= rand(), 1) + 2
    
    % Find the left side angles using the symmetry
    liaa = 10 - riaa
    lila = 10 - rila

    % Find the outer angles based on the inner angles
    % Index to the OA cumulative probability maps to the
    % displacement as follows
    % Index:                  1   2  3   4   5
    % Displacement:     -2  -1  0   1   2 
    % Therefore, the displacement = Index - 3
    roaa = riaa + find( OA >= rand(), 1) - 3
    rola = rila + find( OA >= rand(), 1) - 3

    loaa = liaa + find( OA >= rand(), 1) - 3
    lola = lila + find( OA >= rand(), 1) - 3

    % Compute the observed angles
    % Logic here is similar to calculating the outer angles above
    o_riaa = riaa + find( ERR >= rand(), 1) - 3
    o_rila = rila + find( ERR >= rand(), 1) - 3
    o_liaa = liaa + find( ERR >= rand(), 1) - 3
    o_lila = lila + find( ERR >= rand(), 1) - 3

    o_roaa = roaa + find( ERR >= rand(), 1) - 3
    o_rola = rola + find( ERR >= rand(), 1) - 3
    o_loaa = loaa + find( ERR >= rand(), 1) - 3
    o_lola = lola + find( ERR >= rand(), 1) - 3

    if o_roaa > 9
        o_roaa = 9
    elseif o_roaa < 0
        o_roaa = 0
    end

    if o_rola > 9
        o_rola = 9
    elseif o_rola < 0
        o_rola = 0
    end

    if o_loaa > 9
        o_loaa = 9
    elseif o_loaa < 0
        o_loaa = 0
    end

    if o_lola > 9
        o_lola = 9
    elseif o_lola < 0
        o_lola = 0
    end

    idealized = draw_mql(num_angles, angle_step, gender(i) , riaa, rila, liaa, lila, roaa, rola, loaa, lola);
    heading = sprintf( 'Sample %d - Actual %s', i, gender_label);
    title(heading);
    
    file_name = sprintf('%s.png', heading );
    saveas( idealized, file_name );

    observed = draw_mql(num_angles, angle_step, shape(i) , o_riaa, o_rila, o_liaa, o_lila, o_roaa, o_rola, o_loaa, o_lola);
    heading = sprintf( 'Sample %d - Observed %s', i, gender_label);
    title(heading);
    
    file_name = sprintf('%s.png', heading );
    saveas( observed, file_name );
end