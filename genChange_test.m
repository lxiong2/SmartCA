% Leilei Xiong
% Date created: 09/05/2013
% Date edited: 09/05/2013

clear all
clc

%B3L4TestSystem
B3L4TestSystem2
%B4L5TestSystem

Sbase = 100;
correctGen = gens
correctLoad = loads
busP = calcBusInj(buses, gens, loads, Sbase, correctGen, correctLoad)

[Tvec, pvec] = calcTvector2(buses, diffS, diffB, slack)

[PTDFs_T] = calcDCPTDF(buses, Tvec, Ybusp, invBp, lines, slack, status)

LODFs = calcLODF(buses, Ybusp, invBp, lines, status, slack)

OTDFs = calcOTDF(PTDFs_T, LODFs, status)

numlines = size(lines,1);
[ptpcflows_vec] = genChange(numlines, LODFs, OTDFs, pvec, preflows, status)