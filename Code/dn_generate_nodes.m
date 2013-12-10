function [data] = dn_generate_nodes(N, broadcast_distance_probability, d_min_factor, spring_relaxation_factor)

import java.util.LinkedList

% Each node stores data
data = cell(N, 1);

% Initialize memory for each node
for i = 1:N
    node_data=struct();
    node_data.id = int32(i);
    node_data.N = int32(N);
    node_data.measured_distances = nan(N, 1);
    node_data.broadcast_distance_probability = broadcast_distance_probability;
    node_data.broadcast_probability = 1;
    node_data.outbox = java.util.LinkedList();
    node_data.distances_changed = false;
    node_data.robustquads_changed = false;
    node_data.positions_changed = false;
    
    node_data.d_min_factor = d_min_factor;
    node_data.spring_relaxation_factor = spring_relaxation_factor;
    
    node_data.data = cell(N,1);
    for j = 1:N
        node_data.data{j} = struct('distances', nan(N, 1), 'distances_n', zeros(N, 1), 'distances_M2', zeros(N, 1), 'robustquads', nan(0,0), 'position', nan(2,1), 'measured_noise', nan(N, 1), 'path_length', nan(1, 1));
    end
    
    data{i} = node_data;
end
