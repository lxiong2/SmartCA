% Leilei Xiong

clc
clear all
format long

% Connect to PowerWorld and open a case
simauto = actxserver('pwrworld.SimulatorAuto');
simauto.OpenCase('C:\Users\lxiong7\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B7FLAT_DC.pwb');

% Extract PowerWorld case parameters
DC_CA

% Get Ybus from PowerWorld
simauto.RunScriptCommand('EnterMode(Run)');
simauto.RunScriptCommand('SaveYbusInMatlabFormat("C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Smart Contingency Analysis\ybus.m", YES)');
ybus
Ybus

% Disconnect from PowerWorld
simauto.CloseCase();
delete(simauto);

%% Construct my own Ybus
myYbus = calcYbus(buses, lines(:,1), lines(:,2), lines(:,4), lines(:,5), lines(:,6), lineStatus);
sparse(myYbus)




