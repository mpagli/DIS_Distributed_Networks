function [node] = node_update_position(node, node_id, position)

node.data{node_id}.position = position;

if node.id == node_id
    node = broadcast(node, 'position', position);
end

return

