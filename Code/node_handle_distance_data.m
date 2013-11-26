function [node] = node_handle_distance_data(node, i, j, distance)

% Based on Knuth, The Art Of Computer Programming, vol 2, 3rd ed, p232

if node.data{i}.distances_n(j) == 0
    node.data{i}.distances(j) = 0;
    node.data{i}.distances_M2(j) = 0;
end

node.data{i}.distances_n(j) = node.data{i}.distances_n(j) + 1;
delta = distance - node.data{i}.distances(j);
node.data{i}.distances(j) = node.data{i}.distances(j) + delta / node.data{i}.distances_n(j);
node.data{i}.distances_M2(j) = node.data{i}.distances_M2(j) + delta * (distance - node.data{i}.distances(j));

node.data{i}.measured_noise = sqrt(node.data{i}.distances_M2' ./ (node.data{i}.distances_n' - 1)) ./ node.data{i}.distances';
    %mean(measured_noise(isnan(measured_noise)==0))
return
