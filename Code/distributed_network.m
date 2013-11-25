% 02.11.2010, Amanda Prorok
% 14.11.2013 Modified, Bahar Haghighat
% DIS mini project - main fucntion
% Make a network of N nodes which each are connected at least K times.
% At every time-step, a proportion of the nodes broadcasts range
% measurements. Each node which sends/receives a measurement must update
% its belief of the network localization.
% 
%%

clear
close all


% Initialize network
N = 10;           % number of nodes
K = 3;            % minimum connectivity
R = 20;           % average communication radius
F = 0.1;          % proportion of network broadcasting simultaneously
t_max = 100;       % maximum number of time-steps
noise = 0.1;      % percentage, gaussian noise on range measurements

broadcastingNodes = floor(N*F);  % number of simultaneously broadcasting nodes
plot_on = true;
if(plot_on) fax=gca; else fax=[]; end;

% Create network
net = f_grow_graph(N,K,R,plot_on,fax);
pause

% Each node stores data
data = cell(N, 1);

% Start time (run until t_max)
for t=1:t_max
    cnl = randsample(N,broadcastingNodes,false); % sample random node ids
    comm = zeros(N); % commmunication matrix
    comm(cnl,:) = net.neighborhood(cnl,:);
 
    % Communicate noisy range values, update measurement matrix
    mmnt = nan(N);  % centralized measurements matrix
    mmnt(cnl,:) = (net.neighborhood(cnl,:)==1) .* ( ( net.dist(cnl,:) + (net.dist(cnl,:).*noise).*randn(length(cnl),N) )) + 0./(net.neighborhood(cnl,:)==1);
    
    
    %****************************
    % Distributed calculations
    
    
    for n=1:N
        % Update nodes which received measurements
        if( sum(~isnan(mmnt(:,n)))>=1 )
            data{n} = f_update_mmnt(n,mmnt(:,n), data{n}, 'recv');
        end
    end
    for n=1:N
        % Update nodes which sent measurements
        if(sum(n==cnl)==1)
            data{n} = f_update_mmnt(n,mmnt(n,:)', data{n}, 'sent');
        end
    end
    
   
    
    
    %****************************
    
    f_draw_network(fax,net,comm);
    
    pause(0.5)
end










