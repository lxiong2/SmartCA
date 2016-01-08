% Leilei Xiong
% Date created: 09/05/2013
% Date edited: 09/09/2013

function [powerflows] = directPF(buses, lines, timesteps, slack, status, Sbase, genList, loadList, correctGen, correctLoad)

% directPF:
% Calculate the direct power flow contingency analysis results to compare
% against the smart CA results
%
% Inputs:
% =====================================================================
% numlines: Number of lines in the system   (scalar)
% LODFs:    LODFs for a specified transfer  (sparse numlines x 1 vector)
% OTDFs:    OTDFs for a specified transfer  (?) 
% p:        Transfer size in MW             (scalar)
% preflows: Base case line flows            (numlines x 1 vector)
% status:   Status of each line
%           'Open' or 'Closed'              (numlines x 1 vector)
% =====================================================================
%
% Outputs:
% =====================================================================
% % ptpcflows: Post-transfer post-contingency line flows     (numlines x numlines vector)
% =====================================================================

numlines = size(lines,1);
powerflows = zeros(numlines,timesteps);
thetaD = zeros(numlines,timesteps);
% Calculate bus injections
businj = calcBusInj(buses, genList, loadList, Sbase, correctGen, correctLoad)

% 0-th timestep is base case
for b = 1:timesteps
    for a = 1:numlines
        % Open each line
        status(a) = {'Open'};
        % Calculate the Bp
        Bp = calcBp(buses, lines(:,1), lines(:,2), lines(:,5), slack, status)
        invBp = inv(Bp);
        % Restore the line
        status(a) = 'Closed';
    end
    % Calculate the DC power flow
    [thetaD(:,b), powerflows(:,b)] = DCPowerFlow(buses, invBp, slack, [businj(:,1) businj(:,b+1)], lines, status)
    
end

