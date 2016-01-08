% Author: Leilei Xiong
% Date Created: August 29, 2013
% Date Revised: September 3, 2013

function [zIndex] = findZtot(fromIndex, toIndex, pairs, Ztot)

% findZtot:
% Given the from and to bus indices, outputs the calculated Ztot value.
%
% Inputs:
% ============================================================
% FromBus:  Connection from Bus i               (column vector)
% ToBus:    Connection to Bus j                 (column vector)
% ============================================================
%
% Outputs:
% ============================================================
% pairs:    Pairs of buses                      (<m x 2 matrix)
% Ztot:     Zeq for each pair of buses          (<m x 1 vector)
% ============================================================

for a = 1:size(pairs,1)
    if (fromIndex == pairs(a,1)) && (toIndex == pairs(a,2))
        zIndex = Ztot(a);
    end
end