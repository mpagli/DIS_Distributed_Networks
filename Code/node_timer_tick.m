function [node] = node_timer_tick(node)
%fprintf('[node %03d] Timer event\n',node.id);

if node.id == 1
    % Initialize
    node.data{node.id}.path_length = 0;
    node.data{node.id}.position = [0,0];
end

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
