clc
clear all

%B3L4TestSystem
%B3L4TestSystem2
B4L5TestSystem

% function [Bp, temp] = calcBp(buses, FromBus, ToBus, X, slack, status)

slack = 104
[Bp, Ybusp] = calcBp(buses, lines(:,1), lines(:,2), lines(:,5), slack, status)