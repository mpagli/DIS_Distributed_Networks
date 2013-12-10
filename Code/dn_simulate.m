function [nodes, performance_L, performance_sigma_p, performance_sigma_d] = dn_simulate(nodes, net, t_max, noise, fax)
% [nodes, performance_L, performance_sigma_p, performance_sigma_d] = dn_simulate(nodes, net, t_max, noise, fax)
%
% Launch a simulation of nodes on the network.
%
% Parameters:
%  - nodes: cell array of nodes. Should be created by dn_generate_nodes
%  - net: network. Should be generated by one of f_grow_graph, f_regular_net, etc.
%  - t_max: number of iterations to execute
%  - noise: noise level. Measured distances will follow a distance * N(1,noise) distribution
%  - fax: axis handle on which to plot the network state. If omitted, nothing will be plot.
%
% Output values:
%  - nodes: new state of the nodes
%  - performance_L: number of nodes localized at each iteration (vector of length t_max)
%  - performance_sigma_p: normalized sum of the squares of the distances between the estimated position and the correct location of the node (vector of length t_max)
%  - performance_sigma_d: normalized sum of the squares of the difference between the real and the estimated distances (vector of length t_max)

plot_on = exist('fax');

N = length(nodes);
node_list = 1:N;

%Create a progress bar
if plot_on
    progress = waitbar(0,'Starting simulation...');
    cleanup = onCleanup( @()( close( progress ) ) );
end

performance_L = [];
performance_sigma_p = [];
performance_sigma_d = [];

w=[];

% Start time (run until t_max)
for t = 1:t_max
    %Add noise to distances
    noisy_distances = net.dist .* ( 1 + (noise .* randn(N,N)));
    
    %Set unmeasurable  (not neighbors) distances to NaN
    noisy_distances = noisy_distances + 0./(net.neighborhood == 1);
    
    %Update measured distances for all nodes
    for i = node_list
        nodes{i}.measured_distances = noisy_distances(i,:);
    end
    
    %Call timer tick for every node
    for i = node_list
        nodes{i} = node_timer_tick(nodes{i});
    end
    
    %Send broadcasts to neighboring nodes
    comm_edges = []; %keep track of communication
    for i = node_list
        while nodes{i}.outbox.size > 0
            message_type = nodes{i}.outbox.remove();
            message_data = nodes{i}.outbox.remove();
            for j = find(net.neighborhood(i,:) == 1)
                nodes{j} = node_msg_recv(nodes{j}, i, message_type, message_data);
                comm_edges = [comm_edges; i, j];
            end
        end
    end
    
    % Compute transformation from internal coordinates to real world ones
    %Find mat_transform and translation such that the position in real coordinates correspond to:
    %mat_transform * [computed pos] + translation = net.location
    %Ex for node 3:
    %mat_transform * reshape(nodes{3}.data{3}.position,2,1)  + translation;
    translation = reshape(net.location(1,:),2,1);
    theta = atan2(net.location(2,2)-net.location(1,2),net.location(2,1)-net.location(1,1));
    mat_transform = [cos(theta), -sin(theta); sin(theta), cos(theta)];

    v3 = reshape(nodes{3}.data{3}.position,2,1);
    real_v3 = reshape(net.location(3,:),2,1);

    %Maybe we have to take the symmetry to have the right orientation
    if norm(mat_transform * v3  + translation - real_v3) > norm(mat_transform * [1,0;0,-1] * v3  + translation - real_v3)
        mat_transform = mat_transform * [1,0;0,-1];
    end

    %Define a simple helper function to get positions
    get_position_for = @(id) mat_transform * reshape(nodes{id}.data{id}.position,2,1)  + translation;
    
    if plot_on
        %Prepare robust quads for drawing
        robustquads_edges = [];
        for i = node_list
            robustquads = nodes{i}.data{i}.robustquads;
            for j = 1:size(robustquads, 1)
                robustquads_edges = [robustquads_edges; robustquads(j,1) robustquads(j,2); robustquads(j,1) robustquads(j,3); robustquads(j,1) robustquads(j,4); robustquads(j,2) robustquads(j,3); robustquads(j,2) robustquads(j,4); robustquads(j,3) robustquads(j,4)];
            end
        end
        
        f_draw_network(fax,net);
        if t<t_max 
            f_draw_overlay(fax, net, comm_edges, 'r', 3);
        end
        f_draw_overlay(fax, net, robustquads_edges, 'b', 2);
        
        %Draw estimated positions of the nodes, and a line linking the correct location to the estimated position
        node_positions = [];
        for i = 1:N
            node_position = get_position_for(i);
            node_positions = [node_positions, node_position];
            
            li=line([net.location(i,1) node_position(1)], [net.location(i,2) node_position(2)]);
            set(li,'color', 'g', 'linewidth', 1);
        end
        scatter(fax, node_positions(1,:),node_positions(2,:),25,'g','filled');
        
        pause(0.1)
    end
    
    %compute performance metrics
    cur_pf = 0;
    cur_ss = 0;
    for id = 1:N
        if sum(isnan(nodes{id}.data{id}.position)) == 0
            cur_pf = cur_pf + 1;
            cur_ss = norm(get_position_for(id) - net.location(id,:)').^2;
        end
    end
    
    %estimate sigma_d
    [vi0,vi1]=ind2sub(size(net.neighborhood),find(net.neighborhood==1));
    
    cur_sd = 0;
    cur_sdc = 0;
    
    for i0 = vi0'
        for i1 = vi1'
            if i0 < i1
                real_distance = net.dist(i0, i1);
                estimated_distance = norm(reshape(nodes{i0}.data{i0}.position,2,1) - reshape(nodes{i1}.data{i1}.position,2,1));
                if ~isnan(estimated_distance)
                    cur_sd = cur_sd + (real_distance - estimated_distance).^2;
                    cur_sdc = cur_sdc + 1;
                end
            end
        end
    end
    
    performance_L = [performance_L cur_pf];
    performance_sigma_p = [performance_sigma_p cur_ss/cur_pf];
    performance_sigma_d = [performance_sigma_d cur_sd/cur_sdc];
    
    %Display some progress indication
    if plot_on
        waitbar(t/t_max,progress,sprintf('At iteration %d/%d...',t,t_max));
    else
        fprintf('At iteration %d/%d (L=%d, sigma_p=%0.6f, sigma_d=%0.6f)...\n',t,t_max, cur_pf, cur_ss/cur_pf, cur_sd/cur_sdc)
    end
    
end
