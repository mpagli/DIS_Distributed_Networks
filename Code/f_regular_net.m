% 02.11.2010, Amanda Prorok
% 14.11.2013 Modified, Bahar Haghighat
% 10.12.2013 Modified, Laurent Fasnacht (removed the plot_on, replaced by checking existence of fax)
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


function [net]=f_regular_net(N,K,R,fax)

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
        net.dist(i0,i1) = norm(net.location(i0,:) - net.location(i1,:));
    end
end

for i0 = 1:N
    for i1 = i0-1:-1:i0-K
        if i1 <= 0
            continue
        end
        net.neighborhood(i0,i1) = 1;
        net.neighborhood(i1,i0) = 1;
    end
end

if exist('fax','var')
    f_draw_network(fax,net);
end

nz = triu(net.dist,1);
nz = sum(sum(nz))/(N^2/2-(N/2));
fprintf('\n\n***********************************\n');
fprintf('N: %d   K: %d   R: %d \n',N,K,R);
fprintf('Average node connectivity is: %f\n',mean(net.connectivity));
fprintf('Average node distance is: %f[m]\n\n',nz);

end

