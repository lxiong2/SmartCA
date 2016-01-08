% Leilei Xiong
% Date Created: 08/19/2013
% Date Revised: 08/19/2013

function [diffS, diffB] = calcDiff(buses, busGen1, busLoad1, busGen2, busLoad2)
% calcDiff:
% Calculates the change in generation/load at different points in time
%
% Inputs:
% =====================================================================
% buses:    List of bus numbers                (numbus x 1 vector)
% busGen1:  Bus generation in MW at time 1     (<=numbus x 3 vector)
% busLoad1: Bus load in MW at time 1           (<=numbus x 3 vector)
% busGen2:  Bus generation in MW at time 1     (<=numbus x 3 vector)
% busLoad2: Bus load in MW at time 1           (<=numbus x 3 vector)
% =====================================================================
%
% Outputs:
% =====================================================================
% diffS:    busGen2 - busGen1                  (numbus x 1 vector)
% diffB:    busLoad2 - busLoad1                (numbus x 1 vector)  
% =====================================================================

numbuses = size(buses,1);
timesteps = size(busGen2,2)-2;
diffS = zeros(numbuses,timesteps);
diffB = zeros(numbuses,timesteps);

for c = 1:timesteps
    for a = 1:size(busGen2,1)
        A = find(buses(:,1) == busGen2(a,1))
        B = find(busGen2(a,1) == busGen1(:,1))
        diffS(A,c) = busGen2(A,c+2)-busGen1(B,3);
    end
    for a = 1:size(busLoad2,1)
        A = find(buses(:,1) == busLoad2(a,1))
        B = find(busLoad2(a,1) == busLoad1(:,1))
        diffB(A,c) = busLoad2(A,c+2)-busLoad1(B,3);
    end
end