% 02.11.2010, Amanda Prorok
% 14.11.2013 Modified, Bahar Haghighat
% DIS mini project - main fucntion
% Make a network of N nodes which each are connected at least K times.
% At every time-step, a proportion of the nodes broadcasts range
% measurements. Each node which sends/receives a measurement must update
% its belief of the network localization.
% 
%%

clear
close all

import java.util.LinkedList


% Initialize network
N = 10;           % number of nodes
K = 3;            % minimum connectivity
R = 20;           % average communication radius
F = 0.1;          % proportion of network broadcasting simultaneously
t_max = 100;       % maximum number of time-steps
noise = 0.1;      % percentage, gaussian noise on range measurements

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
    
    node_data.data = cell(N,1);
    for j = node_list
        node_data.data{j} = struct('distances', nan(N, 1), 'robustquads', nan(0,0), 'position', nan(2,1));
    end
    
    data{i} = node_data;
end


% Create network and plot it
plot_on = true;
if(plot_on) fax=gca; else fax=[]; end;


net = f_grow_graph(N,K,R,plot_on,fax);
% LF: commented pause
    

% Start time (run until t_max)
for t = 1:t_max
    %Add noise to distances
    noisy_distances = net.dist .* ( 1 + (noise .* randn(N,N)));
    
    %Set unmeasurable  (not neighbors) distances to NaN
    noisy_distances = noisy_distances + 0./(net.neighborhood == 1);
    
    %Update measured distances for all nodes
    for i = node_list
        data{i}.measured_distances = noisy_distances(i,:);
    end
    
    %Call timer tick for every node
    for i = node_list
        data{i} = node_timer_tick(data{i});
    end
    
    %Send broadcasts to neighboring nodes
    for i = node_list
        while data{i}.outbox.size > 0
            message_type = data{i}.outbox.remove();
            message_data = data{i}.outbox.remove();
            for j = find(net.neighborhood(i,:) == 1)
                data{j} = node_msg_recv(data{j}, i, message_type, message_data);
            end
        end
    end
    
    %f_draw_network(fax,net,comm);
    %return;
end










