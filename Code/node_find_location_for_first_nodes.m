function [node] = node_find_location_for_first_nodes(node)
%
anchor1 = node.data{node.id}.anchor(1);
anchor2 = node.data{node.id}.anchor(2);
anchor3 = node.data{node.id}.anchor(3);

% Node 1 is always at (0,0)
if node.anchor == 1
    % Initialize
    node.data{node.id}.path_length = 0;
    node.data{node.id}.position = [0,0];
    
%Node = 2 and known distance to 1
elseif node.anchor==2 
    if isnan(node.data{anchor2}.distances(anchor1))==0
        if node.data{anchor2}.distances(anchor1) ~= node.data{anchor2}.position(1)
            node = node_update_position(node, node.id, [node.data{anchor2}.distances(anchor1), 0]);
        end
    end
elseif node.anchor==3
    %Node = 3 and known distance to 1 and 2, and position of 2 known.
    if node.data{anchor3}.distances(anchor1) > 0 && node.data{anchor3}.distances(anchor2) > 0 && any(isnan(node.data{anchor2}.position(:))) == 0
        [xout,yout] = circcirc(0,0,node.data{anchor3}.distances(anchor1),node.data{anchor2}.position(1),node.data{anchor2}.position(2),node.data{anchor3}.distances(anchor2));
        
        if yout(1) > 0
            node = node_update_position(node, node.id, [xout(1), yout(1)]);
        elseif yout(2) > 0
            node = node_update_position(node, node.id, [xout(2), yout(2)]);
        else
            [0,0,node.data{anchor3}.distances(anchor1),node.data{anchor2}.position(1),node.data{anchor2}.position(2),node.data{anchor3}.distances(anchor2)];
        end
    end
end
