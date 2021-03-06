function [node] = node_update_distances(node, node_id, distances)
% [node] = node_update_distances(node, node_id, distances)
%
% Update node, modify distance estimation for node_id (new measurement: distances)

for i = 1:node.N
    if isnan(distances(i))==0
        node = node_handle_distance_data(node, node_id, i, distances(i));
        node = node_handle_distance_data(node, i, node_id, distances(i));
    end
end
    
%Broadcast RAW data, not average (would mess up with variance calculation)
if node.id == node_id
    node = broadcast(node, 'distances', distances);
end

node.distances_changed = true;

return
