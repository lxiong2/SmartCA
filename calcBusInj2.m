% Leilei Xiong
% Date Created: 05/15/2013
% Date Revised: 05/15/2013

function [businj, Sbase] = calcBusInj2(buses, genList, loadList, Sbase)
% calcBusInj:
% Calculates the injection at each bus given a list of generators and loads with
% their associated bus numbers
%
% Inputs:
% =====================================================================
% buses:        total number of buses               (matrix)
% genList:      bus number, gen ID, MW size         (gen# x 3 matrix)  
% loadList:     bus number, load ID, MW size        (load# x 3 matrix)
% Sbase:        power base MVA                      (scalar)
% correctGen:   corrected gen values                (<gen# x 3 matrix)
% correctLoad:  corrected load values               (<load# x 3 matrix)
% =====================================================================
%
% Outputs:
% =====================================================================
% businj:       bus number bus and bus injection per unit   (numbuses x 2 matrix)
% =====================================================================

numbuses = size(buses,1);
businj = zeros(numbuses,2);
businj(:,1) = buses(:,1);
busIndex = (1:numbuses).';

% Bus voltage levels don't matter since all line parameters are already
% entered in per-unit and there's only one power base across the entire system

% Calculate original bus injection
for i = 1:size(genList,1)
    %A = find(businj(:,1) == genList(i,1));
    A = busIndex(businj(:,1) == genList(i,1));
    businj(A,2) = businj(A,2)+genList(i,3);
end
for i = 1:size(loadList,1)
    %A = find(businj(:,1) == loadList(i,1));
    A = busIndex(businj(:,1) == loadList(i,1));
    businj(A,2) = businj(A,2)-loadList(i,3);
end

businj(:,2) = businj(:,2)/Sbase; %convert to per unit



