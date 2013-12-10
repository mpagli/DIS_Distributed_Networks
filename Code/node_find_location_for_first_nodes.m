function [node] = node_find_location_for_first_nodes(node)
%

% Node 1 is always at (0,0)
if node.id == 1
    % Initialize
    node.data{node.id}.path_length = 0;
    node.data{node.id}.position = [0,0];
    
%Node = 2 and known distance to 1
elseif node.id==2 
    if isnan(node.data{2}.distances(1))==0
        if node.data{2}.distances(1) ~= node.data{2}.position(1)
            node = node_update_position(node, node.id, [node.data{2}.distances(1), 0]);
        end
    end
elseif node.id==3
    %Node = 3 and known distance to 1 and 2, and position of 2 known.
    if node.data{3}.distances(1) > 0 && node.data{3}.distances(2) > 0 && any(isnan(node.data{2}.position(:))) == 0
        [xout,yout] = circcirc(0,0,node.data{3}.distances(1),node.data{2}.position(1),node.data{2}.position(2),node.data{3}.distances(2));
        
        if yout(1) > 0
            node = node_update_position(node, node.id, [xout(1), yout(1)]);
        elseif yout(2) > 0
            node = node_update_position(node, node.id, [xout(2), yout(2)]);
        else
            [0,0,node.data{3}.distances(1),node.data{2}.position(1),node.data{2}.position(2),node.data{3}.distances(2)];
        end
    end
end
