function [node] = node_update_distances(node, node_id, distances)

node.data{node_id}.distances = reshape(distances, [node.N, 1]);
%disp(node.data{node_id}.distances');

if node.id == node_id
    node = broadcast(node, 'distances', distances);
else
    %Get symmetric distance
    node.data{node.id}.distances(node_id) = node.data{node_id}.distances(node.id);
end

node = node_compute_robust_quads(node);

return
