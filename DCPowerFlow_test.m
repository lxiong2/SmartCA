% Leilei Xiong
% Date Created: 03/04/2013
% Date Revised: 05/14/2013

clc
clear all

%B3L4TestSystem
%B3L4TestSystem2
B4L5TestSystem

Sbase = 100;

%businj = calcBusInj(buses, gens, loads, Sbase, correctGen, correctLoad)
businj = calcBusInj2(buses, gens, loads, Sbase)

timesteps = size(businj,2)-1
for a = 1:timesteps
    [thetaD(:,a), lineP(:,a)] = DCPowerFlow(buses, invBp, slack, [businj(:,1) businj(:,a+1)], lines, status);
end
thetaD
lineP














