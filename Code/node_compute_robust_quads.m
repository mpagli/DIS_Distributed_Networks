function [node] = node_compute_robust_quads(node)

i=node.id;

neighbors = int32(find(isnan(node.data{i}.distances)==0)');
nneigh = length(neighbors);

d_min = 0.3;

for j_i = 1:nneigh
    for k_i = j_i+1:nneigh
        for l_i = k_i+1:nneigh
            j = neighbors(j_i);
            k = neighbors(k_i);
            l = neighbors(l_i);
            
            d_ij = node.data{i}.distances(j);
            d_ik = node.data{i}.distances(k);
            d_il = node.data{i}.distances(l);
            d_jk = node.data{j}.distances(k);
            d_jl = node.data{j}.distances(l);
            d_kl = node.data{k}.distances(l);
            
            %Not connecter (as far as we know)
            if isnan(d_ij) || isnan(d_ik) || isnan(d_il) || isnan(d_jk) || isnan(d_jl) || isnan(d_kl)
                continue
            end
            
            %triangles: ijk ijl ikl jkl
            if isRobust(d_ij, d_jk, d_ik, d_min) && isRobust(d_ij, d_jl, d_il, d_min) && isRobust(d_ik, d_kl, d_il, d_min) && isRobust(d_jk, d_kl, d_jl, d_min)
               
               disp([1, i,j,k, l]);
            else
                disp([0, i,j,k, l]);
            end
        end
    end
end
            

return
