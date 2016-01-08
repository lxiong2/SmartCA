clf
close all

% From PJM Historical Metered Load Data for 01/01/2014

[newLoadMW, newLoadMVR] = newLoadProfiles(numloads, timesteps, loads, loadProfile);

% scale newLoadMW and newLoadMVR
newLoadMW = newLoadMW*1.5;
newLoadMVR = newLoadMVR*1.5;

save('newLoadMW.mat')
save('newLoadMVR.mat')