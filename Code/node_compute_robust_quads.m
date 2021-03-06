function [node] = node_compute_robust_quads(node)
% [node] = node_compute_robust_quads(node)
%
% Compute and update all robust quads containing node
%
% Parameters:
%  - node
%
% Output values:
%  - node (updated)

i=node.id;

neighbors = int32(find(isnan(node.data{i}.distances)==0)');
nneigh = length(neighbors);

connectivity = zeros(node.N,node.N);
for ni=1:node.N
    connectivity(ni,:) = node.data{ni}.distances;
end

robust = [];

for j_i = 1:nneigh
    for k_i = j_i+1:nneigh
        for l_i = k_i+1:nneigh
            j = neighbors(j_i);
            k = neighbors(k_i);
            l = neighbors(l_i);
            
            if node_is_robust_quad(node, j, k, l, connectivity)
                n_list = sort([i j k l]);
                robust = [robust ; n_list];
            end
        end
    end
end

if isequal(node.data{i}.robustquads, robust)==0
    node = node_update_robust_quads(node, i, robust);
end

return
