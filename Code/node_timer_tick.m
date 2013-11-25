function [node] = node_timer_tick(node)
fprintf('[node %03d] Timer event\n',node.id);
node=broadcast(node,'distances',[0]);
return
