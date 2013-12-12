% 02.11.2010, Amanda Prorok
% 14.11.2013 Modified, Bahar Haghighat
% DIS mini project - main fucntion
% Make a network of N nodes which each are connected at least K times.
% At every time-step, a proportion of the nodes broadcasts range
% measurements. Each node which sends/receives a measurement must update
% its belief of the network localization.
% 
%%

%clear
close all

%
if exist('saved_rng')
    rng(saved_rng)
else
    saved_rng = rng
end


% Initialize network
N = 20;           % number of nodes
K = 11;            % minimum connectivity
R = 20;           % average communication radius
F = 0.2;          % proportion of network broadcasting simultaneously
t_max = 100;     % maximum number of time-steps
noise = 0.1;      % percentage, gaussian noise on range measurements
d_min_factor = 1.0;
spring_relaxation_factor = 0.0;

%plot_on = true;
plot_on = false;
profile_on = false;

node_list = int32(1:N);

data = dn_generate_nodes(N, F, d_min_factor, spring_relaxation_factor);%, [1,2,3]);


% Create network and plot it
%if(plot_on) fax=gca; else fax=[]; end;

if plot_on
    fax = gca;
    net = f_grow_graph(N,K,R,fax);
else
    net = f_grow_graph(N,K,R);
end
%net = f_regular_net(N,K,R,plot_on,fax);
% LF: commented pause

if profile_on
    profile on;
else
    profile off;
end

tic
if (plot_on)
    [new_data, performance_L, performance_sigma_p, performance_sigma_d] = dn_simulate(data, net, t_max, noise, fax);
else
    [new_data, performance_L, performance_sigma_p, performance_sigma_d] = dn_simulate(data, net, t_max, noise);
end
toc

profile off;
if profile_on
    profview;
end

return

pnl = [];
pnss = [];
for i=0:0.1:1
    rng(saved_rng);
    [new_data, performance_nodes_localized, performance_norm_ss] = dn_simulate(data, net, t_max, noise);
    pnl = [pnl; performance_nodes_localized];
    pnss = [pnss; performance_norm_ss];
end

%figure
%plotyy(iterations, positions_found, iterations, normalized_ss);







