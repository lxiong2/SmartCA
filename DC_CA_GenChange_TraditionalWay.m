% Traditional CA for a change in injection (generation or load)
% Rerun DCPF for every time step

clc
clear all

%% Current (Base Case) System for t = 0
% Static; doesn't need to be re-run for a case where only generation/load changes

% Connect to PowerWorld and open a case
simauto = actxserver('pwrworld.SimulatorAuto');
%simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B7FLAT_DC.pwb')
%simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE PES GM 2014\B7FLAT_AC_moreload.pwb')
simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE PES GM 2014\24Bus_AC_changed6to10shunt_moreload.pwb');

% Extract PowerWorld case parameters
DC_CA

% Disconnect from PowerWorld
% simauto.CloseCase();
% delete(simauto);

% Construct my own Ybus
Ybus = calcYbus(buses, lines(:,1), lines(:,2), lines(:,4), lines(:,5), lines(:,6), lineStatus);
%Ybus = calcYbus(numbuses, FromBus, ToBus, R, X, B)

% Construct my own Bp matrix
%Ybusp = constructed Ybus if there are no line reactances; Bp is Ybusp with
%the row and column of the slack bus removed
[Bp, Ybusp] = calcBp(buses, lines(:,1), lines(:,2), lines(:,5), slack, lineStatus);

invBp = inv(Bp);

% Calculate my own LODFs
% [LODFs] = calcLODF(buses, Ybusp, invBp, lines, lineStatus, slack)

% Get LODFs from PowerWorld
simauto.RunScriptCommand('EnterMode(Run)');
for i = 1:numlines
    str = sprintf('CalculateLODF([BRANCH %d %d %d], DC)', lines(i,1), lines(i,2), lines(i,3));
    simauto.RunScriptCommand(str);
    fieldarray = {'BusNum','BusNum:1','LineCircuit','LineLODF'};
    results = simauto.GetParametersMultipleElement('branch',fieldarray,'');
    LODFs(:,i) = str2double(results{2}{4});
end

for i = 1:numlines
    if strcmp(lineStatus(i),'Open')
        LODFs(:,i) = zeros(numlines,1);
    end
end

LODFs = LODFs.';

%% Needs to be rerun every time for subsequent time steps

% Calculate bus injections
% busP = calcBusInj2(buses, gens, loads, Sbase);
% disp('Bus Injections')
% disp('    Bus#      Bus Injection [pu]')
% disp(busP)

% % Solve my own base case power flow for the first time step
% [basethetaD, baselineflows] = DCPowerFlow(buses, invBp, slack, busP, lines, lineStatus)
% % disp('Base Case Power Flow Results')
% % disp('    Bus#      Bus Angle [deg]')
% % disp([buses(:,1) thetaD])
% % disp('    From      To        LineID   Line Flows [MW]')
% % disp([lines(:,1:3) lineflows])
% 
% % Calculate my post-contingency line flows
% [pcflows] = calcPCFlows(numlines, LODFs, lineflows, lineStatus);
% 
% % Calculate % overload from line outage
% perpcflows = zeros(numlines,numlines);
% for i = 1:numlines
%     perpcflows(:,i) = abs(pcflows(:,i))./lines(:,7)*100;
% end
% 
% flagged = [];
% for a = 1:numlines
%     for b = 1:numlines
%         if abs(perpcflows(a,b)) > 100
%             lineaffected = lines(a,1:2); %line affected
%             lineoutaged = lines(b,1:2); %line outaged
%             flagged = [flagged; lineoutaged lineaffected abs(perpcflows(a,b))];
%         end
%     end
% end
% disp('Base Case Contingency Analysis Results')
% disp('    Line Outaged        Line Affected    % Overload')
% disp(flagged)

%% New load profile at Bus 3
%newload = [3 1 113.2 120 130 125 115];

