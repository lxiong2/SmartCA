function [pcflows] = calcPCFlows(numlines, LODFs, preflows, status)

% calcPCFlows:
% Contingency analysis assuming a change in one generator's output
%
% Inputs:
% =====================================================================
% numlines: Number of lines in the system   (scalar)
% LODFs:    LODFs for a specified transfer  (sparse numlines x 1 vector)
% preflows: Base case line flows            (numlines x 1 vector)
% status:   Status of each line
%           'Open' or 'Closed'              (numlines x 1 vector)
% =====================================================================
%
% Outputs:
% =====================================================================
% pcflows:  Post-contingency line flows     (numlines x numlines)
% =====================================================================

% Contingency occurs on line l
% Percentage of post-contingency flow that shows up on line q
pcflows = zeros(numlines, numlines);

for m = 1:numlines %line affected
    for l = 1:numlines %line outaged
        if strcmp(status(m),'Closed') && strcmp(status(l),'Closed')
            pcflows(m,l) = preflows(m)+LODFs(l,m)/100*preflows(l);
        end
    end
end