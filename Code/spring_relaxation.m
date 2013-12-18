function [pos] = spring_relaxation(pos, other_positions, other_lengths, other_variances)
% [pos] = spring_relaxation(pos, other_positions, other_lengths, other_variances)
%
% Find the minimum of the potential for spring relaxation. Rigidity of springs is set to be the inverse of the variance.
%
% Parameters:
%  - pos: position of the central node
%  - other_positions: 2xN matrix of position of other nodes
%  - other_lengths: N-vector, length between other nodes and the central node
%  - message_data: N-vector, variance of the length between other nodes and the central node
%
% Output values:
%  - pos: (local) minimum of the potential

potential = @(x) spring_relaxation_potential(x, other_positions, other_lengths, other_variances);

origw = warning ('off','optim:fminunc:SwitchingMethod');
pos = fminunc(potential, pos, optimset('Display','off'));
warning(origw);
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
