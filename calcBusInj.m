% Leilei Xiong
% Date Created: 05/15/2013
% Date Revised: 05/15/2013

function [businj, busGen, busLoad] = calcBusInj(buses, gens, loads, newgen, newload, timesteps, Sbase)
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
businj = zeros(numbuses,timesteps+2); % bus# + base case + future timesteps
businj(:,1) = buses(:,1);
%busIndex = buses(:,1);
busIndex = (1:numbuses).';

baseGen = calcNet(buses, gens(:,1), gens(:,2), gens(:,3)); % base case gens
baseLoad = calcNet(buses, loads(:,1), loads(:,2), loads(:,3)); % base case loads

busGen = businj;
busLoad = businj;
for a = 1:timesteps+1
    busGen(:,a+1) = baseGen(:,2);
    busLoad(:,a+1) = baseLoad(:,2);
end
for a = 1:size(newgen,1)
    A = busIndex(buses(:,1) == newgen(a,1));
    busGen(A,3:timesteps+2) = newgen(a,3:timesteps+2);
end
for a = 1:size(newload,1)
    A = busIndex(buses(:,1) == newload(a,1));
    busLoad(A,3:timesteps+2) = newload(a,3:timesteps+2);
end

% Bus voltage levels don't matter since all line parameters are already
% entered in per-unit and there's only one power base across the entire system

% Calculate the new bus injections for future timesteps
for k = 2:timesteps+2
    businj(:,k) = busGen(:,k) - busLoad(:,k);
end

businj(:,2:timesteps+2) = businj(:,2:timesteps+2)/Sbase; %convert to per unit



