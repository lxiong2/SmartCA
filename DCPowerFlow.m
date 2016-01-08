% Leilei Xiong
% Date Created: 03/01/2013
% Date Revised: 03/27/2013

% Assumes small angle approximation, instead of Pjk = 1/Xjk*sin(thetaj -
% thetak), it's just Pjk = 1/Xjk*(thetaj-thetak)

function [thetaD, lineP] = DCPowerFlow(buses, invBp, slack, busP, lines, status)
% DCPowerFlow:
% Solves the DC power flow using the decoupled power flow equation
% Assumes reactive power = 0
% Assumes voltages = 1.0 pu
%
% Inputs:
% =====================================================================
% buses:        List of bus numbers             (numbus x 1 vector)
% Bp:           Decoupled Bp matrix             (sparse (numbus-1) x
% (numbus-1) matrix)
% slack:        Slack bus number                (scalar)
% busP:         Power injection at each bus     (numbus x timesteps+1 vector)
% lines:        Line parameters                 (numlines x 7 matrix)
% status:       Status of each line
%               'Open' or 'Closed'              (column vector)
% =====================================================================
%
% Outputs:
% =====================================================================
% thetaD:       Bus angle in degrees            (numbus x timesteps vector)
% lineP:        Power flow on each line         (numlines x timesteps vector)
% =====================================================================

numbuses = size(busP,1);
numlines = size(lines,1);

busIndex = (1:numbuses).';
slackIndex = busIndex(buses(:,1) == slack);

% Remove slack bus
businj = zeros(numbuses-1,1);

businj(1:slackIndex-1,1) = busP(1:slackIndex-1,2);
businj(slackIndex:numbuses-1,1) = busP(slackIndex+1:numbuses,2);

thetaR = zeros(numbuses,1);
temp = -invBp*businj;

thetaR(1:slackIndex-1) = temp(1:slackIndex-1);
thetaR(slackIndex+1:numbuses) = temp(slackIndex:numbuses-1);

% Convert from radians to degrees
thetaD = thetaR*180/pi;

lineP = zeros(numlines,1);

% PowerWorld uses the small angle assumption
for i = 1:numlines
    if strcmp(status(i),'Closed')
        fromIndex = busIndex(buses(:,1) == lines(i,1));
        toIndex = busIndex(buses(:,1) == lines(i,2));
        lineP(i) = 1/lines(i,5)*(thetaR(fromIndex)-thetaR(toIndex))*100;
    else lineP(i) = 0;
    end
end
