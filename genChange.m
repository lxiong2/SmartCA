function [ptpcflows_vec] = genChange(numlines, LODFs, OTDFs_vec, pvec, preflows, status)

% genChange:
% Contingency analysis assuming a change in one generator's output
%
% Inputs:
% =====================================================================
% numlines: Number of lines in the system   (scalar)
% LODFs:    LODFs for a specified transfer  (sparse numlines x 1 vector)
% OTDFs:    OTDFs for a specified transfer  (?) 
% p:        Transfer size in MW             (scalar)
% preflows: Base case line flows            (numlines x 1 vector)
% status:   Status of each line
%           'Open' or 'Closed'              (numlines x 1 vector)
% =====================================================================
%
% Outputs:
% =====================================================================
% OTDFs:     OTDFs for a specified transfer  (numlines x numlines vector)
% ptpcflows: Post-transfer post-contingency line flows     (numlines x 1 vector)
% =====================================================================

% index: transfer direction index in the PTDF matrix

% Contingency occurs on line l
% Percentage of post-contingency flow that shows up on line q
timesteps = size(OTDFs_vec,3);
ptpcflows_vec = zeros(numlines, numlines);

for k = 1:timesteps
    for m = 1:numlines %line affected
        for l = 1:numlines %line outaged
            if strcmp(status(m),'Closed') && strcmp(status(l),'Closed')
                ptpcflows_vec(m,l,k) = preflows(m)+LODFs(l,m)/100*preflows(l)+OTDFs_vec(m,l,k)/100*pvec(k);
            end
        end
    end
end