function [node] = node_update_robust_quads(node, node_id, robustquads)
% [node] = node_update_robust_quads(node, node_id, robustquads)
%
% Update node, set robust quadrilaterals for node_id

if isequal(node.data{node_id}.robustquads, robustquads)
    return;
end

node.data{node_id}.robustquads = robustquads;

if node.id == node_id
    node = broadcast(node, 'robustquads', robustquads);
    node.robustquads_changed = true;
end


