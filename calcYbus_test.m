clear all
clc

%B3L4TestSystem
%B3L4TestSystem2
B4L5TestSystem

% function [Ybus] = calcYbus(buses, FromBus, ToBus, R, X, B, status)
Ybus = calcYbus(buses, lines(:,1), lines(:,2), lines(:,4),...
    lines(:,5), lines(:,6), status)