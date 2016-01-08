clc
clf
clear all
close all

%% Initialize simauto, open base case and extract parameters

simauto = actxserver('pwrworld.SimulatorAuto');
%simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B7FLAT_LX.pwb');
%test = simauto.SaveCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\test_setdata.pwb','PWB',true);

% Inputs case bus number
casename = 'PW7';

if strcmp(casename,'PW7')
    casepath = 'C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\test_setdata2.pwb';
elseif strcmp(casesize,'RTS24')
    casepath = 'C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE Reliability\24Bus.pwb';
elseif strcmp(casesize,'IEEE118')
    casepath = 'C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE 118 Bus Case\118.pwb';
elseif strcmp(casesize,'TVA') 
    casepath = 'C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\TVA\TVASummer15Base.pwb';
end

% Lowered the line limits of the regular B7FLAT case
% regular IEEE RTS 24-bus case
simauto.OpenCase(casepath);

fieldarray = {'BusNum'};
results = simauto.GetParametersMultipleElement('bus',fieldarray,'');
buses = [str2double(results{2}{1})];
numbuses = length(buses);

fieldarray = {'BusNum', 'BusNum:1', 'LineCircuit', 'LineLimMVA'};
results = simauto.GetParametersMultipleElement('branch',fieldarray,'');
lines = [str2double(results{2}{1}), str2double(results{2}{2}), str2double(results{2}{3}), str2double(results{2}{4})];
numlines = length(lines);
lines

fieldarray = {'BusNum', 'GenID'};
results = simauto.GetParametersMultipleElement('gen',fieldarray,'');
gens = [str2double(results{2}{1}), str2double(results{2}{2})];
numgens = size(gens,1);

fieldarray = {'BusNum', 'LoadID', 'LoadMW', 'LoadMVR'};
results = simauto.GetParametersMultipleElement('load',fieldarray,'');
loads = [str2double(results{2}{1}), str2double(results{2}{2}), str2double(results{2}{3}), str2double(results{2}{4})];
numloads = length(loads);

%% Run newLoadProfiles once to create load profile curves with a small amount of random noise
% thereafter just load newLoadMW and newLoadMVR for use in this script

loadProfile = [91385.915 89221.005 87662.125 87055.014 87366.656 88626.828...
           90569.584 91889.327 92495.404 93011.707 93231.598 92732.918...
           91566.366 90121.836 88958.229 89012.303 91980.086 99578.576...
           102297.224 101883.002 100720.943 97946.08 93582.539 88715.146];
timesteps = length(loadProfile);

%newLoadProfiles_generate
load('newLoadMW.mat')
load('newLoadMVR.mat')

%% Send load profile curves to PowerWorld, run power flows, gather results

lineflows = zeros(numlines,timesteps);
linemaxper = zeros(numlines,timesteps);
genMW = zeros(numbuses,timesteps);
genMVR = zeros(numbuses,timesteps);
loadMW = zeros(numbuses,timesteps);
loadMVR = zeros(numbuses,timesteps);
busvolt = zeros(numbuses,timesteps);
busang = zeros(numbuses,timesteps);

for a = 1:timesteps
    simauto.OpenCase(casepath);

    for b = 1:numloads
        simauto.RunScriptCommand('EnterMode(Edit)');
        str = sprintf('setdata(LOAD,[BusNum,LoadID,LoadMW,LoadMVR],[%d,%d,%d,%d]);',loads(b,1),loads(b,2),newLoadMW(b,a),newLoadMVR(b,a));
        simauto.RunScriptCommand(str);
    end
    
    simauto.RunScriptCommand('EnterMode(Run);');
    simauto.RunScriptCommand('SolvePowerFlow(RECTNEWT);');

    fieldarray = {'BusNum','BusGenMW','BusGenMVR','BusPUVolt','BusAngle','BusLoadMW','BusLoadMVR'};
    results = simauto.GetParametersMultipleElement('bus',fieldarray,'');
    genMW(:,a) = str2double(results{2}{2});
    genMVR(:,a) = str2double(results{2}{3});
    busvolt(:,a) = str2double(results{2}{4});
    busang(:,a) = str2double(results{2}{5});
    loadMW(:,a) = str2double(results{2}{6});
    loadMVR(:,a) = str2double(results{2}{7});
    
    fieldarray = {'BusNum','BusNum:1','LineCircuit','LineMW','LineMVR','LineMVA','LineMaxPercent'};
    results = simauto.GetParametersMultipleElement('branch',fieldarray,'');
    lineflows(:,a) = str2double(results{2}{6});
    linemaxper(:,a) = str2double(results{2}{7});
    
    simauto.CloseCase();
end

% Convert all NaN to 0s; ISNAN apparently does not work for double
% precision or single precision
% for b = 1:timesteps
%     for a = 1:numbuses
%         if (genMW(a,b) == 0) || (genMW(a,b) > 0) || (genMW(a,b) < 0)
% 
%         else genMW(a,b) = 0;
%         end
%         if (genMVR(a,b) == 0) || (genMVR(a,b) > 0) || (genMVR(a,b) < 0)
% 
%         else genMVR(a,b) = 0;
%         end
%     end
% end

genMW
genMVR
loadMW
loadMVR
lineflows
linemaxper
busvolt
busang

% Write everything to text file
testdata_write2file

% Clean-up
delete(simauto);
