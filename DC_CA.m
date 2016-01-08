% Contingency Analysis Algorithm: DC base power flow

% In DC power flow, assume Vs are all 1.0 and Qs are all 0s
% For generators (PV buses), we know all Ps and Vs
% For loads (PQ buses), we know all Ps and Qs
% theta = [B']^-1*P

%% INPUT: DEFINE POWER BASE
Sbase = 100;

%% Get the number of buses in the system
simauto.RunScriptCommand('EnterMode(Edit)');
fieldarray = {'BusNum','BusCat','BusNomVolt'};
results = simauto.GetParametersMultipleElement('bus',fieldarray,'');
buses = [str2double(results{2}{1}) str2double(results{2}{3})];
disp('Bus Information')
disp('    Bus#  kV')
disp(buses)
bustype = results{2}{2};
temp = size(buses);
numbuses = temp(1);
for a = 1:numbuses
    if strcmp(bustype(a), 'Slack')
       slack = buses(a); 
    end
end
disp('Slack Bus Number')
disp(slack)

% Get the number of generators in the system (PV buses)
fieldarray = {'BusNum', 'GenID', 'GenMW'};
results = simauto.GetParametersMultipleElement('gen',fieldarray,'');
gens = [str2double(results{2}{1}), str2double(results{2}{2}), str2double(results{2}{3})];
temp = size(gens);
numgens = temp(1);

% Get the number of loads in the system (PQ buses)
fieldarray = {'BusNum', 'LoadID', 'LoadMW'};
results = simauto.GetParametersMultipleElement('load',fieldarray,'');
loads = [str2double(results{2}{1}), str2double(results{2}{2}), str2double(results{2}{3})];
numloads = temp(1);

% Get the number of lines in the system
fieldarray = {'BusNum','BusNum:1','LineCircuit','LineR', 'LineX', 'LineC', 'LineLimMVA', 'LineStatus'};
results = simauto.GetParametersMultipleElement('branch',fieldarray,'');
lines = [str2double(results{2}{1}), str2double(results{2}{2}),...
    str2double(results{2}{3}) str2double(results{2}{4}),...
    str2double(results{2}{5}) str2double(results{2}{6}),...
    str2double(results{2}{7})];
disp('Line Information');
disp('    From      To        LineID       R        X         B      LimMVA');
disp(lines);
lineStatus = results{2}{8};
[numlines, B] = size(lines);
numlines;
