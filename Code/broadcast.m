function [node] = broadcast(node, message_type, message_data)
% [node] = broadcast(node, message_type, message_data)
% 
% Broadcast a message to all neighboring nodes
% This will put the message in the outbox, it will effectively sent by the simulator after all timer_ticks are run.
%
% Parameters:
%  - node: sender node
%  - message_type: string describing the type of message (one of 'anchor','position','distances','robustquads')
%  - message_data: matrix of the content of the message (size depends on the type)
%
% Output value:
%  - node: sender node, with the message in the outbox

node.outbox.add(message_type);
node.outbox.add(message_data);
return
