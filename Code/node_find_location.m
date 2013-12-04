%% Locate the node 
function [node] = node_find_location(node)

robustquad = node.data{node.id}.robustquads;
robustquads = zeros(size(robustquad));

if isequal(robustquads,[]) == 1
    return;
end

for i = 1 : length(robustquads(:,1))
   for j = 1:4
       robustquads(i,j)=robustquad(i,j);
   end
end

hopList = zeros(size(robustquads));

%we create the hopList
for i = 1 : length(robustquads(:,1))
   for j = 1:4
       if robustquads(i,j) == node.id
           robustquads(i,j) = NaN;
           hopList(i,j)     = NaN;
       else
           hopList(i,j) = node.data{robustquads(i,j)}.path_length;
       end
   end
end

%remove the robustQuads that do not contain enough information (no position or no pathLength)
for i = 1 : length(robustquads(:,1))
   for j = 1:4
       if (isnan(robustquads(i,j)) == 0)
           node.data{robustquads(i,j)}.position;
       end
       if (isnan(robustquads(i,j)) == 0) & (sum(isnan(node.data{robustquads(i,j)}.position)) | isnan(hopList(i,j)))
         robustquads(i,:)= NaN(1,4);
         hopList(i,:)    = NaN(1,4);
         break;
       end
   end
end

if sum(sum(~isnan(robustquads))) == 0 %if no robust quad with enough info
    return;
end
    

%sort the rows
for i = 1 : length(robustquads(:,1))
    [hopList(i,:),index] = sort(hopList(i,:)); 
    hopList(i,:) = hopList(i,index);
end

[hopList,index] = sortrows(hopList,[1 2 3 4]);
robustquads = robustquads(index,:);

selectedQuad = robustquads(1,:);

selectedQuad = selectedQuad(isnan(selectedQuad) == 0);

%estimate the position of the node using trilateration
Pa = node.data{selectedQuad(1)}.position;
Pb = node.data{selectedQuad(2)}.position;
Pc = node.data{selectedQuad(3)}.position;

dak= node.data{selectedQuad(1)}.distances(node.id);
dbk= node.data{selectedQuad(2)}.distances(node.id);
dck= node.data{selectedQuad(3)}.distances(node.id);

new_position = Trilaterate(Pa,dak,Pb,dbk,Pc,dck);

position_changed = isequal(node.data{node.id}.position(:), new_position(:));

if position_changed
    node = node_update_position(node, node.id, Trilaterate(Pa,dak,Pb,dbk,Pc,dck));
end

end
