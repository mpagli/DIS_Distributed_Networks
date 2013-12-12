function [node] = node_timer_tick(node)
% [node] = node_timer_tick(node)
%
% Function called at each simulation step by dn_simulate, in order to let the node compute its new state.
%
% In the real world, this function would called by the main loop of the sensor.

if node.distances_changed
    node = node_compute_robust_quads(node);
end

if ~node.fixed_anchors
    if isnan(node.data{node.id}.anchor(1)) || node.data{node.id}.anchor(1)==node.id
        my_anchor = [node_compute_anchor_score(node) 0];
        node = node_update_anchor(node, node.id, my_anchor);
    end
end
    

if node.anchor_changed
    selected_anchor = node.id;
    
    for i = 1:node.N
        if i~=node.id
            %compare score
            if node.data{i}.anchor(4) > node.data{selected_anchor}.anchor(4) || (isequal(node.data{i}.anchor(1:3), node.data{selected_anchor}.anchor(1:3)) && node.data{i}.anchor(5) < node.data{selected_anchor}.anchor(5))
                selected_anchor = i;
            end
        end
    end
    if selected_anchor ~= node.id
        coordinates_changed = ~isequal(node.data{node.id}.anchor(1:3), node.data{selected_anchor}.anchor(1:3));
        if coordinates_changed
            node = node_update_position(node, node.id, [nan nan]);
        end
        node.data{node.id}.anchor = node.data{selected_anchor}.anchor;
        node.data{node.id}.anchor(5) = node.data{node.id}.anchor(5) + 1;
        node.anchor_changed = false;
    end
end

%Try to localize
if node.anchor > 0
    %The first 3 nodes are special cases.
    node = node_find_location_for_first_nodes(node);
else
    if node.distances_changed || node.robustquads_changed || node.positions_changed
        node = node_find_location(node);
    end
end

%Compute spring relaxation if needed
if node.spring_relaxation_factor > 0 && sum(sum(isnan(node.data{node.id}.position))) == 0
    my_position = reshape(node.data{node.id}.position,2,1);
    lengths = node.data{node.id}.distances;
    other_ids = find(~isnan(lengths))';
    
    if ~isempty(other_ids)
        %Build a list of neighbors
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
        
        %Compute the optimal position
        new_pos = spring_relaxation(my_position, other_positions, other_lengths, other_variances);
        
        %Then update the position with an affine combination of the points and the optimal position (avoid oscillation)
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
    
    %If our position is known, broadcast it
    if any(isnan(node.data{node.id}.position(:))) == 0
        node = broadcast(node, 'position', node.data{node.id}.position);
    end
    
    %Broadcast anchor
    node = broadcast(node, 'anchor', node.data{node.id}.anchor);
end


return
