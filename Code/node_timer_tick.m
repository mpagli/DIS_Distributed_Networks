function [node] = node_timer_tick(node)
%fprintf('[node %03d] Timer event\n',node.id);

if node.distances_changed
    node = node_compute_robust_quads(node);
end

%Check if we can update the position in special cases
if node.id == 1
    % Initialize
    node.data{node.id}.path_length = 0;
    node.data{node.id}.position = [0,0];
    
%Node = 2 and known distance to 1
elseif node.id==2 
    if isnan(node.data{2}.distances(1))==0
        if node.data{2}.distances(1) ~= node.data{2}.position(1)
            node = node_update_position(node, node.id, [node.data{2}.distances(1), 0]);
        end
    end
elseif node.id==3
    %Node = 3 and known distance to 1 and 2, and position of 2 known.
    if node.data{3}.distances(1) > 0 && node.data{3}.distances(2) > 0 && any(isnan(node.data{2}.position(:))) == 0
        [xout,yout] = circcirc(0,0,node.data{3}.distances(1),node.data{2}.position(1),node.data{2}.position(2),node.data{3}.distances(2));
        
        if yout(1) > 0
            node = node_update_position(node, node.id, [xout(1), yout(1)]);
        elseif yout(2) > 0
            node = node_update_position(node, node.id, [xout(2), yout(2)]);
        else
            [0,0,node.data{3}.distances(1),node.data{2}.position(1),node.data{2}.position(2),node.data{3}.distances(2)];
        end
    end
else
    % Try to localize
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
