% Leilei Xiong
% Date created: 08/16/2013
% Date edited: 08/29/2013

function [PTDFtable, Tvec] = calcPTDFtable(buses, Ybusp, invBp, lines, status, slack)
% calcPTDFtable:
% Calculates a table of DC PTDFs (using lossless DC approximations) for a transfer
% from every bus in the network to every other bus
%
% Inputs:
% =====================================================================
% bus1:         Transfer from this bus                  (scalar)
% bus2:         Transfer to this bus                    (scalar)
% Ybus:         Bus admittance matrix                   (sparse nxn matrix)
% invBp:        Inverted Bp matrix                      (sparse (n-1)^2 matrix)
% lines:        Lines in the system                     (mx2 matrix)
% slack:        Slack bus number                        (scalar)
% =====================================================================
%
% Outputs:
% =====================================================================
% PTDFtable:    Table of DC PTDFs                       (numlines x numlines matrix)
% =====================================================================

numlines = size(lines,1);
%numbuses = max(max(lines(:,1:2))); %figure out the largest bus number
%based on the information in the first two columns
PTDFtable = zeros(numlines,numlines);

for a = 1:numlines
    if strcmp(status(a),'Closed')
        Tvec = calcTvector(buses, lines(a,1), lines(a,2), slack);
        PTDFtable(:,a) = calcDCPTDF(buses, Tvec, Ybusp, invBp, lines, slack, status);
    end
end