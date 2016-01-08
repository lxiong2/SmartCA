% Leilei Xiong
% Date Created: 08/29/2013
% Date Revised: 08/29/2013

function [Tvec, pvec] = calcTvector2(buses, diffSvec, diffBvec, slack)
% calcTvector:
% Calculates the Tvector for a specific transfer
%
% Inputs:
% =====================================================================
% numbuses:     Number of buses in the system           (scalar)
% diffS:        Change in bus generators                (nx1 vector)
% diffB:        Change in bus loads                     (nx1 vector)
% slack:        Slack bus number                        (scalar)
% =====================================================================
%
% Outputs:
% =====================================================================
% T:            Transfer                                ((n-1)x1 vector)
% p:            Transfer amount                         (scalar)
% =====================================================================

numbuses = length(buses);
busIndex = (1:numbuses).';

slackIndex = busIndex(buses(:,1) == slack);

% Initialize empty T matrix
timepts = size(diffSvec,2);
Tvec = zeros((numbuses-1),timepts);
pvec = zeros(1,timepts);

for a = 1:timepts
    % Normalize diffS and diffB into Ts and Tb
    Ts = diffSvec(:,a)/sum(diffSvec(:,a));
    Tb = diffBvec(:,a)/sum(diffBvec(:,a));
    pvec(a) = sum(diffSvec(:,a));
    temp = Ts - Tb;
    % Remove the slack bus
    Tvec(1:numbuses-1,a) = [temp(1:slackIndex-1); temp(slackIndex+1:numbuses)];
end