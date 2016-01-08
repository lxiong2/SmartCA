clc
clear all

tic

simauto = actxserver('pwrworld.SimulatorAuto');
%simauto.OpenCase('C:\Users\lxiong7\Dropbox\ACES Research\PSERC EMS Project\Test Cases\3BUSEX_EQUALXs.pwb');
%simauto.OpenCase('C:\Users\lxiong7\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B3LP_NEWLINE.pwb');
simauto.OpenCase('C:\Users\lxiong7\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B7FLAT_DC.pwb');
%simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B4L5TestSystem_diffV.pwb');
%simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE Reliability\24Bus_noShunts.pwb');

DC_CA

simauto.CloseCase();
delete(simauto);

%% Calculate bus injection
%busP = calcBusInj(numbuses, gens, loads, Sbase)
%busP = calcBusInj(numbuses, gens, loads, Sbase, correctGen, correctLoad)
% correctGen = zeros(numbuses,3);
% correctLoad = zeros(numbuses,3);
% busP = calcBusInj(buses, gens, loads, Sbase, correctGen, correctLoad)
busP = calcBusInj2(buses, gens, loads, Sbase);
disp('Bus Injections')
disp('    Bus#      Bus Injection [pu]')
disp(busP)

%% Construct my own Ybus
Ybus = calcYbus(buses, lines(:,1), lines(:,2), lines(:,4), lines(:,5), lines(:,6), lineStatus)
%Ybus = calcYbus(numbuses, FromBus, ToBus, R, X, B)

% Get Ybus matrix from PowerWorld (MUST BE IN RUN MODE)
% simauto.RunScriptCommand('EnterMode(Run)');
% simauto.RunScriptCommand('SaveYbusInMatlabFormat("C:\Users\lxiong7\Dropbox\ACES Research\PSERC EMS Project\Smart Contingency Analysis\ybus.m", YES)');
% ybus
% Ybus

%% Construct my own Bp matrix
[Bp, Ybusp] = calcBp(buses, lines(:,1), lines(:,2), lines(:,5), slack, lineStatus)
%Bp = calcBp(numbuses, FromBus, ToBus, X, slack)
%Ybusp = constructed Ybus if there are no line reactances; Bp is Ybusp with
%the row and column of the slack bus removed
invBp = inv(Bp);

%% Solve my own base case power flow for the first time step
[thetaD, lineflows] = DCPowerFlow(buses, invBp, slack, busP, lines, lineStatus);
disp('Power Flow Results')
disp('    Bus#      Bus Angle [deg]')
disp([buses(:,1) thetaD])
disp('    From      To        LineID   Line Flows [MW]')
disp([lines(:,1:3) lineflows])

% Solve DC power flow in PowerWorld
% % Get the base case bus angles and line flows
% simauto.RunScriptCommand('EnterMode(Run)');
% str = sprintf('SolvePowerFlow(DC)');
% results = simauto.RunScriptCommand(str);
% fieldarray = {'BusNum','BusName','BusNomVolt','BusAngle'};
% results = simauto.GetParametersMultipleElement('bus',fieldarray,'');
% thetaD = str2double(results{2}{4}) % bus angles in degrees
% fieldarray = {'BusNum','BusNum:1','LineCircuit','LineMW'};
% results = simauto.GetParametersMultipleElement('branch',fieldarray,'');
% lineflows = str2double(results{2}{4}) % base case line flows

% Calculate my own LODFs
[LODFs] = calcLODF(buses, Ybusp, invBp, lines, lineStatus, slack)

%% Consider a change in generation
% INPUT: SPECIFY NEW GENERATION/LOAD LEVELS

% New load profile at Bus 3
newload = [3 1 113.2 120 130 125 115];
disp('New Load Profile')
disp('    Bus#      LoadID    Time1     Time2     Time3     Time4     Time5')
disp(newload)

% Assumes all changes in generation are absorbed by gen at Bus 1
newgen = [1 1 154.7975+(newload(1,3:size(newload,2))-110)];
disp('New Generation Profile')
disp('    Bus#      GenID     Time1     Time2     Time3     Time4     Time5')
disp(newgen)

timesteps = size(newload,2)-2
toc

tic
[diffS, diffB] = calcDiff2(numbuses, buses, gens, loads, newgen, newload, timesteps)

%% Calculate PTDFs and LODFs

% Get PTDFs from PowerWorld
% simauto.RunScriptCommand('EnterMode(Run)');
% PTDFs = zeros(numlines,1);
% 
% str = sprintf('CalculatePTDF([BUS %d], [BUS %d], DC)', fromBus, toBus);
% simauto.RunScriptCommand(str);
% fieldarray = {'BusNum','BusNum:1','LineCircuit','LinePTDF:1', 'LinePTDF'};
% results = simauto.GetParametersMultipleElement('branch',fieldarray,'');
% temp = [str2double(results{2}{1}), str2double(results{2}{2})...
%        str2double(results{2}{3}), str2double(results{2}{4}) str2double(results{2}{5})];
% PTDFs(:) = str2double(results{2}{5}); % transfer that appears on the branch at the From bus
% 
% PTDFs

% Get LODFs from PowerWorld
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

% Calculate my own PTDFs for a specific transfer
% [PTDFs_vec] = calcDCPTDF(buses, Tvec, Ybusp, invBp, lines, slack, status)
[Tvec, pvec] = calcTvector2(buses, diffS, diffB, slack)

[PTDFs_T] = calcDCPTDF(buses, Tvec, Ybusp, invBp, lines, slack, lineStatus)

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

%% Calculate OTDFs and post-transfer post-contingency line flows
[OTDFs] = calcOTDF(PTDFs_T, LODFs, lineStatus)

%% CHECK GENCHANGE IN MORE DETAIL!!!
[ptpcflows] = genChange(numlines, LODFs, OTDFs, pvec, lineflows, lineStatus)

perptpcflows = zeros(numlines,numlines,timesteps);
for c = 1:timesteps
    % Calculate % overload from line outage
    for i = 1:numlines
        perptpcflows(:,i,c) = abs(ptpcflows(:,i,c))./lines(:,7)*100;
    end
    % Only alert if % line flow >100%
    flagged = [];
    for a = 1:numlines
        for b = 1:numlines
            if abs(perptpcflows(a,b,c)) > 100
                lineaffected = lines(a,1:2); %line affected
                lineoutaged = lines(b,1:2); %line outaged
                flagged = [flagged; lineoutaged lineaffected abs(perptpcflows(a,b,c))];
            end
        end
    end
    flagged
end
toc