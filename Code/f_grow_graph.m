% 02.11.2010, Amanda Prorok
% 14.11.2013 Modified, Bahar Haghighat
% DIS mini project - base code
% Make a network of N nodes which each are connected at least K times.
% 
% input:
% N        --    total number of nodes
% K        --    minimum node connectivity
% R        --    minimum communication radius
%
%%


function [net]=f_grow_graph(N,K,R,fax)

if(~nargin)
   N = 20;
   K = 4;
   R = 20;
end

% Initialization
field = 100;              % 100x100m^2 field
net.location = zeros(N,2);     % position vector (x,y)
net.state = zeros(N,1);   % state of each node (0: OK/non-existant 1: connectivity less than K)
net.dist = inf(N);        % node-node distance matrix
net.neighborhood = zeros(N);  % neighbor matrix
net.connectivity = zeros(N,1);    % node connectivity
net.nodeCount = 0;            % node counter

% Create first node (random pos in field)
net.location(1,:) = rand(1,2) * field;
net.state(1) = 1;
net.dist(1,1) = 0;
net.nodeCount = 1;

while(net.nodeCount<N)

    net = f_add_node(net,net.nodeCount,N,K,R);
    
    % Connect leaf nodes
    while(sum(net.state)>0 && net.nodeCount==N)
        ind = find(net.state); % Get nodes which need more connectivity
        for i=1:length(ind)
            net = f_add_node(net,ind(i),N,K,R);
        end
    end % while graph connectivity not ok
    
   
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



