function [linePairs, numPairs] = linePairs(numlines, status, numoutaged)
% createIncidentMat:
% Creates the line incident matrix 
%
% Inputs:
% ============================================================
% buses:    List of buses                       (n x 1 vector)
% lines:    
% status:   status of each line
%           'Open' or 'Closed'                  (m x 1 vector)
% ============================================================
%
% Outputs:
% ============================================================
% incidentMat:  Line incident matrix            (m x n-1 matrix)
% ============================================================

closedLines = sum(strcmp(status,'Closed'));

temp = 1;
for i = 1:numoutaged
    temp = temp*(closedLines-i+1);
end
numPairs = temp/factorial(numoutaged);

linePairs = zeros(numPairs,2);
count = 1;

for a = 1:numlines
    for b = 1:numlines
        if strcmp(status(a), 'Closed') && strcmp(status(b), 'Closed') && (b > a)
            linePairs(count,:) = [a b];
            count = count + 1;
        end
    end
end
