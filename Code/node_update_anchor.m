function [node] = node_update_anchor(node, node_id, anchor_data)

node.data{node_id}.anchor = reshape(anchor_data,1,5);

if node.id == node_id
    %node = broadcast(node, 'anchor', anchor_data);
end

node.anchor_changed = true;

return
