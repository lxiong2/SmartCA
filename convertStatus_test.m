clear all
clc

simauto = actxserver('pwrworld.SimulatorAuto');
simauto.OpenCase('C:\Users\lxiong7\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B7FLAT_DC.pwb');
%simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE Reliability\24Bus_DC.pwb');

DC_CA

simauto.CloseCase();
delete(simauto);

newgen = zeros(1,7)
newload = [4 1 113.2 120 130 125 115];

timesteps = size(newgen,2)-2;

newstatus = [1 0 1 0 1 0;
             4 1 0 0 0 0;
             5 0 1 0 0 0]

[newStatus] = convertStatus(numlines, lineStatus, newstatus(:,1), newstatus(:,2:timesteps+1), timesteps)

