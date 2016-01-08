clc
clear all

simauto = actxserver('pwrworld.SimulatorAuto');
% Enter the path that you saved 
simauto.OpenCase('C:\Users\lxiong7\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B7FLAT_DC.pwb');

%% DEFINE POWER BASE
% Implicitly assumed in PowerWorld to be 100
Sbase = 100;

%% Get the number of buses in the system
simauto.RunScriptCommand('EnterMode(Edit)');
fieldarray = {'BusNum','BusCat'};
results = simauto.GetParametersMultipleElement('bus',fieldarray,'');
buses = str2double(results{2}{1})
bustype = results{2}{2};
temp = size(buses);
numbuses = temp(1)
for a = 1:numbuses
    if strcmp(bustype(a), 'Slack')
       slack = a; 
    end
end
slack

% Get the number of generators in the system (PV buses)
fieldarray = {'BusNum', 'GenID', 'GenMW'};
results = simauto.GetParametersMultipleElement('gen',fieldarray,'');
gens = [str2double(results{2}{1}), str2double(results{2}{2}), str2double(results{2}{3})]
temp = size(gens);
numgens = temp(1)

% Get the number of loads in the system (PQ buses)
fieldarray = {'BusNum', 'LoadID', 'LoadMW'};
results = simauto.GetParametersMultipleElement('load',fieldarray,'');
loads = [str2double(results{2}{1}), str2double(results{2}{2}), str2double(results{2}{3})]
temp = size(loads);
numloads = temp(1)

% Get the number of lines in the system
fieldarray = {'BusNum','BusNum:1','LineCircuit','LineLimMVA', 'LineR', 'LineX', 'LineC', 'LineStatus'};
results = simauto.GetParametersMultipleElement('branch',fieldarray,'');
lines = [str2double(results{2}{1}), str2double(results{2}{2}),...
    str2double(results{2}{3}) str2double(results{2}{4}),...
    str2double(results{2}{5}) str2double(results{2}{6}),...
    str2double(results{2}{7})]
lineStatus = results{2}{8}
[numlines, B] = size(lines);
numlines

%% Solve DC power flow in PowerWorld
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

%% Calculate PTDFs and LODFs

% % Get PTDFs from PowerWorld
% simauto.RunScriptCommand('EnterMode(Run)');
% PTDFs = zeros(numlines,1);
% 
% fromBus = 1;
% toBus = 2;
% str = sprintf('CalculatePTDF([BUS %d], [BUS %d], DC)', fromBus, toBus);
% simauto.RunScriptCommand(str);
% fieldarray = {'BusNum','BusNum:1','LineCircuit','LinePTDF:1', 'LinePTDF'};
% results = simauto.GetParametersMultipleElement('branch',fieldarray,'');
% temp = [str2double(results{2}{1}), str2double(results{2}{2})...
%        str2double(results{2}{3}), str2double(results{2}{4}) str2double(results{2}{5})];
% PTDFs(:) = str2double(results{2}{5}); % transfer that appears on the branch at the From bus
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

simauto.CloseCase();
delete(simauto);