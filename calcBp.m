% Author: Leilei Xiong
% Date Created: March 26, 2013
% Date Revised: March 27, 2013

function [Bp, temp] = calcBp(buses, FromBus, ToBus, X, slack, status)
% calcBp:
% Computes the decoupled Bp matrix for an n-bus power system
%
% Inputs:
% ============================================================
% numbuses: number of buses                     (scalar)
% FromBus:  Connection from Bus i               (column vector)
% ToBus:    Connection to Bus j                 (column vector)
% X:        line reactance in per unit          (column vector)
% slack:    Slack bus number                    (scalar)
% status:   status of each line
%           'Open' or 'Closed'                  (column vector)
% ============================================================
%
% Outputs:
% ============================================================
% Bp:       Decoupled bus admittance matrix      ((n-1)x(n-1) matrix)
% ============================================================
%
% For a system with n buses:
% - Ybus should be a n x n symmetric matrix
% - Off-diagonal terms are equal to the negative of the sum of the
% admittances joining the two buses
% - Diagonal terms are equal to the sum of the admittances of all devices
% and line charging incident to bus i 

numbuses = size(buses,1);
temp = zeros(numbuses,numbuses);
Bp = zeros(numbuses-1,numbuses-1);
offDiagY = -1./(1i*X);
slackIndex = find(buses(:,1) == slack);

busIndex = (1:numbuses).';

for a = 1:length(FromBus)
    if strcmp(status(a),'Closed')
        %fromIndex = find(buses(:,1) == FromBus(a,1));
        %toIndex = find(buses(:,1) == ToBus(a,1));
        fromIndex = busIndex(buses(:,1) == FromBus(a,1)); 
        toIndex = busIndex(buses(:,1) == ToBus(a,1));
        temp(fromIndex,toIndex) = temp(fromIndex,toIndex) + offDiagY(a); %Calculate off-diagonal values
        temp(toIndex,fromIndex) = temp(fromIndex,toIndex); %Exploit symmetry
    %% POSSIBLE ERROR HERE
        temp(fromIndex,fromIndex) = -offDiagY(a) + ...
        temp(fromIndex,fromIndex); %Accumulates off-diagonal values at the "from bus" 
        temp(toIndex,toIndex) = -offDiagY(a) + ...
        temp(toIndex,toIndex); %Accumulates off-diagonal values at the "to bus"
    end
end

% MATLAB gives a warning if you just concatenate temp(1:slackIndex-1,:)
% with temp(slackIndex+1:numbuses) because sometimes they are empty
% matrices
if (slackIndex < numbuses) && (slackIndex > 1)
    temp2 = [temp(1:slackIndex-1,:); temp(slackIndex+1:numbuses,:)]; %remove slackBus column
    Bp = [temp2(:,1:slackIndex-1) temp2(:,slackIndex+1:numbuses)]; %remove slackBus row
elseif slackIndex == 1
    temp2 = temp(2:numbuses,:); %remove slackBus column
    Bp = temp2(:,2:numbuses); %remove slackBus row
elseif slackIndex == numbuses
    temp2 = temp(1:numbuses-1,:); %remove slackBus column
    Bp = temp2(:,1:numbuses-1); %remove slackBus row
end

Bp = Bp/1i;

