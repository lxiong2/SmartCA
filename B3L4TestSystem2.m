% Leilei Xiong
% Date Created: 08/15/2013
% Date Revised: 08/29/2013

% 3 bus system with 4 line (2 redundant) with different reactances

clear all
clc

buses = [1; 2; 3];

Ybusp = 1i*[-25 10 15;
            10 -20 10;
            15 10 -25];

invBp = inv([-25 15; 15 -25]);

lines = [1 2 1 0 0.1 0;
         1 3 1 0 0.1 0;
         1 3 2 0 0.2 0;
         2 3 1 0 0.1 0];

slack = 2;

status = {'Closed'; 'Closed'; 'Closed'; 'Closed'};

numbuses = length(buses);

gens = [1 1 80;
        2 1 20];
    
loads = [3 1 100];

preflows = [12.5;
            45;            
            22.5;
            32.5];

diffS = [0; 1; 0];
diffB = [0; 0; -1];

timesteps = size(diffS,2);

correctGen = [2 1 21];
correctLoad = [3 1 101];