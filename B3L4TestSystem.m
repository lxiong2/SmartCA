% Leilei Xiong
% Date Created: 08/15/2013
% Date Revised: 08/29/2013

% Simple 3 bus system with 3 closed lines of equal reactances

clear all
clc

buses = [1; 2; 3];

Ybusp = 1i*[-20 10 10;
            10 -20 10;
            10 10 -20];

invBp = inv([-20 10; 10 -20]);

lines = [1 2 1 0 0.1 0; 
         1 3 1 0 0.1 0; 
         1 3 2 0 0.1 0; 
         2 3 1 0 0.1 0];
     
slack = 2;

status = {'Closed'; 'Closed'; 'Open'; 'Closed'};

numbuses = length(buses);

gens = [1 1 80;
        2 1 20];
    
loads = [3 1 100];

preflows = [20;
            60;
            0;
            40];

diffS = [0; 1; 0];
diffB = [0; 0; -1];

timesteps = size(diffS,2);

correctGen = [2 1 21];
correctLoad = [3 1 101];