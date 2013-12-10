function [node] = node_timer_tick(node)
% node_timer_tick
% Function called at each simulation step, in order to let the node compute its new state.
%
% [node] = node_timer_tick(node)

if node.distances_changed
    node = node_compute_robust_quads(node);
end

%Try to localize
if node.id <= 3
    %The first 3 nodes are special cases.
    node = node_find_location_for_first_nodes(node);
else
    if node.distances_changed || node.robustquads_changed || node.positions_changed
        node = node_find_location(node);
    end
end

if node.spring_relaxation_factor > 0 && sum(sum(isnan(node.data{node.id}.position))) == 0

    my_position = reshape(node.data{node.id}.position,2,1);
    lengths = node.data{node.id}.distances;
    other_ids = find(~isnan(lengths))';
    if ~isempty(other_ids)
        other_positions = [];
        other_lengths = [];
        other_variances = [];
        
        for other_id=other_ids
            if sum(sum(isnan(node.data{other_id}.position))) == 0 && ~isnan(node.data{node.id}.measured_noise(other_id))
                other_lengths = [other_lengths lengths(other_id)];
                other_positions = [other_positions reshape(node.data{other_id}.position,2,1)];
                other_variances = [other_variances node.data{node.id}.measured_noise(other_id)];
            end
        end
        
        new_pos = spring_relaxation(my_position, other_positions, other_lengths, other_variances);
        
        node = node_update_position(node, node.id, (1-node.spring_relaxation_factor)*my_position + node.spring_relaxation_factor * new_pos);
    end
end


%Reset *_changed
node.distances_changed = false;
node.robustquads_changed = false;
node.positions_changed = false;

%Sometimes broadcast data
if rand() < node.broadcast_distance_probability
    node = node_update_distances(node, node.id, node.measured_distances);
    
    %If the path length is known, broadcast it
    if isnan(node.data{node.id}.path_length) == 0
        node = broadcast(node, 'path_length', node.data{node.id}.path_length);
    end
    
    %If our position is known, broadcast it
    if any(isnan(node.data{node.id}.position(:))) == 0
        node = broadcast(node, 'position', node.data{node.id}.position);
    end
end


return
