% 02.11.2010, Amanda Prorok
% 14.11.2013 Modified, Bahar Haghighat
% DIS mini project - base code
% Make a network of N nodes which each are connected at least K times.
% 
% input:
% N        --    total number of nodes
% K        --    minimum node connectivity
% R        --    minimum communication radius
% plot_on  --    sets option to plot
%
%%


function [net]=f_grow_graph(N,K,R,plot_on,fax)

% Initialization
field = 100;              % 100x100m^2 field
N
net.location = zeros(N,2);     % position vector (x,y)
net.state = zeros(N,1);   % state of each node (0: OK/non-existant 1: connectivity less than K)
net.dist = inf(N);        % node-node distance matrix
net.neighborhood = zeros(N);  % neighbor matrix
net.connectivity = zeros(N,1);    % node connectivity
net.nodeCount = 0;            % node counter

% Create first node (random pos in field)
net.nodeCount = N;
for i0 = 1:N
    net.location(i0,:) = [floor(i0-1/2)*10-mod(i0-1/2,2)*10 mod(i0-1,2)*30];
    net.state(i0) = 1;
    net.dist(i0,i0) = 0;
end

for i0 = 1:N
    for i1 = 1:N
        net.dist(i0,i1) = norm(net.location(i0,:) - net.location(i1,:))
    end
end

for i0 = 2:N
    idx = i0;
    idx2 = i0-1;
    idx3 = i0-2;
    idx4 = i0-3;
    
    net.neighborhood(idx,idx2) = 1;
    net.neighborhood(idx2,idx) = 1;
    if idx3 > 0
        net.neighborhood(idx,idx3) = 1;
        net.neighborhood(idx3,idx) = 1;
    end
    if idx4 > 0 && mod(idx,2)==0
        net.neighborhood(idx,idx4) = 1;
        net.neighborhood(idx4,idx) = 1;
    end
end

for i0 = 1:N
    if i0+5>N
        break;
    end

    net.neighborhood(i0,i0+5) = 1;
    net.neighborhood(i0+5,i0) = 1;
    
    i0=i0+1;
end


if plot_on
    f_draw_network(fax,net);
end

nz = triu(net.dist,1);
nz = sum(sum(nz))/(N^2/2-(N/2));
fprintf('\n\n***********************************\n');
fprintf('N: %d   K: %d   R: %d \n',N,K,R);
fprintf('Average node connectivity is: %f\n',mean(net.connectivity));
fprintf('Average node distance is: %f[m]\n\n',nz);

end

