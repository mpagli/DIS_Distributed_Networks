function [node] = node_update_position(node, node_id, position)
% [node] = node_update_position(node, node_id, position)
%
% Update node, set position for node_id

if isequal(node.data{node_id}.position, position) || (all(isnan(node.data{node_id}.position)) && all(isnan(position)))
    return
end

node.data{node_id}.position = position;

if node.id == node_id
    %This could be removed, but it messes up with computation of the "real" position if not used
    node = broadcast(node, 'position', position);
end

node.positions_changed = true;

return