% newload = [101 1 118.8;
%            102 1 106.7;
%            103 1 198;
%            104 1 81.4;
%            105 1 78.1;
%            106 1 149.6;
%            107 1 137.5;
%            108 1 188.1;
%            109 1 192.5;
%            110 1 214.5;
%            113 1 291.5;
%            114 1 213.4;
%            115 1 348.7;
%            116 1 110;
%            118 1 366.3;
%            119 1 199.1;
%            120 1 140.8]

% newload = [3 1 130;
%            5 1 140]

% Base Case
% 110 1 195, 108 1 171
% newload = [108 1 210;
%            110 1 225];

% newgen = [101 1 152;
%           102 1 152;
%           107 1 240;
%           113 1 521;
%           115 1 155;
%           116 1 155;
%           118 1 400;
%           121 1 400;
%           122 1 300;
%           123 1 600]

% disp('New Load Profile')
% disp('    Bus#      LoadID    Time1     Time2     Time3     Time4     Time5')
% disp(newload)

% Assumes all changes in generation are absorbed by gen at Bus 1
%newgen = [1 1 154.7975+(newload(1,3:size(newload,2))-110)];
% newgen = [113 1 498.1203079];

% newgen = [1 1 170.2;
%           2 1 169.8]

% newgen = [101 1 6.9;
%           102 1 6.9;
%           107 1 6.9;
%           113 1 6.9;
%           115 1 6.9;
%           116 1 6.9;
%           118 1 6.9;
%           121 1 6.9;
%           122 1 6.9;
%           123 1 6.9];
% disp('New Generation Profile')
% disp('    Bus#      GenID     Time1     Time2     Time3     Time4     Time5')
% disp(newgen)
% 
% timesteps = size(newload,2)-2;

% Solve AC power flow in PowerWorld
simauto.RunScriptCommand('EnterMode(Run)');
str = sprintf('SolvePowerFlow(AC)');
results = simauto.RunScriptCommand(str);
fieldarray = {'BusNum','BusName','BusNomVolt','BusAngle'};
results = simauto.GetParametersMultipleElement('bus',fieldarray,'');
theta = str2double(results{2}{4}) % bus angles in degrees
fieldarray = {'BusNum','BusNum:1','LineCircuit','LineMW'};
results = simauto.GetParametersMultipleElement('branch',fieldarray,'');
lineflows = str2double(results{2}{4}) % base case line flows

simauto.CloseCase();
delete(simauto);

% thetaD = zeros(numbuses,timesteps+1);
% lineflows = zeros(numlines,timesteps+1);
% % calcBusInj(buses, genList, loadList, correctGen, correctLoad, Sbase)
% disp('Contingency Analysis Results for Future Time Steps')
% [busP, busGen, busLoad] = calcBusInj(buses, gens, loads, newgen, newload, timesteps, Sbase);
% pcflows = zeros(numlines, numlines, timesteps);
% perpcflows = zeros(numlines, numlines, timesteps);
% 
% for c = 1:timesteps+1
%     [thetaD(:,c), lineflows(:,c)] = DCPowerFlow(buses, invBp, slack, [busP(:,1) busP(:,c+1)], lines, lineStatus);
%     [pcflows(:,:,c)] = calcPCFlows(numlines, LODFs, lineflows(:,c), lineStatus);
% end
% 
% for c = 1:timesteps+1
%     for i = 1:numlines
%         perpcflows(:,i,c) = abs(pcflows(:,i,c))./lines(:,7)*100;
%     end
%     flagged = [];
%     for a = 1:numlines
%         for b = 1:numlines
%             if abs(perpcflows(a,b,c)) > 100
%                 lineaffected = lines(a,1:2); %line affected
%                 lineoutaged = lines(b,1:2); %line outaged
%                 flagged = [flagged; lineoutaged lineaffected abs(perpcflows(a,b,c))];
%             end
%         end
%     end
%     flagged
% end
% thetaD;
% lineflows;
% perpcflows;
