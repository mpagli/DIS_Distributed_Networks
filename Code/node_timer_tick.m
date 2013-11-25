function [node] = node_timer_tick(node)
fprintf('[node %03d] Timer event\n',node.id);

if rand() < node.broadcast_distance_probability
    node = node_update_distances(node, node.id, node.measured_distances);
end

return
