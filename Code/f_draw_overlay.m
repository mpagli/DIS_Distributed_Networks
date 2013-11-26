% Maintainer: Laurent
% Draw an overlay on edges. This may be used to display current communication, network properties, etc.
% Parameters:
% - fax: figure axis handle
% - net: network
% - edges: K x 2 matrix, with each row is the beginning node id, and the end node id
% - color: color of an edge
% - linewidth: widh of an edge

function f_draw_overlay(fax, net, edges, color, linewidth)
    N = size(edges,1);
    
    for i=1:N
        startnode = edges(i,1);
        endnode = edges(i,2);
        li=line([net.location(startnode,1) net.location(endnode,1)], [net.location(startnode,2) net.location(endnode,2)]);
        set(li,'color', color, 'linewidth', linewidth);
    end
    %scatter(net.location(cn,1),net.location(cn,2),25,'r','filled');
end
