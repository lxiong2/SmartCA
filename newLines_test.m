clear all
clc

%B3L4TestSystem
B3L4TestSystem2
%B4L5TestSystem

lines

Sbase = 100;

newLines = [1 3 2 0 0.1 0]
           % 1 3 2 0 0.2 0];
           
%newLines = [101 103 2 0 0.1 0]

busP = calcBusInj2(buses, gens, loads, Sbase);

%% Construct my own Ybus and Bp matrices for the base case
Ybus = calcYbus(buses, lines(:,1), lines(:,2), lines(:,4), lines(:,5), lines(:,6), status);
[Bp, Ybusp] = calcBp(buses, lines(:,1), lines(:,2), lines(:,5), slack, status);
invBp = inv(Bp);

%% Solve my own base case power flow for the first time step
[thetaD, lineflows] = DCPowerFlow(buses, invBp, slack, busP, lines, status)

for a = 1:size(newLines,1)
    a
    [pcflows, pcpcflows] = newLine(buses, lines, slack, status, newLines(a,:), thetaD, lineflows)
end