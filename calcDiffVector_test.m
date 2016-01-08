clear all
clc

buses = [101; 102; 103];
busGen1 = [101 1 80; 102 1 20]
busLoad1 = [103 1 100]

% busGens = [101 1 90;
%            102 1 25]
% busLoads = [103 1 115]

busGens = [101 1 90 80 100 
           102 1 25 55 45]
busLoads = [103 1 115 135 145]

[diffSvec, diffBvec] = calcDiffVector(buses, busGen1, busLoad1, busGens, busLoads)