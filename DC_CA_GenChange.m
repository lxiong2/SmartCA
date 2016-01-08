clc
clear all

simauto = actxserver('pwrworld.SimulatorAuto');
simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE PES GM 2014\B7FLAT_AC.pwb')
%simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE Reliability\24Bus_DC.pwb');
%simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE Reliability\24Bus_DC_OPF.pwb');
%simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE PES GM 2014\24Bus_AC_changed6to10shunt.pwb');

DC_CA

%% Consider a change in generation
% INPUT: SPECIFY NEW GENERATION/LOAD LEVELS

% PowerWorld 7 Bus Case More Load/Gen Case 1
% New load profile at Bus 3
newload = [3 1 130 140 150 160 170;
           5 1 140 150 160 170 180];
newgen = [1 1 108.21 112.82 117.1 121.88 126.37;
          2 1 180.06 187.82 195.22 203.01 210.69;
          4 1 109.21 118.07 126.68 135.76 144.62];

% PowerWorld 7 Bus Case More Load/Gen Case 2
% Assumes all changes in generation are absorbed by gen at Bus 1
% newload = [3 1 100 113.2 125];
% newgen = [1 1 154.7975+(newload(1,3:size(newload,2))-110)];

%newgen = [113 1 498.1203079];

% IEEE 24 Bus More Load/Gen Case 1
% newload = [108 1 210;
%            110 1 225];
% newgen = [107 1 240;
%           113 1 521];

% IEEE 24 Bus More Load/Gen Case 2
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
% newgen = [101 1 192;
%           102 1 192;
%           107 1 147.29;
%           113 1 535.6;
%           115 1 215;
%           116 1 155;
%           118 1 400;
%           121 1 400;
%           122 1 300;
%           123 1 600]
      
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

% newstatus = [1 0 1 0 1 0;
%              4 1 0 0 0 0;];

timesteps = size(newload,2)-2;
timelength = 5; % minutes

% statusVec = convertStatus(numlines, lineStatus, newstatus(:,1), newstatus(:,2:timesteps+1), timesteps);

%% Calculate bus injection
%[busP, busGen, busLoad] = calcBusInj(buses, gens, loads, newgen, newload, timesteps, Sbase);
%busP = calcBusInj2(buses, gens, loads, Sbase);
% disp('Bus Injections')
% disp('    Bus#      Bus Injection [pu]')
% disp([busP(:,1) busP(:,2)])

%% Construct my own Ybus
Ybus = calcYbus(buses, lines(:,1), lines(:,2), lines(:,4), lines(:,5), lines(:,6), lineStatus);

%% Construct my own Bp matrix
[Bp, Ybusp] = calcBp(buses, lines(:,1), lines(:,2), lines(:,5), slack, lineStatus);
%Bp = calcBp(numbuses, FromBus, ToBus, X, slack)
%Ybusp = constructed Ybus if there are no line reactances; Bp is Ybusp with
%the row and column of the slack bus removed
invBp = inv(Bp)

%% Solve my own base case power flow for the first time step
% [thetaD, lineflows] = DCPowerFlow(buses, invBp, slack, busP, lines, lineStatus);
% disp('Power Flow Results')
% disp('    Bus#      Bus Angle [deg]')
% disp([buses(:,1) thetaD])
% disp('    From      To        LineID   Line Flows [MW]')
% disp([lines(:,1:3) lineflows])

% Calculate my own LODFs
%[LODFs] = calcLODF(buses, Ybusp, invBp, lines, lineStatus, slack)


%% Solve AC power flow in PowerWorld
simauto.RunScriptCommand('EnterMode(Run)');
str = sprintf('SolvePowerFlow(AC)');
results = simauto.RunScriptCommand(str);
fieldarray = {'BusNum','BusName','BusNomVolt','BusAngle'};
results = simauto.GetParametersMultipleElement('bus',fieldarray,'');
thetaD = str2double(results{2}{4}) % bus angles in degrees
thetaR = thetaD*2*pi/360;
fieldarray = {'BusNum','BusNum:1','LineCircuit','LineMW','LineMVR'};
results = simauto.GetParametersMultipleElement('branch',fieldarray,'');
lineflows = str2double(results{2}{4}) % base case line flows
MWflows = lineflows;
MVARflows = str2double(results{2}{5})
MVAflows = sqrt(MWflows.^2+MVARflows.^2);

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

simauto.CloseCase();
delete(simauto);

fid = fopen('CAresults.txt','w');
write2file_present

[diffS, diffB] = calcDiff2(numbuses, buses, gens, loads, newgen, newload, timesteps)

%% Calculate PTDFs and LODFs

% Calculate my own PTDFs for a specific transfer
% [PTDFs_vec] = calcDCPTDF(buses, Tvec, Ybusp, invBp, lines, slack, status)
[Tvec, pvec] = calcTvector2(buses, diffS, diffB, slack)

[PTDFs_T] = calcDCPTDF(buses, Tvec, Ybusp, invBp, lines, slack, lineStatus)

%% Calculate OTDFs and post-transfer post-contingency line flows
[OTDFs] = calcOTDF(PTDFs_T, LODFs, lineStatus)

%% CHECK GENCHANGE IN MORE DETAIL!
[ptpcflows] = genChange(numlines, LODFs, OTDFs, pvec, lineflows, lineStatus)

perptpcflows = zeros(numlines,numlines,timesteps);
temp = zeros(numlines,numlines,timesteps);
height = zeros(timesteps);
width = zeros(timesteps);
% for c = 1:timesteps
%     % Calculate % overload from line outage
%     for i = 1:numlines
%         perptpcflows(:,i,c) = abs(ptpcflows(:,i,c))./lines(:,7)*100;
%     end
%     % Only alert if % line flow >100%
%     temp = [];
%     for a = 1:numlines
%         for b = 1:numlines
%             if abs(perptpcflows(a,b,c)) > 95
%                 lineaffected = lines(a,1:2); %line affected
%                 lineoutaged = lines(b,1:2); %line outaged
%                 temp = [temp; lineoutaged lineaffected abs(perptpcflows(a,b,c))];
%             end
%         end
%     end
%     temp
%     %[height(c), width(c)] = size(temp);
%     %flagged(1:height(c),1:width(c),c) = temp;
%     %flagged
% end

% If you assume constant MVAR

for c = 1:timesteps
    for a = 1:numlines
        MVAflows(:,a,c) = sqrt(ptpcflows(:,a,c).^2+MVARflows.^2);
    end
    for a = 1:numlines
        perptpcflows(:,a,c) = abs(MVAflows(:,a,c))./lines(:,7)*100;
    end
    perptpcflows
end

for c = 1:timesteps
    flagged = [];
    for a = 1:numlines
        for b = 1:numlines
            if abs(perptpcflows(a,b,c)) > 95
                lineaffected = lines(a,1:3); %line affected
                lineoutaged = lines(b,1:3); %line outaged
                flagged = [flagged; lineoutaged lineaffected abs(perptpcflows(a,b,c))];
            end
        end
    end
    flagged
    write2file_future
end

fclose('all');