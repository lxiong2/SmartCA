% Leilei Xiong
% Date Created: 08/01/2013
% Date Revised: 08/29/2013

function [PTDFs_vec] = calcDCPTDF(buses, Tvec, Ybusp, invBp, lines, slack, status)
% calcDCPTDF:
% Calculates the DC PTDFs (using lossless DC approximations) for a transfer
% that consists of multiple changes in generation and load
%
% Inputs:
% =====================================================================
% buses:        List of buses                           (nx1 vector)
% T:            Transfer vector
% Ybusp:        Bus admittance matrix constructed with Rs ignored   
%                                                       (sparse nxn matrix)
% invBp:        Inverted Bp matrix                      (sparse
% (n-1)x(n-1) matrix)
% lines:        Lines in the system                     (mx2 matrix)
% slack:        Slack bus number                        (scalar)
% status:       Line statuses                           (mx1 vector)
% =====================================================================
%
% Outputs:
% =====================================================================
% PTDFs:        DC PTDFs for each line                  (mx1 vector)              
% =====================================================================

numbuses = size(buses,1);
numlines = size(lines,1);
timesteps = size(Tvec,2);
PTDFs_vec = zeros(numlines,timesteps);

busIndex = (1:numbuses).';

slackIndex = busIndex(buses(:,1) == slack);

% [pairs Ztot] = calcZtot(FromBus, ToBus, X, status)
[pairs Ztot] = calcZtot(lines(:,1), lines(:,2), lines(:,5), status);

for a = 1:timesteps
    dthetadp = invBp*Tvec(:,a); %[Bp]^-1*T

    temp = zeros(numbuses,1);
    temp(1:numbuses-1) = [dthetadp(1:slackIndex-1); dthetadp(slackIndex:numbuses-1)];

    for i = 1:numlines
        if strcmp(status(i),'Closed')
            fromIndex = busIndex(buses(:,1) == lines(i,1));
            toIndex = busIndex(buses(:,1) == lines(i,2));
            PTDFs_vec(i,a) = -imag(Ybusp(fromIndex,toIndex))*(temp(fromIndex)-temp(toIndex))*100*findZtot(lines(i,1),lines(i,2),pairs,Ztot)/lines(i,5);
        end      
    end  
end

