function [r] = node_compute_anchor_score(node)

id=node.id;

n_robustquads = size(node.data{id}.robustquads,1);

besttri=-Inf;
bestnodes=[nan nan];

for i = 1:n_robustquads
    for j = 1:3
        for k=j+1:4
            if j == k
                continue
            end
            nj = node.data{id}.robustquads(i, j);
            nk = node.data{id}.robustquads(i, k);
            nl = id;
            if nj == nk || nj == nl || nk == nl
                continue
            end
            
            djk = node.data{nj}.distances(nk);
            dkl = node.data{nk}.distances(nl);
            dlj = node.data{nl}.distances(nj);
            
            angles=[acos((-djk.^2 + dkl.^2 + dlj.^2) / (2*dkl*dlj));
                    acos((+djk.^2 - dkl.^2 + dlj.^2) / (2*djk*dlj));
                    acos((+djk.^2 + dkl.^2 - dlj.^2) / (2*djk*dkl))];
                    
            triscore = sin(min(angles)) + (sum(sum(node.data{id}.robustquads == nj)) + sum(sum(node.data{id}.robustquads == nk)))/(2*n_robustquads);
            if triscore > besttri
                besttri = triscore;
                if dkl > dlj
                    bestnodes = [nk, nj];
                else
                    bestnodes = [nj, nk];
                end
            end
        end
    end
end

r = [double(id) double(bestnodes) double(n_robustquads)+besttri];
