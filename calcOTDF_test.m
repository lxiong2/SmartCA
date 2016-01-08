% Leilei Xiong
% Date created: 08/22/2013
% Date edited: 09/03/2013

clear all
clc

%B3L4TestSystem
%B3L4TestSystem2
B4L5TestSystem

[Tvec, pvec] = calcTvector2(buses, diffS, diffB, slack)

[PTDFs_T] = calcDCPTDF(buses, Tvec, Ybusp, invBp, lines, slack, status)

LODFs = calcLODF(buses, Ybusp, invBp, lines, status, slack)

OTDFs = calcOTDF(PTDFs_T, LODFs, status)