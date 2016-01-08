clc
clear all

tic

simauto = actxserver('pwrworld.SimulatorAuto');
simauto.OpenCase('C:\Users\lxiong7\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B7FLAT_DC.pwb');

DC_CA

simauto.CloseCase();
delete(simauto);

[Bp, Ybusp] = calcBp(buses, lines(:,1), lines(:,2), lines(:,5), slack, lineStatus)
invBp = inv(Bp);

busP = calcBusInj2(buses, gens, loads, Sbase);
[thetaD, lineflows] = DCPowerFlow(buses, invBp, slack, busP, lines, lineStatus)

% phi is bus-to-monitored line incident matrix
% Xm is a diagonal matrix of elements representing reactances of monitored lines

% % line 1-3 is monitored
% phi = [1 0 -1 0 0 0].';
% Xm = diag([0.24]);

% line incident matrix
lineinc = [1 -1 0 0 0 0;
           1 0 -1 0 0 0;
           0 1 -1 0 0 0;
           0 1 0 -1 0 0;
           0 1 0 0 -1 0;
           0 1 0 0 0 -1;
           0 0 1 -1 0 0;
           0 0 0 1 -1 0;
           0 0 0 0 -1 0;
           0 0 0 0 0 1;
           0 0 0 0 0 1]

lineXs = lines(:,5);
              
% all lines are monitored
phi = lineinc.'
Xm = diag(lineXs)

% psi is bus-to-tripped line incident matrix
% Xo is a diagonal matrix of elements representing reactances of tripped lines

% % line 1-2 is outaged
% psi = [lineinc(1,:)].'
% Xo = diag([lineXs(1)])

% % lines 1-2 and 2-4 are outaged
% psi = [lineinc(1,:);
%        lineinc(4,:)].'
% Xo = diag([lineXs(1) lineXs(4)])

line1 = 1;
line2 = 2;
psi = [lineinc(line1,:);
       lineinc(line2,:)].'
Xo = diag([lineXs(line1) lineXs(line2)])

PTDF0oo = -inv(Xo)*psi.'*invBp*psi

PTDF0mo = -inv(Xm)*phi.'*invBp*psi

eye(2) - PTDF0oo
det(eye(2)-PTDF0oo)
LODFmo = PTDF0mo*inv(eye(2)-PTDF0oo);
% LODFmo(1,1) = -1;
%LODFmo(4,2) = -1;
LODFmo

PLm = lineflows + LODFmo*[lineflows(line1); lineflows(line2)];
PLm(line1) = 0;
PLm(line2) = 0;
PLm

