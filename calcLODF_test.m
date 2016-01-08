% Leilei Xiong
% Date created: 08/22/2013
% Date edited: 09/03/2013

clear all
clc

%B3L4TestSystem
%B3L4TestSystem2
B4L5TestSystem

%[PTDFs_T, T, p, error] = calcDCPTDF_T(diffS, diffB, Ybus, invBp, lines, slack, status)

LODFs = calcLODF(buses, Ybusp, invBp, lines, status, slack)

%OTDFs = calcOTDF(PTDFs_T, LODFs, status)

