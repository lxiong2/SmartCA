clc
clear all

tic

simauto = actxserver('pwrworld.SimulatorAuto');
simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B7FLAT_DC.pwb');
%simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE Reliability\24Bus_DC.pwb');
%simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE 118 Bus Case\118_DC.pwb');

DC_CA

simauto.CloseCase();
delete(simauto);

% Calculate power injection at each bus
busP = calcBusInj2(buses, gens, loads, Sbase);
disp('Bus Injections')
disp('    Bus#      Bus Injection [pu]')

[Bp, Ybusp] = calcBp(buses, lines(:,1), lines(:,2), lines(:,5), slack, lineStatus)

[lineinc] = createIncidentMat(numbuses, buses, numlines, lines, lineStatus, slack)

datestr(datenum(now),0)

fid = fopen('case.txt','w');

fprintf(fid, 'Bus Injections\n');
fprintf(fid, '// Bus# BusInjection[pu]\n');

for a = 1:numbuses
    fprintf(fid, '%d %d\n', busP(a,1), busP(a,2));
end


fclose(fid)