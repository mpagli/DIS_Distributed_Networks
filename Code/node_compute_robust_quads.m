function [node] = node_compute_robust_quads(node)

i=node.id;

neighbors = int32(find(isnan(node.data{i}.distances)==0)');
nneigh = length(neighbors);

connectivity = zeros(node.N,node.N);
for ni=1:node.N
    connectivity(ni,:) = node.data{ni}.distances;
end

robust = [];

%testmat = ones(4,4)-diag(ones(4,1));
%is_connected = ~isnan(connectivity);

for j_i = 1:nneigh
    for k_i = j_i+1:nneigh
        for l_i = k_i+1:nneigh
            j = neighbors(j_i);
            k = neighbors(k_i);
            l = neighbors(l_i);
            
            %if ~isequal(is_connected([i,j,k,l],[i,j,k,l]),testmat)
            %    continue
            %end
            
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
