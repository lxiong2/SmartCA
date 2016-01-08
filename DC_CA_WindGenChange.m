% Contingency Analysis Algorithm: DC base power flow

% In DC power flow, assume Vs are all 1.0 and Qs are all 0s
% For generators (PV buses), we know all Ps and Vs
% For loads (PQ buses), we know all Ps and Qs
% theta = [B']^-1*P

clc
clear all
close all

simauto = actxserver('pwrworld.SimulatorAuto');
%simauto.OpenCase('C:\Users\lxiong7\Dropbox\ACES Research\PSERC EMS Project\Test Cases\3BUSEX_EQUALXs.pwb');
%simauto.OpenCase('C:\Users\lxiong7\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B3LP_NEWLINE.pwb');
simauto.OpenCase('C:\Users\lxiong7\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B7FLAT_DC.pwb');

%% INPUT: SPECIFY SLACK BUS NUMBER
slack = 7;
% INPUT: DEFINE POWER BASE
Sbase = 100;
% INPUT: SPECIFY TRANSFER DIRECTION
fromBus = 1; % Transfer direction defined as from this bus
toBus = 3; % to this bus
% Consider a change in generation

%% INPUT: Enter forecasted wind values 
% Sample from 05/01/2013 at 12:00AM (UTC-7:00 in PDT, UTC-8:00 in PST)
% Divide by 1000 to normalize and scale
% injected at Bus 1
windMin = [435 249 139 98 80 77 62 33 15 10 8 13 19 36 35 32 38 51 65 88 107 99 93 84]/1000*200
windMax = [909 625 431 373 352 351 283 169 89 60 48 64 81 113 139 154 190 251 308 393 437 443 423 396]/1000*200

%windMin = [435 249 139 98 80 77 62 33 15 10 8 13 19 36 35 32 38 51 65 88 107 99 93 84]/1000*80
%windMax = [909 625 431 373 352 351 283 169 89 60 48 64 81 113 139 154 190 251 308 393 437 443 423 396]/1000*80

%windMin = [435 249 139 98 80 77]/1000*80
%windMax = [909 625 431 373 352 351]/1000*80

figure
plot(windMin)
hold on
plot(windMax,'r')
title('Wind Output')
xlabel('Time [hr]')
ylabel('Wind Generation [MW]')
legend('Min','Max')
%axis([1 24 0 200])

% INPUT: SPECIFY TRANSFER AMOUNT
%amount = -20; % 20 MW decrease at fromBus
windSize = length(windMax);
amountMin = windMin - windMax(1)*ones(1,windSize)
amountMax = windMax - windMax(1)*ones(1,windSize)

%% Get the number of buses in the system
simauto.RunScriptCommand('EnterMode(Edit)');
fieldarray = {'BusNum','BusCat'};
results = simauto.GetParametersMultipleElement('bus',fieldarray,'');
buses = [str2double(results{2}{1}), str2double(results{2}{2})];
temp = size(buses);
numbuses = temp(1)

% Get the number of generators in the system (PV buses)
fieldarray = {'BusNum', 'GenID', 'GenMW'};
results = simauto.GetParametersMultipleElement('gen',fieldarray,'');
gens = [str2double(results{2}{1}), str2double(results{2}{2}), str2double(results{2}{3})];
temp = size(gens);
numgens = temp(1)

% Get the number of loads in the system (PQ buses)
fieldarray = {'BusNum', 'LoadID', 'LoadMW'};
results = simauto.GetParametersMultipleElement('load',fieldarray,'');
loads = [str2double(results{2}{1}), str2double(results{2}{2}), str2double(results{2}{3})];
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

%% INPUT: modify PowerWorld bus injection values
correctGen = [1 1 windMax(1)]
correctLoad = [3 1 windMax(1)+gens(2,3)]

% Calculate bus injection
busP = calcBusInj(numbuses, gens, loads, Sbase, correctGen, correctLoad)

%% Get PTDFs from PowerWorld
simauto.RunScriptCommand('EnterMode(Run)');
PTDFs = zeros(numlines,1);

str = sprintf('CalculatePTDF([BUS %d], [BUS %d], DC)', fromBus, toBus);
simauto.RunScriptCommand(str);
fieldarray = {'BusNum','BusNum:1','LineCircuit','LinePTDF:1', 'LinePTDF'};
results = simauto.GetParametersMultipleElement('branch',fieldarray,'');
temp = [str2double(results{2}{1}), str2double(results{2}{2})...
       str2double(results{2}{3}), str2double(results{2}{4}) str2double(results{2}{5})];
PTDFs(:) = str2double(results{2}{5}); % transfer that appears on the branch at the From bus

PTDFs

% Get LODFs from PowerWorld
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

LODFs

% Calculate my own PTDFs

%% Solve my own base case DC power flow and get my own base case line flows
Ybus = calcYbus(numbuses, lines(:,1), lines(:,2), lines(:,5), lines(:,6), lines(:,7), lineStatus)
%Ybus = calcYbus(numbuses, FromBus, ToBus, R, X, B)

% Get Ybus matrix from PowerWorld (MUST BE IN RUN MODE)
% simauto.RunScriptCommand('EnterMode(Run)');
% simauto.RunScriptCommand('SaveYbusInMatlabFormat("C:\Users\lxiong7\Dropbox\ACES Research\PSERC EMS Project\Smart Contingency Analysis\ybus.m", YES)');
% ybus
% Ybus

%% Solve my own DC power flow
Bp = calcBp(numbuses, lines(:,1), lines(:,2), lines(:,6), slack, lineStatus)
%Bp = calcBp(numbuses, FromBus, ToBus, X, slack)

[thetaD, lineflows] = DCPowerFlow(Bp, slack, busP, lines, lineStatus)

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

%% Example: 
% If I outage Line 1-2, use LODFs121
% postflow12 = lineflows(1,4) + LODFs121(1,4)/100*lineflows(1,4) 
% postflow13 = lineflows(2,4) + LODFs121(2,4)/100*lineflows(1,4) 
% postflow23 = lineflows(3,4) + LODFs121(3,4)/100*lineflows(1,4)
% If I outage Line 1-3, use LODFs131
% postflow12 = lineflows(1,4) + LODFs131(1,4)/100*lineflows(2,4) 
% postflow13 = lineflows(2,4) + LODFs131(2,4)/100*lineflows(2,4) 
% postflow23 = lineflows(3,4) + LODFs131(3,4)/100*lineflows(2,4)
% If I outage Line 2-3, use LODFs231
% postflow12 = lineflows(1,4) + LODFs231(1,4)/100*lineflows(3,4) 
% postflow13 = lineflows(2,4) + LODFs231(2,4)/100*lineflows(3,4) 
% postflow23 = lineflows(3,4) + LODFs231(3,4)/100*lineflows(3,4)

% Find post-contingency flows on each line using the LODFs
% Postflow on line i after outaging line j is equal to the flow on line i +
% LODF(i,j) * the flow on line j
% postLOflows = zeros(numlines, numlines);
% for i = 1:numlines % the line that is being outaged
%     for j = 1:numlines % the line that we want to calculate the post flow for
%         postLOflows(i,j) = lineflows(i) + LODFs(i,j)/100*lineflows(j);
%     end
% end
% postLOflows

% Calculate % overload from line outage
% percentLOflow = zeros(numlines,numlines);
% for i = 1:numlines
%     percentLOflow(:,i) = postLOflows(:,i)./lines(:,4);
% end
% percentLOflow

OTDFs = calcOTDF(numlines, PTDFs, LODFs, lineStatus)

minptpcflows = zeros(numlines, numlines, windSize);
for i = 1:windSize
    minptpcflows(:,:,i) = genChange(numlines, LODFs, OTDFs, amountMin(i), lineflows, lineStatus);
end
minptpcflows

maxptpcflows = zeros(numlines, numlines, windSize);
for i = 1:windSize
    maxptpcflows(:,:,i) = genChange(numlines, LODFs, OTDFs, amountMax(i), lineflows, lineStatus);
end
maxptpcflows

% Calculate % overload from line outage
minperptpcflows = zeros(numlines, numlines, windSize);
for i = 1:windSize
    for j = 1:numlines
        minperptpcflows(:,j,i) = minptpcflows(:,j,i)./lines(:,4)*100;
    end
end
minperptpcflows

maxperptpcflows = zeros(numlines, numlines, windSize);
for i = 1:windSize
    for j = 1:numlines
        maxperptpcflows(:,j,i) = maxptpcflows(:,j,i)./lines(:,4)*100;
    end
end
maxperptpcflows

%% Plot number of flagged contingencies
minnumflag = zeros(1,windSize);
for i = 1:windSize
    if sum(sum(minperptpcflows(:,:,i)>100)) > 0 
        minnumflag(i) = minnumflag(i) + sum(sum(minperptpcflows(:,:,i)>100));
    end
end
minnumflag

maxnumflag = zeros(1,windSize);
for i = 1:windSize
    if sum(sum(maxperptpcflows(:,:,i)>100)) > 0 
        maxnumflag(i) = maxnumflag(i) + sum(sum(maxperptpcflows(:,:,i)>100));
    end
end
maxnumflag

figure(2)
plot(1:windSize,minnumflag)
hold on
plot(1:windSize,maxnumflag,'r')
title('Number of limit violations over time')
xlabel('Time [hr]')
ylabel('Number of limit violations')
legend('Min','Max')
axis([1 windSize 0 max(maxnumflag)+3])
    
%% Plot the sysAMWCO
minsysAMWCO = zeros(1,windSize);
minAMWCO = zeros(numlines,windSize);
for i = 1:windSize
    for j = 1:numlines
        for k = 1:numlines
            if minperptpcflows(j,k,i) > 100
                minAMWCO(j,i) = minAMWCO(j,i) + (minperptpcflows(j,k,i)-100);
            end
        end
    end
    minsysAMWCO(i) = sum(minAMWCO(:,i).*lines(:,4)); 
end
minAMWCO
minsysAMWCO

maxsysAMWCO = zeros(1,windSize);
maxAMWCO = zeros(numlines,windSize);
for i = 1:windSize
    for j = 1:numlines
        for k = 1:numlines
            if maxperptpcflows(j,k,i) > 100
                maxAMWCO(j,i) = maxAMWCO(j,i) + (maxperptpcflows(j,k,i)-100);
            end
        end
    end
    maxsysAMWCO(i) = sum(maxAMWCO(:,i).*lines(:,4)); 
end
maxAMWCO
maxsysAMWCO

figure(3)
plot(1:windSize,minsysAMWCO)
hold on
plot(1:windSize,maxsysAMWCO,'r')
title('SysAMWCO over Time')
xlabel('Time [hr]')
ylabel('SysAMWCO [MWCO]')
legend('Min','Max')
axis([1 windSize 0 max(maxsysAMWCO)+5])

% 
% % Only alert if % line flow >100%
% flagged = zeros(numlines,numlines);
% for i = 1:numlines
%     for j = 1:numlines
%         if abs(perptpcflows(i,j)) > 100
%             flagged(i,j) = perptpcflows(i,j);
%         end
%     end
% end
% flagged

simauto.CloseCase();
delete(simauto);