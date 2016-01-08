% Leilei Xiong
% Date Created: 08/19/2013
% Date Revised: 08/19/2013

function [diffS, diffB] = calcDiff2(numbuses, buses, busGen1, busLoad1, busGen2, busLoad2, timesteps)
% calcDiff:
% Calculates the change in generation/load at different points in time
%
% Inputs:
% =====================================================================
% buses:    List of bus numbers                (numbus x 1 vector)
% busGen1:  Bus generation in MW at time 1     (<=numbus x 3 vector)
% busLoad1: Bus load in MW at time 1           (<=numbus x 3 vector)
% busGen2:  Bus generation in MW at time 2     (<=numbus x 3 vector)
% busLoad2: Bus load in MW at time 2           (<=numbus x 3 vector)
% =====================================================================
%
% Outputs:
% =====================================================================
% diffS:    difference in busGen2 and busGen1        (numbus x 1 vector)
% diffB:    difference in busLoad2 and busLoad1      (numbus x 1 vector)  
% =====================================================================

busIndex = (1:numbuses).';

for c = 1:timesteps
    tempG1 = zeros(numbuses,1);
    tempL1 = zeros(numbuses,1);
    for a = 1:size(busGen1,1)
        A = busIndex(buses(:,1) == busGen1(a,1));
        tempG1(A) = busGen1(a,3);
    end
    for a = 1:size(busLoad1,1)
        A = busIndex(buses(:,1) == busLoad1(a,1));
        tempL1(A) = busLoad1(a,3);
    end
    tempG2 = tempG1;
    tempL2 = tempL1;
    for a = 1:size(busGen2,1)
        A = busIndex(buses(:,1) == busGen2(a,1));
        tempG2(A) = busGen2(a,c+2);
    end
    for a = 1:size(busLoad2,1)
        A = busIndex(buses(:,1) == busLoad2(a,1));
        tempL2(A) = busLoad2(a,c+2);
    end
    diffS(:,c) = tempG2 - tempG1;
    diffB(:,c) = tempL2 - tempL1;
end