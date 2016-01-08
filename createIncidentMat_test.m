% Leilei Xiong
% Date Created: 10/10/2013

clc
clear all

numbus = 3;
buses = [101; 102; 103]
numlines = 3;
lines = [101 102 1; 101 103 1; 102 103 1];
status = {'Closed'; 'Closed'; 'Closed'};
slack = 101;

incidentMat = createIncidentMat(buses, numbus, slack, lines, numlines, status)
