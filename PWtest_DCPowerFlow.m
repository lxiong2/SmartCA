% Leilei Xiong

clc
clear all
format long

% Connect to PowerWorld and open a case
simauto = actxserver('pwrworld.SimulatorAuto');
simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B7FLAT_DC_noshunts.pwb');

% Extract PowerWorld case parameters
DC_CA

% % Get the base case bus angles and line flows
simauto.RunScriptCommand('EnterMode(Run)');
str = sprintf('SolvePowerFlow(DC)');
results = simauto.RunScriptCommand(str);
fieldarray = {'BusNum','BusName','BusNomVolt','BusAngle'};
results = simauto.GetParametersMultipleElement('bus',fieldarray,'');
thetaD_PW = str2double(results{2}{4}) % bus angles in degrees
fieldarray = {'BusNum','BusNum:1','LineCircuit','LineMW'};
results = simauto.GetParametersMultipleElement('branch',fieldarray,'');
lineflows_PW = str2double(results{2}{4}); % base case line flows

% Disconnect from PowerWorld
simauto.CloseCase();
delete(simauto);

% Higher precision theta
% thetaD_PW = [7.529482338;
%         4.206555574;
%         -0.464988673;
%         -0.352127486;
%         -1.402185499;
%         2.804370383;
%         0]

thetaR = thetaD_PW*pi/180;

lineP1 = zeros(numlines,1);
for i = 1:numlines
    if strcmp(lineStatus(i),'Closed')
        fromIndex = find(buses(:,1) == lines(i,1));
        toIndex = find(buses(:,1) == lines(i,2));
        lineP1(i) = 1/lines(i,5)*sin(thetaR(fromIndex)-thetaR(toIndex))*100;     
    else lineP1(i) = 0;
    end
end

%% Construct my own Ybus
[myYbus] = calcYbus(buses, lines(:,1), lines(:,2), lines(:,4), lines(:,5), lines(:,6), lineStatus)

% Calculate my own Bp
[Bp, Ybusp] = calcBp(buses, lines(:,1), lines(:,2), lines(:,5), slack, lineStatus);

lineP2 = zeros(numlines,1);
for i = 1:numlines
    if strcmp(lineStatus(i),'Closed')
        fromIndex = find(buses(:,1) == lines(i,1));
        toIndex = find(buses(:,1) == lines(i,2));
        lineP2(i) = 1/lines(i,5)*(thetaR(fromIndex)-thetaR(toIndex))*100;     
    else lineP2(i) = 0;
    end
end

lineflows_PW
lineP1
lineP2



