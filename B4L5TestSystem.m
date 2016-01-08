% Leilei Xiong
% Date Created: 08/15/2013
% Date Revised: 08/29/2013

% 5-bus system, no redundant lines, equal reactances

clear all
clc

buses = [101 138;
         102 138; 
         103 230; 
         104 230];

Ybusp = 1i*[-30 10 10 10;
    10 -30 10 10;
    10 10 -20 0;
    10 10 0 -20];

invBp = inv([-30 10 10; 10 -20 0; 10 0 -20]);

lines = [101 102 1 0 0.1 0;
         101 103 1 0 0.1 0; 
         101 104 1 0 0.1 0; 
         102 103 1 0 0.1 0; 
         102 104 1 0 0.1 0];

slack = 101;

status = {'Closed'; 'Closed'; 'Closed'; 'Closed'; 'Closed'};

numbuses = length(buses);

gens = [101 1 86;
        102 1 24];
    
loads = [103 1 67;
         104 1 43];

preflows = [15.5;
            41.3;
            29.2;
            25.8;
            13.7];

diffS = [6 7;
         4 3;
         0 0;
         0 0];
diffB = [0 0;
         0 0;
         7 6;
         3 4];

timesteps = size(diffS,2);

correctGen = [101 1 92 93;
              102 1 28 27]
correctLoad = [103 1 74 73;
               104 1 46 47]