function [nodes] = dn_simulate(nodes, net, t_max, noise, plot_on, fax)

N = length(nodes);
node_list = 1:N;

progress = waitbar(0,'Starting simulation...');
cleanup = onCleanup( @()( close( progress ) ) );
    
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
        f_draw_overlay(fax, net, comm_edges, 'r', 3);
        f_draw_overlay(fax, net, robustquads_edges, 'b', 2);
        
        
        %Draw positions
        % Get translation + rotation matrix to match network
        % goal: mat_transform * [computed pos] + translation = net.location

        translation = reshape(net.location(1,:),2,1);
        theta = atan2(net.location(2,2)-net.location(1,2),net.location(2,1)-net.location(1,1));
        mat_transform = [cos(theta), -sin(theta); sin(theta), cos(theta)];

        v3 = reshape(nodes{3}.data{3}.position,2,1);
        real_v3 = reshape(net.location(3,:),2,1);

        %Maybe we have to take the symmetry to have the right orientation
        if norm(mat_transform * v3  + translation - real_v3) > norm(mat_transform * [1,0;0,-1] * v3  + translation - real_v3)
            mat_transform = mat_transform * [1,0;0,-1];
        end

        %example: compute position of node 3 in the real coordinate
        %mat_transform * reshape(nodes{3}.data{3}.position,2,1)  + translation;

        node_positions = [];
        for i = 1:N
            node_positions = [node_positions, mat_transform * reshape(nodes{i}.data{i}.position,2,1)  + translation];
        end
        scatter(fax, node_positions(1,:),node_positions(2,:),25,'g','filled');
        
        
        pause(0.1)
    end
    
    waitbar(t/t_max,progress,sprintf('At iteration %d/%d...',t,t_max));
end
