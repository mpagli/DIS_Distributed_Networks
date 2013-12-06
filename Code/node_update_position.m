function [node] = node_update_position(node, node_id, position)

if isequal(node.data{node_id}.position, position)
    return
end

node.data{node_id}.position = position;

if node.id == node_id
    node = broadcast(node, 'position', position);
end

node.positions_changed = true;

return

