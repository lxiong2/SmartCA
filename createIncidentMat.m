function [incidentMat] = createIncidentMat(buses, numbus, slack, lines, numlines, status)
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

incidentMat = zeros(numlines,numbus);
busIndex = (1:numbus).';

for a = 1:numlines
    if strcmp(status, 'Closed')
        fromBus = busIndex(buses == lines(a,1));
        toBus = busIndex(buses == lines(a,2));
        incidentMat(a, fromBus) = 1;
        incidentMat(a, toBus) = -1;
    end
end

%slackIndex = busIndex(buses == slack);
%incidentMat = [incidentMat(:,1:slackIndex-1) incidentMat(:,slackIndex+1:numbus)];
