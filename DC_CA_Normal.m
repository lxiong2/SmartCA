% Traditional CA: rerun DCPF for every time step

clc
clear all

%% Time Step 1
simauto = actxserver('pwrworld.SimulatorAuto');
simauto.OpenCase('C:\Users\lxiong7\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B7FLAT_DC.pwb');

DC_CA

simauto.CloseCase();
delete(simauto);

%% Construct my own Ybus
Ybus = calcYbus(buses, lines(:,1), lines(:,2), lines(:,4), lines(:,5), lines(:,6), lineStatus)
%Ybus = calcYbus(numbuses, FromBus, ToBus, R, X, B)

%% Construct my own Bp matrix
%Ybusp = constructed Ybus if there are no line reactances; Bp is Ybusp with
%the row and column of the slack bus removed
[Bp, Ybusp] = calcBp(buses, lines(:,1), lines(:,2), lines(:,5), slack, lineStatus)

invBp = inv(Bp);

% Calculate bus injections
busP = calcBusInj2(buses, gens, loads, Sbase)

% Solve my own base case power flow for the first time step
[thetaD, lineflows] = DCPowerFlow(buses, invBp, slack, busP, lines, lineStatus)

% Calculate my own LODFs
[LODFs, PTDFtable] = calcLODF(buses, Ybusp, invBp, lines, lineStatus, slack)

% Calculate my post-contingency line flows
[pcflows] = calcPCFlows(numlines, LODFs, lineflows, lineStatus)