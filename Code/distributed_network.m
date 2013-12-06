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

import java.util.LinkedList

%
if exist('saved_rng')
    rng(saved_rng)
else
    saved_rng = rng
end


% Initialize network
N = 20;           % number of nodes
K = 10;            % minimum connectivity
R = 20;           % average communication radius
F = 0.1;          % proportion of network broadcasting simultaneously
t_max = 100;     % maximum number of time-steps
noise = 0.1;      % percentage, gaussian noise on range measurements

%plot_on = true;
plot_on = true;
profile_on = false;

broadcastingNodes = floor(N*F);  % number of simultaneously broadcasting nodes

node_list = int32(1:N);

% Each node stores data
data = cell(N, 1);

% Initialize memory for each node
for i = node_list
    node_data=struct();
    node_data.id = int32(i);
    node_data.N = int32(N);
    node_data.measured_distances = nan(N, 1);
    node_data.broadcast_distance_probability = F;
    node_data.broadcast_probability = 1;
    node_data.outbox = java.util.LinkedList();
    node_data.distances_changed = false;
    node_data.robustquads_changed = false;
    node_data.positions_changed = false;
    
    node_data.d_min_factor = 4; %2-sigmas
    node_data.spring_relaxation_factor = 0.05;
    
    node_data.data = cell(N,1);
    for j = node_list
        node_data.data{j} = struct('distances', nan(N, 1), 'distances_n', zeros(N, 1), 'distances_M2', zeros(N, 1), 'robustquads', nan(0,0), 'position', nan(2,1), 'measured_noise', nan(N, 1), 'path_length', nan(1, 1));
    end
    
    data{i} = node_data;
end


% Create network and plot it
%if(plot_on) fax=gca; else fax=[]; end;
fax = gca;

net = f_grow_graph(N,K,R,plot_on,fax);
%net = f_regular_net(N,K,R,plot_on,fax);
% LF: commented pause

if profile_on
    profile on;
else
    profile off;
end

tic
if (plot_on)
    [data, performance] = dn_simulate(data, net, t_max, noise, fax);
else
    [data, performance] = dn_simulate(data, net, t_max, noise);
end
toc

profile off;
if profile_on
    profview;
end

%figure
%plotyy(iterations, positions_found, iterations, normalized_ss);







