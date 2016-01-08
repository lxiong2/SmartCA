clc

simauto = actxserver('pwrworld.SimulatorAuto');
simauto.OpenCase('C:\Users\lxiong7\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B7FLAT_DC.pwb');
%simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE Reliability\24Bus_DC.pwb');

DC_CA

simauto.CloseCase();
delete(simauto);

newload = [3 1 113.2 120 130 125 115];

%temp = [gens(:,3) 

netgen = calcNet(buses, gens(:,1), gens(:,2), gens(:,3))
netload = calcNet(buses, loads(:,1), loads(:,2), loads(:,3))

netnewload = calcNet(buses, newload(:,1), newload(:,2), newload(:,3:7))

timesteps = size(newload,2)-2;

busIndex = buses(:,1);

modload = zeros(numbuses,timesteps+2);
modload(:,1) = buses(:,1);
modload(:,2) = netload(:,2);
for a = 1:timesteps
    modload(:,a+2) = modload(:,2);
end
for a = 1:size(newload,1)
    A = busIndex(buses(:,1) == newload(a,1));
    modload(A,3:timesteps+2) = newload(a,3:timesteps+2);   
end
modload