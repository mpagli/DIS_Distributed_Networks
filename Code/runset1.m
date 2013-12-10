exps = 1:100;

% number of nodes
l_N = 20;
% minimum connectivity
l_K = [3 5 7 9 11 13 15 17 19];
% average communication radius
l_R = 20;
% proportion of network broadcasting simultaneously
l_F = 0.2;
% maximum number of time-steps
l_t_max = 100;
% percentage, gaussian noise on range measurements
l_noise = 0.1;

%Our parameters
l_d_min_factor = [1];
l_spring_relaxation_factor = [0 0.1];

rng('shuffle');

prefix = 'results/set1/result';

for N = l_N
for K = l_K
for R = l_R

for i = exps

net = f_grow_graph(N,K,R);
saved_rng = rng;

for F = l_F
for t_max = l_t_max
for noise = l_noise
for d_min_factor = l_d_min_factor
for spring_relaxation_factor = l_spring_relaxation_factor



fname = sprintf('%s-%02d-%02d-%02d-%0.2f-%03d-%0.2f-%0.2f-%0.2f-%04d.mat', prefix, N, K, R, F, t_max, noise, d_min_factor, spring_relaxation_factor, i);
fprintf('\n\n%s\n\n', fname);

data = dn_generate_nodes(N, F, d_min_factor, spring_relaxation_factor);
rng(saved_rng);

tic;
[new_data, performance_nodes_localized, performance_norm_ss] = dn_simulate(data, net, t_max, noise);
toc;

save(fname, 'i', 'N', 'K', 'R', 'F', 't_max', 'noise', 'd_min_factor', 'spring_relaxation_factor', 'data', 'new_data', 'saved_rng', 'net');


end; end; end; end; end; end; end; end

end

