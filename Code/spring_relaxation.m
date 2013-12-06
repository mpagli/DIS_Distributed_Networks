function [pos] = spring_relaxation(pos, other_positions, other_lengths, other_variances)

potential = @(x) spring_relaxation_potential(x, other_positions, other_lengths, other_variances);


pos = fminunc(potential, pos);

%pos
%other_positions
%other_lengths
%other_variances
return

function [pot] = spring_relaxation_potential(x, other_positions, other_lengths, other_variances)
    N = size(other_positions, 2);
    pot = 0;
    for i = 1:N
        measured_vec = x - other_positions(:,i);
        measured_length = norm(measured_vec);
        wanted_length = other_lengths(i);
        pot = pot + abs(wanted_length - measured_length)./other_variances(i);
    end
    return
