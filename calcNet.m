function [netgen] = calcNet(buses, busID, genID, MWsize)
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

timesteps = size(MWsize,2);
numbuses = size(buses,1);
netgen = zeros(numbuses,timesteps+1);
netgen(:,1) = buses(:,1);
busIndex = (1:numbuses).';

for j = 1:timesteps
    for i = 1:size(genID)
        A = busIndex(buses(:,1) == busID(i,1));
        netgen(A,1+j) = netgen(A,1+j)+MWsize(i,j);
    end
end