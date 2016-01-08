function [LODFs, PTDFtable] = calcLODF(buses, Ybusp, invBp, lines, status, slack)

% calcLODF:
% Calculates the DC LODFs (using lossless DC approximations) for all lines 
% (An outage is effectively a transfer between the two buses at either end
% of the outaged line)
%
% Inputs:
% =====================================================================
% numlines: Number of lines in the system   (scalar)
% PTDFtable:Table of PTDFs for all transfer (numlines x numlines matrix)
% status:   Status of each line
%           'Open' or 'Closed'              (numlines x 1 vector)
% =====================================================================
%
% Outputs:
% =====================================================================
% LODFs:    LODFs for a specified transfer  (sparse numlines x 1 vector)
% =====================================================================

numlines = size(lines,1);
PTDFtable = calcPTDFtable(buses, Ybusp, invBp, lines, status, slack);

% Contingency occurs on line k
% Percentage of post-contingency flow that shows up on line l
LODFs = zeros(numlines, numlines);

for l = 1:numlines %line affected
    for k = 1:numlines %line outaged
        if strcmp(status(l),'Closed') && strcmp(status(k),'Closed')
            if l ~= k
                LODFs(k,l) = (PTDFtable(l,k)/100)/(1-PTDFtable(k,k)/100)*100;
            else LODFs(k,l) = -100;
            end
        end
    end
end