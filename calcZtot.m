% Author: Leilei Xiong
% Date Created: August 29, 2013
% Date Revised: September 3, 2013

function [pairs Ztot] = calcZtot(FromBus, ToBus, X, status)
% calcZtot:
% Calculates the equivalent impedance between two buses
%
% Inputs:
% ============================================================
% FromBus:  Connection from Bus i               (column vector)
% ToBus:    Connection to Bus j                 (column vector)
% X:        line reactance in per unit          (column vector)
% status:   status of each line
%           'Open' or 'Closed'                  (column vector)
% ============================================================
%
% Outputs:
% ============================================================
% pairs:    Pairs of buses                      (<m x 2 matrix)
% Ztot:     Zeq for each pair of buses          (<m x 1 vector)
% ============================================================

numlines = length(FromBus);

% Find the list of lines that are closed
numclosed = 0;
for a = 1:numlines
    if strcmp(status(a),'Closed')
        numclosed = numclosed + 1;
        temp(numclosed,1) = FromBus(a);
        temp(numclosed,2) = ToBus(a);
    end
end

% Only check distinct lines that are closed
distinctPairs = 1;
for a = 1:numclosed
    % the first pair is always distinct 
    if a == 1
        pairs(distinctPairs, 1) = temp(a,1);
        pairs(distinctPairs, 2) = temp(a,2);
    % if the bus pair isn't already in the pairs list 
    elseif (temp(a,1) ~= temp(a-1,1)) || (temp(a,2) ~= temp(a-1,2))
        distinctPairs = distinctPairs + 1;
        pairs(distinctPairs, 1) = temp(a,1);
        pairs(distinctPairs, 2) = temp(a,2);
    end
end

for a = 1:size(pairs,1)
    count = 1; % count how many redundant lines there are
    for b = 1:numlines
        if(pairs(a,1) == FromBus(b)) && (pairs(a,2) == ToBus(b)) && strcmp(status(b),'Closed')
            Xeqp(a,count) = 1/X(b); % calculate the impedance of each redundant line and store it in a row of Xeqp
            count = count+1;
        end
    end
    Ztot(a,1) = 1/sum(Xeqp(a,:),2);
end





