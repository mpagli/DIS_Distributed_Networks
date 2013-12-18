function [node] = node_msg_recv(node, sender_id, message_type, message_data)
% [node] = node_msg_recv(node, sender_id, message_type, message_data)
%
% Callback to receive a message. Will dispatch data to the correct function.
%
% Called by dn_simulate.
%
% Parameters:
%  - node
%  - sender_id: id of the node who sent the message
%  - message_type: type of the message ('distances', 'robustquads', 'position', 'anchor')
%  - message_data: contents of the message
%
% Output values:
%  - node (updated)

if strcmp(message_type,'distances')
    node = node_update_distances(node, sender_id, message_data);
elseif strcmp(message_type,'robustquads')
    node = node_update_robust_quads(node, sender_id, message_data);
elseif strcmp(message_type,'position')
    node = node_update_position(node, sender_id, message_data);
elseif strcmp(message_type,'anchor')
    node = node_update_anchor(node, sender_id, message_data);
end

return
