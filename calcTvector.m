% Leilei Xiong
% Date Created: 08/29/2013
% Date Revised: 08/29/2013

function [T] = calcTvector(buses, bus1, bus2, slack)
% calcTvector:
% Calculates the Tvector
%
% Inputs:
% =====================================================================
% numbuses:     Number of buses in the system           (scalar)
% bus1:         Transfer from this bus                  (scalar)
% bus2:         Transfer to this bus                    (scalar)
% slack:        Slack bus number                        (scalar)
% =====================================================================
%
% Outputs:
% =====================================================================
% T:            Transfer vector                         ((n-1)x1 vector)
% =====================================================================

numbuses = length(buses);
temp = zeros(numbuses,1);

busIndex = (1:numbuses).';

slackIndex = busIndex(buses(:,1) == slack);
fromIndex = busIndex(buses(:,1) == bus1);
toIndex = busIndex(buses(:,1) == bus2);

temp(fromIndex,1) = 1;
temp(toIndex,1) = -1;

T = [temp(1:slackIndex-1); temp(slackIndex+1:numbuses)];