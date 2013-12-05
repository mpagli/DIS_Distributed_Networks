function [robust] = node_is_robust_quad(node, j, k, l)

debug = 0;

robust = 0;

i=node.id;

others_indexes = [j,k,l];


n_list = sort([i j k l]);

d_ij = node.data{i}.distances(j);
d_ik = node.data{i}.distances(k);
d_il = node.data{i}.distances(l);
d_jk = node.data{j}.distances(k);
d_jl = node.data{j}.distances(l);
d_kl = node.data{k}.distances(l);

if debug
    fprintf('quad %d %d %d %d\n', n_list);
    fprintf('d_ij = %f\n', d_ij);
    fprintf('d_ik = %f\n', d_ik);
    fprintf('d_il = %f\n', d_il);
    fprintf('d_jk = %f\n', d_jk);
    fprintf('d_jl = %f\n', d_jl);
    fprintf('d_kl = %f\n', d_kl);
end

%Not connecter (as far as we know)
if isnan(d_ij) || isnan(d_ik) || isnan(d_il) || isnan(d_jk) || isnan(d_jl) || isnan(d_kl)
    if debug
        fprintf('Not connected!\n');
    end
    return;
end

d_min = mean(node.data{i}.measured_noise(others_indexes)) .* node.d_min_factor; %2-sigma

if debug
    fprintf('d_min = %f\n', d_min);
end

if isRobust(d_ij, d_jk, d_ik, d_min)==0
    if debug
        fprintf('%d %d %d is not robust\n', i, j, k);
    end
    return;
end

if isRobust(d_ij, d_jl, d_il, d_min)==0
    if debug
        fprintf('%d %d %d is not robust\n', i, j, l);
    end
    return;
end

if isRobust(d_ik, d_kl, d_il, d_min)==0
    if debug
        fprintf('%d %d %d is not robust\n', i, k, l);
    end
    return;
end

if isRobust(d_jk, d_kl, d_jl, d_min)==0
    if debug
        fprintf('%d %d %d is not robust\n', j, k, l);
    end
    return;
end

if debug
    fprintf('...Robust!\n');
end
robust=1;
return
