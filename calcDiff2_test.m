clear all
clc

buses = [101; 102; 103]
busGen1 = [101 1 80; 
           102 1 20]
busLoad1 = [103 1 100]
% 
% busGen2 = [101 1 90;
%            102 1 25]
% busLoad2 = [103 1 115]

busGen2 = [102 1 25]
busLoad2 = [103 1 105]

numbus = size(buses,1)
timesteps = size(busGen1,2)-2

[diffS, diffB] = calcDiff2(numbus, buses, busGen1, busLoad1, busGen2, busLoad2, timesteps)