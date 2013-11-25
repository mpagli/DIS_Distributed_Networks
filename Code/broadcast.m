% Put the message in the output queue of the node

function [node] = broadcast(node, message_type, message_data)
node.outbox.add(message_type);
node.outbox.add(message_data);
return
