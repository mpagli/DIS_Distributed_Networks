N = 20;           % number of nodes
K = 10;            % minimum connectivity
R = 20;           % average communication radius
F = 0.1;          % proportion of network broadcasting simultaneously
t_max = 100;     % maximum number of time-steps
noise = 0.1;      % percentage, gaussian noise on range measurements

d_min_factor = 0.5;
spring_relaxation_factor = 0;

saved_rng = rng;

fax = gca;
net = f_grow_graph(N,K,R);

pnl = [];
pnss = [];

nexp = 9;
expspace = linspace(0,3,nexp);

for d_min_factor = expspace
    fprintf('\n\nd_min_factor = %f\n\n', d_min_factor);
    
    tic;
    data = dn_generate_nodes(N, F, d_min_factor, spring_relaxation_factor);
    rng(saved_rng);
    [new_data, performance_nodes_localized, performance_norm_ss] = dn_simulate(data, net, t_max, noise);
    toc;
    
    pnl = [pnl; performance_nodes_localized];
    pnss = [pnss; performance_norm_ss];
end

mpnl = max(pnl');
exptoplot = [];
for i = 1:nexp
    if mpnl(i) <= 3
        fprintf('%f did not converge\n', expspace(i));
    else
        exptoplot = [exptoplot i];
    end
end

leg={};
for i=exptoplot
    leg{i} = sprintf('%f', expspace(i));
end

clf
subplot(211)
plot(1:t_max, pnl(exptoplot,:));
legend(leg);
    
subplot(212)
plot(1:t_max, pnss(exptoplot,:));
legend(leg);
