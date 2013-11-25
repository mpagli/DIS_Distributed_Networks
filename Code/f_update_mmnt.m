% 8.11.2011, Amanda Prorok
% 14.11.2013 Modified, Bahar Haghighat
% Base code for updating range measurements
% 
% 
% input:
% id        --     node id
% mmnts     --     measurement vector (noisy ranges)
% data      --     storage to keep track of measurements
% type      --     string: 'recv' means received mmnts
%                          'sent' means measured mmnts
% 

%%

function data = f_update_mmnt(id,mmnts, data, type)

% Example of usage for data.
% Note that data is specific to the current node id (it is not shared with
% other nodes).
if (isempty(data))
    data.cnt = 0;
end
data.cnt = data.cnt + 1;

if id==1
    disp(mmnts');
end

end
