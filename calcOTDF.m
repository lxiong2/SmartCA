function [OTDFs_vec] = calcOTDF(PTDFs_vec, LODFs, status)

% genChange:
% Contingency analysis assuming a change in one generator's output
%
% Inputs:
% =====================================================================
% PTDFs_vec:    Vectors of PTDFs for specified transfers  (sparse numlines x timesteps vector)  
% LODFs:    LODFs for a specified transfer  (sparse numlines x 1 vector)
% status:   Status of each line
%           'Open' or 'Closed'              (numlines x 1 vector)
% =====================================================================
%
% Outputs:
% =====================================================================
% OTDFs:     OTDFs for a specified transfer  (numlines x numlines vector)
% =====================================================================

numlines = length(status);
timesteps = size(PTDFs_vec,2);

% Contingency occurs on line l
% Percentage of post-contingency flow that shows up on line q
OTDFs_vec = zeros(numlines, numlines, timesteps);
for k = 1:timesteps
    for m = 1:numlines %line affected 
        for l = 1:numlines %line outaged
            if strcmp(status(m),'Closed') && strcmp(status(l),'Closed')
                OTDFs_vec(m,l,k) = (PTDFs_vec(m,k)/100+LODFs(l,m)/100*PTDFs_vec(l,k)/100)*100;
            end
        end
    end
end