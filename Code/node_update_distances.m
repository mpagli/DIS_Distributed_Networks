function [node] = node_update_distances(node, node_id, distances)

node.data{node_id}.distances = reshape(distances, [node.N, 1]);
disp(node.data{node_id}.distances');

if node.id == node_id
    node = broadcast(node, 'distances', distances);
end

%node = node_update_robust_quads(node);

return
