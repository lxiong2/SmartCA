% Leilei Xiong
% Date Created: 08/19/2013
% Date Revised: 08/19/2013

function [diffSvec, diffBvec] = calcDiffVector(buses, busGen1, busLoad1, busGens, busLoads)
% calcDiff:
% Calculates the change in generation/load at different points in time
%
% Inputs:
% =====================================================================
% buses:    List of bus numbers                (numbus x 1 vector)
% busGen1:  Bus generation in MW at time 1     (<=numbus x 3 vector)
% busLoad1: Bus load in MW at time 1           (<=numbus x 3 vector)
% busGens:  Vector of bus generation in MW at different times     (<=numbus x p vector)
% busLoads: Vector of bus load in MW at different times           (<=numbus x p vector)
% =====================================================================
%
% Outputs:
% =====================================================================
% diffSvec:    Vectors of busGen(col #) - busGen1                  (numbus x 1 vector)
% diffBvec:    Vectors of busLoad(col #) - busLoad1                (numbus x 1 vector)  
% =====================================================================

numbuses = size(buses,1);
timepts = size(busGens,2)-2;
diffSvec = zeros(numbuses, timepts);
diffBvec = zeros(numbuses, timepts);

for i = 1:timepts
    [diffSvec(:,i), diffBvec(:,i)] = calcDiff(buses, busGen1, busLoad1,...
        [busGens(:,1:2) busGens(:,i+2)], [busLoads(:,1:2) busLoads(:,i+2)]);
end