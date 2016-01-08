function [newStatus] = convertStatus(numlines, oldStatus, lineChange, statusChange, timesteps)

newStatus = cell(numlines,timesteps+1);

for a = 1:timesteps+1
   newStatus(:,a) = oldStatus;    
end

for a = 1:size(lineChange,1)
    for k = 1:timesteps
        if statusChange(a,k) == 0
            newStatus(lineChange(a),k+1) = {'Open'};
        elseif statusChange(a,k) == 1
            newStatus(lineChange(a),k+1) = {'Closed'};
        end
    end
end

