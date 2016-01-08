function [newLoadMW, newLoadMVR] = newLoadProfiles(numloads, timesteps, loads, loadProfile)

normLoad = loadProfile/mean(loadProfile);
plot(1:timesteps,normLoad)

xlabel('Time of Day [Hour]')
ylabel('Weighted Load')
title('PJM RTO Historical Metered Load Data for 01/01/2014')

newLoadMW = zeros(numloads,timesteps);
newLoadMVR = zeros(numloads,timesteps);

% Create semi-random load MW data
randNoise = zeros(numloads,timesteps);
for a = 1:timesteps
    for b = 1:numloads
        % Introduce random noise
        randNoise(b,a) = 0.07*randn(1,1);
        %randNoise(b,a) = 0;
        % Impose random noise
        newLoadMW(b,a) = loads(b,3)*(1+randNoise(b,a))*normLoad(a);
        totLoadMW(a) = sum(newLoadMW(:,a));
    end
end
figure(2)
plot(1:timesteps,newLoadMW)
hold on
plot(1:timesteps,totLoadMW,'b:')

% Create semi-random load MVR data
randNoise2 = zeros(numloads,timesteps);
for a = 1:timesteps
    for b = 1:numloads
        % Introduce random noise
        randNoise2(b,a) = 0.07*randn(1,1);
        %randNoise(b,a) = 0;
        % Impose random noise
        newLoadMVR(b,a) = loads(b,4)*(1+randNoise2(b,a));
        totLoadMVR(a) = sum(newLoadMVR(:,a));
    end
end
figure(3)
plot(1:timesteps,newLoadMVR)
hold on
plot(1:timesteps,totLoadMVR,'b:')

figure(4)
plot(1:timesteps,randNoise)
plot(1:timesteps,randNoise2,'r:')

save('newLoadMW.mat', 'newLoadMW')
save('newLoadMVR.mat', 'newLoadMVR')