clear all
clc

simauto = actxserver('pwrworld.SimulatorAuto');
%simauto.OpenCase('C:\Users\lxiong7\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B7FLAT_DC.pwb');
%simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE Reliability\24Bus_DC.pwb');
simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE 118 Bus Case\118_DC.pwb')

DC_CA

simauto.CloseCase();
delete(simauto);

[Bp, Ybusp] = calcBp(buses, lines(:,1), lines(:,2), lines(:,5), slack, lineStatus);
invBp = inv(Bp);

busP = calcBusInj2(buses, gens, loads, Sbase);
[thetaD, lineflows] = DCPowerFlow(buses, invBp, slack, busP, lines, lineStatus);

outagedline = 20;
lineStatus2 = lineStatus;
lineStatus2(outagedline) = {'Open'};
[D] = Bp-calcBp(buses, lines(:,1), lines(:,2), lines(:,5), slack, lineStatus2);

% Remove slack bus
busIndex = (1:numbuses).';
slackIndex = busIndex(buses(:,1) == slack);
businj = zeros(numbuses-1,1);
businj(1:slackIndex-1,1) = busP(1:slackIndex-1,2);
businj(slackIndex:numbuses-1,1) = busP(slackIndex+1:numbuses,2);

theta = zeros(numbuses-1,1);
theta(1:slackIndex-1) = thetaD(1:slackIndex-1);
theta(slackIndex:numbuses-1) = thetaD(slackIndex+1:numbuses);

% Check times
tic
thetanew1 = perturb(theta, Bp, invBp, D, businj)
time1 = toc

tic
thetanew2 = inv(Bp+D)*businj
time2 = toc