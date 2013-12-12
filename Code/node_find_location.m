%% Locate the node 
function [node] = node_find_location(node)

robustquads = node.data{node.id}.robustquads;

%No robust quads: impossible to localize
if isequal(robustquads,[]) == 1
    return;
end

%Compute quads score (the higher, the better)
quadsscore = [];

for i = 1:size(robustquads,1)
    nqs = 0;
    for j = 1:4
        if node.data{robustquads(i,j)}.anchor(1:3) ~= node.data{node.id}.anchor(1:3)
            nqs = nqs - Inf;
        elseif robustquads(i,j) == node.id
            nqs = nqs; % no change
        else
            nqs = nqs - node.data{robustquads(i,j)}.anchor(5);
            if any(isnan(node.data{robustquads(i,j)}.position));
                nqs = nqs - Inf;
            end
            %Bonus if we're on an anchor
            if any(node.data{node.id}.anchor == robustquads(i,j))
                nqs = nqs + 1;
            end
        end
    end
    
    quadsscore = [quadsscore nqs];
end

[quadsscore, quadsidx] = sort(quadsscore, 'descend');



%If the best score is -infinity, then it's we cannot localize
if quadsscore(1) == -Inf
    return
end

selectedQuad = robustquads(quadsidx(1),:);
selectedQuad = selectedQuad(find(selectedQuad~=node.id));

%fprintf('Update position of %d using positions from %d %d %d\n',node.id,selectedQuad);

%estimate the position of the node using trilateration
Pa = node.data{selectedQuad(1)}.position;
Pb = node.data{selectedQuad(2)}.position;
Pc = node.data{selectedQuad(3)}.position;

dak= node.data{selectedQuad(1)}.distances(node.id);
dbk= node.data{selectedQuad(2)}.distances(node.id);
dck= node.data{selectedQuad(3)}.distances(node.id);

new_position = Trilaterate(Pa,dak,Pb,dbk,Pc,dck);

position_changed = ~isequal(node.data{node.id}.position(:), new_position(:));

if position_changed
    node = node_update_position(node, node.id, new_position);
end
