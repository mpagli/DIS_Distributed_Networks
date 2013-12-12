function [data] = dn_generate_nodes(N, broadcast_distance_probability, d_min_factor, spring_relaxation_factor)
% [data] = dn_generate_nodes(N, broadcast_distance_probability, d_min_factor, spring_relaxation_factor)
%
% Generate a cell array of nodes.
%
% Parameters:
%  - N: number of nodes
%  - broadcast_distance_probability: probability to broadcast the distance at each iteration
%  - d_min_factor: d_min factor as described in the paper, part 2.1, eq (2)
%  - spring_relaxation_factor: factor used for the affine combination between the point computed by this paper, and the one obtained by spring relaxation.
%      A factor of 0 means that spring relaxation won't be used, as a factor of 1 will make the node only use results from spring relaxation as soon as the first localization is found.
%
% Output:
%  - data: cell array of nodes (Nx1), each node is a struct

import java.util.LinkedList

% Each node stores data
data = cell(N, 1);

use_anchors = false;
default_anchors = [1 2 3];

% Initialize memory for each node
for i = 1:N
    node_data=struct();
    node_data.id = int32(i); %Node id
    node_data.N = int32(N); %Total number of node
    node_data.measured_distances = nan(N, 1); %measured distances (updated at each time step by the simulator)
    node_data.broadcast_distance_probability = broadcast_distance_probability; %Probability of broadcasting position estimates, distances, and path length
    node_data.outbox = java.util.LinkedList(); %Queue of messages waiting to be sent
    node_data.distances_changed = false; %Received a message changing distances of a neighbor?
    node_data.robustquads_changed = false; %Received a message changing robust quads of a neighbor?
    node_data.positions_changed = false; %Received a message changing position of a neighbor?
    
    node_data.d_min_factor = d_min_factor;
    node_data.spring_relaxation_factor = spring_relaxation_factor;
    
    %0: not an anchor
    %1 anchor for first node
    %2 anchor for second node
    %3 anchor for third node
    node_data.anchor = 0;
    node_data.use_anchors = use_anchors;
    
    node_data.data = cell(N,1);
    for j = 1:N
        %Data for each node.
        %distances: estimated distance to that node
        %distances_n: number of distance measurements to that node
        %distances_M2: second statistical moment for the measure of distances
        %robustquads: list of robust quads containing the node. Each row is a robust quads, and is sorted wrt to node id
        %position: estimate of the position of the node
        %measured_noise: estimate of the noise in the measurement between the nodes
        %path_length: shortest path length from point 1 to this one.
        node_data.data{j} = struct('distances', nan(N, 1), 'distances_n', zeros(N, 1), 'distances_M2', zeros(N, 1), 'robustquads', nan(0,0), 'position', nan(2,1), 'measured_noise', nan(N, 1), 'path_length', nan(1, 1), 'anchor', nan(1,5));
    end
    
    if ~use_anchors
        node_data.anchor = find(default_anchors==i);
        if isempty(node_data.anchor)
            node_data.anchor = 0;
        end
        %node_data.data{i}.anchor: [anchor1 anchor2 anchor3 score distance]
        if i == default_anchors(1)
            node_data.data{i}.anchor=[default_anchors, Inf, 0];
        else
            node_data.data{i}.anchor=[default_anchors, Inf, Inf];
        end
    end
    
    
    data{i} = node_data;
end
