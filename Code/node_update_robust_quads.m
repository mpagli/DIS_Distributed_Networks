function [node] = node_update_robust_quads(node, node_id, robustquads)

node.data{node_id}.robustquads = robustquads;

if node.id == node_id
    node = broadcast(node, 'robustquads', robustquads);
else
    
end
return
