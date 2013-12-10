function [pos] = spring_relaxation(pos, other_positions, other_lengths, other_variances)

potential = @(x) spring_relaxation_potential(x, other_positions, other_lengths, other_variances);

origw = warning ('off','optim:fminunc:SwitchingMethod');
pos = fminunc(potential, pos, optimoptions('fminunc','Display','off'));
warning(origw);

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
        x = wanted_length - measured_length;
        k = 1./other_variances(i);
        pot = pot + 0.5*k*x^2;
    end
    return
