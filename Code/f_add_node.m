% 4.11.2011, Amanda Prorok
% 14.11.2013 Modified, Bahar Haghighat
% DIS mini project - base code
%
% Adds or connects a node to an existing network. Parent node is node lastNodeInd
% input:
% net    --     structure for network
% lastNodeInd      --     parent node
% N      --     total number of nodes
% K      --     minimum node connectivity
% R      --     minimum communication radius
% ci     --     if provided, this is node to which connection is created
%
%%

function [net]=f_add_node(net,hookNodeInd,N,K,R)

if (net.nodeCount<N) 
    % Add node
    % Radius around node lastNodeInd is approximated by cells
    %fprintf('New node added\n');
    
    net.nodeCount = net.nodeCount+1;
    net.location(net.nodeCount,:) = net.location(hookNodeInd,:) - [R R]/sqrt(2) + rand(1,2) * R *sqrt(2);
    net.state(net.nodeCount) = 1;
    
    for j=1:net.nodeCount
        net.dist(net.nodeCount,j) = sqrt((net.location(j,1)-net.location(net.nodeCount,1))^2 + (net.location(j,2)-net.location(net.nodeCount,2))^2);
        if net.dist(net.nodeCount,j) < R && net.nodeCount ~= j
            net.neighborhood(net.nodeCount,j) = 1;
            net.neighborhood(j,net.nodeCount) = 1;
            
            net.connectivity(j) = sum(net.neighborhood(j,:));
            if(net.connectivity(j)>=K) net.state(j) = 0; end
        end
    end
    net.connectivity(net.nodeCount) = sum(net.neighborhood(net.nodeCount,:));
    if(net.connectivity(net.nodeCount)>=K) net.state(net.nodeCount) = 0; end
            
    net.dist(:,net.nodeCount) = net.dist(net.nodeCount,:)';
    
elseif(net.nodeCount==N)
    % Connect to nearest neighbor
    %fprintf('Connect nearest node\n');
        
    index = find(net.dist(hookNodeInd,:).*(~net.neighborhood(hookNodeInd,:))); % index of the nodes except for the node hookNodeInd itself and its neighbors  
    [C,ci] = min((net.dist(hookNodeInd,index)));
    net.neighborhood(hookNodeInd,index(ci)) = 1;
    net.neighborhood(index(ci),hookNodeInd) = 1;
    net.connectivity(hookNodeInd) = sum(net.neighborhood(hookNodeInd,:));
    if(net.connectivity(hookNodeInd)>=K) net.state(hookNodeInd) = 0; end
    for i=1:length(ci)
        net.connectivity(index(ci(i))) = sum(net.neighborhood(index(ci(i)),:));
        if(net.connectivity(index(ci(i)))>=K) net.state(index(ci(i))) = 0; end
    end
end