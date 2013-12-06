function [node] = node_msg_recv(node, sender_id, message_type, message_data)
%fprintf('[node %03d] Message from %d of type ''%s''\n',node.id, sender_id, message_type);

if strcmp(message_type,'distances')
    node = node_update_distances(node, sender_id, message_data);
elseif strcmp(message_type,'robustquads')
    node = node_update_robust_quads(node, sender_id, message_data);
elseif strcmp(message_type,'position')
    node = node_update_position(node, sender_id, message_data);
elseif strcmp(message_type,'path_length')
    node.data{sender_id}.path_length = message_data;
    if isnan(node.data{node.id}.path_length) || node.data{node.id}.path_length > message_data + 1
        node.data{node.id}.path_length = message_data + 1;
    end
end

return
