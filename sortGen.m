% Leilei Xiong
% Date created: 08/16/2013
% Date edited: 08/29/2013

function [distinctT, refT] = sortGen(newgen, newload)
% sortGen:
% Figure out distinctT
%
% Inputs:
% =====================================================================
% gen:         Matrix of generation values          (<numbus x t matrix)
% load:        Matrix of load values                (<numbus x t matrix)
% =====================================================================
%
% Outputs:
% =====================================================================
% distinctT:   Vector of distinct Ts                (numbus x <t matrix)
% refT:        Gives index of each T vector         (t row vector) 
% =====================================================================

t = size(gen,2);

distinctT = [];
temp = newgen - newload;

for a = 1:t
    % if T vector already exists in the table, then just write down the
    % index
    
        
        
    else 
    
end



