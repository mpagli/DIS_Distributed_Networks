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

%Check if we can update the position in special cases

node=node_find_location(node);

%Node = 2 and known distance to 1
if node.id==2 && isnan(node.data{2}.distances(1))==0
    if node.data{2}.distances(1) ~= node.data{2}.position(1)
        node = node_update_position(node, node.id, [node.data{2}.distances(1), 0]);
    end
end
    
%Node = 3 and known distance to 1 and 2, and position of 2 known.
if node.id==3 && node.data{3}.distances(1) > 0 && node.data{3}.distances(2) > 0 && any(isnan(node.data{2}.position(:))) == 0
    [xout,yout] = circcirc(0,0,node.data{3}.distances(1),node.data{2}.position(1),node.data{2}.position(2),node.data{3}.distances(2));
    
    if yout(1) > 0
        node = node_update_position(node, node.id, [xout(1), yout(1)]);
    elseif yout(2) > 0
        node = node_update_position(node, node.id, [xout(2), yout(2)]);
    else
        [0,0,node.data{3}.distances(1),node.data{2}.position(1),node.data{2}.position(2),node.data{3}.distances(2)];
    end
end

return
