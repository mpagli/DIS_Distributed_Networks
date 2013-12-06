function [node] = node_update_robust_quads(node, node_id, robustquads)

if isequal(node.data{node_id}.robustquads, robustquads)
    return;
end

node.data{node_id}.robustquads = robustquads;

if node.id == node_id
    node = broadcast(node, 'robustquads', robustquads);
    node.robustquads_changed = true;
end


