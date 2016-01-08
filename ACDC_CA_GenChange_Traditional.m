% Traditional CA for a change in injection (generation or load)
% Run base case ACPF for every time step
% Then use linear sensitivities to get line flows

clc
clear all

%% Connect to PowerWorld and open a case
simauto = actxserver('pwrworld.SimulatorAuto');
%simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B7FLAT_DC.pwb')
%simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE PES GM 2014\B7FLAT_AC_moreload.pwb')
simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE PES GM 2014\24Bus_AC_changed6to10shunt_moreload.pwb');

% Extract PowerWorld case parameters
DC_CA

% Construct my own Ybus
Ybus = calcYbus(buses, lines(:,1), lines(:,2), lines(:,4), lines(:,5), lines(:,6), lineStatus);

% Construct my own Bp matrix
%Ybusp = constructed Ybus if there are no line reactances; Bp is Ybusp with
%the row and column of the slack bus removed
%[Bp, Ybusp] = calcBp(buses, lines(:,1), lines(:,2), lines(:,5), slack, lineStatus);
%invBp = inv(Bp);

% Calculate my own LODFs
%[LODFs] = calcLODF(buses, Ybusp, invBp, lines, lineStatus, slack)

% % Get LODFs from PowerWorld
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

LODFs = LODFs.'

%% Needs to be rerun every time for subsequent time steps

% Solve AC power flow in PowerWorld
simauto.RunScriptCommand('EnterMode(Run)');
str = sprintf('SolvePowerFlow(AC)');
results = simauto.RunScriptCommand(str);
fieldarray = {'BusNum','BusName','BusNomVolt','BusAngle'};
results = simauto.GetParametersMultipleElement('bus',fieldarray,'');
thetaD = str2double(results{2}{4}) % bus angles in degrees
thetaR = thetaD*2*pi/360;
fieldarray = {'BusNum','BusNum:1','LineCircuit','LineMW','LineMVR'};
results = simauto.GetParametersMultipleElement('branch',fieldarray,'');
MWflows = str2double(results{2}{4}) % base case line flows
MVARflows = str2double(results{2}{5})
MVAflows = sqrt(MWflows.^2+MVARflows.^2)

simauto.CloseCase();
delete(simauto);

% % Calculate line flow in MW under DC assumptions
% lineP = zeros(numlines,1);
% busIndex = (1:numbuses).';
% for i = 1:numlines
%     if strcmp(lineStatus(i),'Closed')
%         fromIndex = busIndex(buses(:,1) == lines(i,1));
%         toIndex = busIndex(buses(:,1) == lines(i,2));
%         lineP(i) = 1/lines(i,5)*(thetaR(fromIndex)-thetaR(toIndex))*100;
%     else lineP(i) = 0;
%     end
% end
% lineP

lineflows1 = calcPCFlows(numlines, LODFs, MWflows, lineStatus)

% Option 1: just use MW flows and ignore MVAR flows entirely, pretend MVA
% limits are actually MW limits
% for i = 1:numlines
%     perpcflows1(:,i) = abs(lineflows1(:,i))./lines(:,7)*100;
% end
% perpcflows1

% Option 2: just use MW flows, then add to MVAR flows and check against MVA
% limits
for a = 1:numlines
    MVAflows2(:,a) = sqrt(lineflows1(:,a).^2+MVARflows.^2);
end
MVAflows2
for i = 1:numlines
    perpcflows2(:,i) = abs(MVAflows2(:,i))./lines(:,7)*100;
end
perpcflows2

% Option 3: Use the transmission line operating circle concept - seems too
% complicated and doesn't yield any interesting information

% % THIS OPTION IS WRONG SINCE DFs ONLY WORK FOR ACTIVE POWER INJECTIONS
% % Option 3: Use MVA line flows 
% lineflows3 = calcPCFlows(numlines, LODFs, MVAflows, lineStatus)
% for i = 1:numlines
%     perpcflows3(:,i) = abs(lineflows3(:,i))./lines(:,7)*100;
% end
% perpcflows3

% flagged = [];
% for a = 1:numlines
%     for b = 1:numlines
%         if abs(perpcflows1(a,b)) > 95
%             lineaffected = lines(a,1:2); %line affected
%             lineoutaged = lines(b,1:2); %line outaged
%             flagged = [flagged; lineoutaged lineaffected abs(perpcflows1(a,b))];
%         end
%     end
% end
% flagged

flagged2 = [];
for a = 1:numlines
    for b = 1:numlines
        if abs(perpcflows2(a,b)) > 90
            lineaffected = lines(a,1:2); %line affected
            lineoutaged = lines(b,1:2); %line outaged
            flagged2 = [flagged2; lineoutaged lineaffected abs(perpcflows2(a,b))];
        end
    end
end
flagged2
