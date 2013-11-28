%% Locate the node 
function [node] = node_find_location(node)

robustquads = node.data{node.id}.robustquad;

hopList = zeros(size(robustquads));

for i = robustquads(:,1)
   for j =  robustquads(1,:)
       if robustquads(i,j) == node.id
           robustquads(i,j) = NaN;
           hopList(i,j) = NaN;
       else
           hopList(i,j) = node.data{robustquads(i,j)}.path_length;
       end
   end
end

for i = robustquads(:,1)
   for j =  robustquads(1,:)
       if robustquads(i,j) ~= NaN && isnan(node.data{robustquads(i,j)}.position) == 1
         robustquads(i,:)= NaN(1,4);
         hopList(i,:)    = NaN(1,4);
         break;
       end
   end
end

if sum(sum(~isnan(robustquads))) == 0 %if no robust quad with enough info
    return;
end
    
%sort by row
for i = robustquads(:,1)
    [hopList(i,:),index] = sort(hopList(i,:)); 
    hopList(i,:) = hopList(i,index);
end

[hopList,index] = sortrows(hopList,[1 2 3 4]);
robustquads = robustquads(index);

selectedQuad = robustquads(1,:); 

selectedQuad = selectedQuad(selectedQuad ~= NaN);

Pa = node.data{selectedQuad(1)}.position;
Pb = node.data{selectedQuad(2)}.position;
Pc = node.data{selectedQuad(3)}.position;

dak= node.data{selectedQuad(1)}.distances(node.id);
dbk= node.data{selectedQuad(2)}.distances(node.id);
dck= node.data{selectedQuad(3)}.distances(node.id);

node.data{node.id}.position = Trilaterate(Pa,dak,Pb,dbk,Pc,dck);

end