clc
clear all

simauto = actxserver('pwrworld.SimulatorAuto');
%simauto.OpenCase('C:\Users\lxiong7\Dropbox\ACES Research\PSERC EMS Project\Test Cases\3BUSEX_EQUALXs.pwb');
%simauto.OpenCase('C:\Users\lxiong7\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B3LP_NEWLINE.pwb');
simauto.OpenCase('C:\Users\lxiong7\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B7FLAT_DC.pwb');
%simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE Reliability\24Bus.pwb');

DC_CA

% %% INPUT: 3 BUS CASE PARAMETERS
% INPUT: SPECIFY SLACK BUS NUMBER
% slack = 1;
% % INPUT: DEFINE POWER BASE
% Sbase = 100;
% % INPUT: SPECIFY TRANSFER DIRECTION
% fromBus = 1; % Transfer direction defined as from this bus
% toBus = 3; % to this bus
% % Consider a change in generation
% % INPUT: SPECIFY THE INDEX OF THE NEW T-LINE
% newIndex = 3; % 3rd line in the list of lines
% Xab = 0.1; % reactance of new line

%% INPUT: DEFINE POWER BASE
Sbase = 100;

% Specify new lines to be added
% % INPUT: SPECIFY TRANSFER DIRECTION
% fromBus = 1; % Transfer direction defined as from this bus
% toBus = 3; % to this bus
% % Consider a change in generation
% % INPUT: SPECIFY THE INDEX OF THE NEW T-LINE
% newIndex = 3; % 3rd line in the list of lines
% Xab = 0.1; % reactance of new line

newlines = [1 3 2 0 0.24 0 65];
%            1 3 3 0 0.2 0 100]

% Assume these new lines are present in the system but open, simulate closing the new lines

% Calculate bus injections
busP = calcBusInj2(buses, gens, loads, Sbase)

%% Construct my own Ybus and Bp matrices
Ybus = calcYbus(buses, lines(:,1), lines(:,2), lines(:,4), lines(:,5), lines(:,6), lineStatus)
[Bp, Ybusp] = calcBp(buses, lines(:,1), lines(:,2), lines(:,5), slack, lineStatus)
invBp = inv(Bp);

%% Solve my own base case power flow for the first time step
[thetaD, lineflows] = DCPowerFlow(buses, invBp, slack, busP, lines, lineStatus)
                    
%% Get PTDFs, LODFs from PowerWorld
% simauto.RunScriptCommand('EnterMode(Run)');
% 
% str = sprintf('CalculatePTDF([BUS %d], [BUS %d], DC)', fromBus, toBus);
% simauto.RunScriptCommand(str);
% fieldarray = {'BusNum','BusNum:1','LineCircuit','LinePTDF:1', 'LinePTDF'};
% results = simauto.GetParametersMultipleElement('branch',fieldarray,'');
% temp = [str2double(results{2}{1}), str2double(results{2}{2})...
%        str2double(results{2}{3}), str2double(results{2}{4}) str2double(results{2}{5})];
% PTDFs = str2double(results{2}{5}); % transfer that appears on the branch at the From bus
% 
% PTDFs
% 
% % Get LODFs from PowerWorld
% for i = 1:numlines
%     str = sprintf('CalculateLODF([BRANCH %d %d %d], DC)', lines(i,1), lines(i,2), lines(i,3));
%     simauto.RunScriptCommand(str);
%     fieldarray = {'BusNum','BusNum:1','LineCircuit','LineLODF'};
%     results = simauto.GetParametersMultipleElement('branch',fieldarray,'');
%     LODFs(:,i) = str2double(results{2}{4});
% end
% 
% for i = 1:numlines
%     if strcmp(lineStatus(i),'Open')
%         LODFs(:,i) = zeros(numlines,1);
%     end
% end
% 
% LODFs

% Solve DC power flow in PowerWorld
% % Get the base case bus angles and line flows
% simauto.RunScriptCommand('EnterMode(Run)');
% str = sprintf('SolvePowerFlow(DC)');
% results = simauto.RunScriptCommand(str);
% fieldarray = {'BusNum','BusName','BusNomVolt','BusAngle'};
% results = simauto.GetParametersMultipleElement('bus',fieldarray,'');
% theta = str2double(results{2}{4}) % bus angles in degrees
% fieldarray = {'BusNum','BusNum:1','LineCircuit','LineMW'};
% results = simauto.GetParametersMultipleElement('branch',fieldarray,'');
% lineflows = str2double(results{2}{4}) % base case line flows

% Calculate % overload from line outage
% percentLOflow = zeros(numlines,numlines);
% for i = 1:numlines
%     percentLOflow(:,i) = postLOflows(:,i)./lines(:,4);
% end
% percentLOflow

for a = 1:size(newlines,1)
    a
    [pcflows, pcpcflows] = newLine(buses, lines, slack, lineStatus, newlines(a,:), thetaD, lineflows)
end

% Calculate % overload from line outage
perpcpcflows = zeros(numlines+1,numlines+1);
limits = [lines(:,7); newlines(:,7)];
for a = 1:numlines+1
    perpcpcflows(:,a) = pcpcflows(:,a)./limits*100;
end

% Only alert if % line flow >100%
flagged = zeros(numlines+1,numlines+1);
for i = 1:numlines+1
    for j = 1:numlines+1
        if abs(perpcpcflows(i,j)) > 100
            flagged(i,j) = perpcpcflows(i,j);
        end
    end
end
flagged

%Restore line status back to open

simauto.CloseCase();
delete(simauto);