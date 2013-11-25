% 4.11.2011, Amanda Prorok
% 14.11.2013 Modified, Bahar Haghighat
% DIS mini project - base code
%
% Draws network and highlights broadcasting nodes
% input:
% net    --     structure for network
% fax    --     figure axis handle
% comm   --     matrix with communication entries
%
%%

function f_draw_network(fax,net,comm)
delta = 0.4;
N = size(net.location,1);
cla(fax);
scatter(fax,net.location(:,1),net.location(:,2),'k','filled');
hold on;
for i=1:N
    text(net.location(i,1)+delta,net.location(i,2)+delta,num2str(i));
end
for i=1:N
    for j=1:N
        if net.neighborhood(i,j)
            li=line([net.location(i,1) net.location(j,1)],[net.location(i,2) net.location(j,2)]);
            set(li,'color','k','linewidth',1);
        end
    end
end
if(nargin==3) % also plot communication
    cn = find(sum(comm,2)>0);
    for i=1:N
        for j=1:N
            if comm(i,j)
                li=line([net.location(i,1) net.location(j,1)],[net.location(i,2) net.location(j,2)]);
                set(li,'color','g','linewidth',2);
            end
        end
    end
    scatter(net.location(cn,1),net.location(cn,2),25,'r','filled');
end
box on
axis equal


end