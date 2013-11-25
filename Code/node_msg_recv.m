function [node] = node_msg_recv(node, sender_id, message_type, message_data)
fprintf('[node %03d] Message from %d of type ''%s''\n',node.id, sender_id, message_type);

if strcmp(message_type,'distances')
    node = node_update_distances(node, sender_id, message_data);
end

return
