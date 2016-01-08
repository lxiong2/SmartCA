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
[lineinc] = createIncidentMat(numbuses, buses, numlines, lines, lineStatus, slack)

% line reactances
lineXs = lines(:,5);
              
% all lines are monitored
phi = lineinc.'
Xm = diag(lineXs)
invXm = inv(Xm)

% Create list of pairs to be outaged
[pairs, numpairs] = linePairs(numlines, lineStatus)

PLm = zeros(numlines,numpairs);
perlimit = zeros(numlines,numpairs);

for a = 1:numpairs
    line1 = pairs(a,1);
    line2 = pairs(a,2);
    % psi is bus-to-tripped line incident matrix
    % Xo is a diagonal matrix of elements representing reactances of tripped lines
    psi = [lineinc(line1,:);
           lineinc(line2,:)].';
    Xo = diag([lineXs(line1) lineXs(line2)]);
    PTDF0oo(:,:,a) = -inv(Xo)*psi.'*invBp*psi;
    PTDF0mo(:,:,a) = -invXm*phi.'*invBp*psi;
    LODFmo(:,:,a) = PTDF0mo(:,:,a)*inv(eye(2)-PTDF0oo(:,:,a));
    PLm(:,a) = lineflows + LODFmo(:,:,a)*[lineflows(line1); lineflows(line2)];
    PLm(line1,a) = 0;
    PLm(line2,a) = 0;
    perlimit(:,a) = abs(PLm(:,a)./lines(:,7))*100;
end

PLm
perlimit;

