function [pcflows, pcpcflows] = newLine(buses, lines, slack, status, newline, thetaD, preflows)

% newLine:
% Contingency analysis assuming the addition of a new transmission line
%
% Inputs:
% =====================================================================
% numlines: Number of lines in the system   (scalar)
% PTDFs:    New PTDFs including new lines   (sparse numlines+1 x 1 vector)  
% LODFs:    New LODFs including new lines   (sparse numlines+1 x 1 vector)
% lines:    Line parameter matrix           (numlines x 7 matrix)
% status:   Line status                     (numlines x 1 vector)
% newIndex: Index of new line in "lines"    (scalar)
% Xab:      Reactance of new line           (scalar)
% thetaD:   Base case angles                (numbus x 1 vector)
% preflows: Base case line flows            (numlines x 1 vector)
% =====================================================================
%
% Outputs:
% =====================================================================
% OTDFs:     OTDFs for a specified transfer  (numlines x numlines vector)
% pcpcflows: Post-closure post-contingency line flows     (numlines x 1 vector)
% =====================================================================

% newline: frombus, tobus, linenum, R, X, B, limit
numlines = size(lines,1);
newIndex = numlines+1; % assume new line is appended to the end of the lines list

% New system consists of existing lines and new considered line
sysLines = [lines; newline];
sysStatus = [status; 'Closed']; % close the new line

Tvec = calcTvector(buses, newline(1,1), newline(1,2), slack);
[newBp, newYbusp] = calcBp(buses, sysLines(:,1), sysLines(:,2), sysLines(:,5), slack, sysStatus);
invnewBp = inv(newBp);
newPTDFs = calcDCPTDF(buses, Tvec, newYbusp, invnewBp, sysLines, slack, sysStatus);
LCDFs = -newPTDFs;

LODFs = calcLODF(buses, newYbusp, invnewBp, sysLines, sysStatus, slack)

% Contingency occurs on line l
% Percentage of post-contingency flow that shows up on line q
OCDFs = zeros(numlines, numlines);
for q = 1:numlines+1
    for l = 1:numlines+1
        OCDFs(q,l) = (LCDFs(q)/100+LODFs(l,q)/100*LCDFs(l)/100)*100;
    end
end

% pre-closure flow on new line
fromIndex = find(buses == newline(1,1));
toIndex = find(buses == newline(1,2));
Pplus1 = 1/newline(1,5)*sin(thetaD(fromIndex)*pi/180-thetaD(toIndex)*pi/180)*100;
preflows(newIndex) = Pplus1;

pcflows = zeros(numlines,1);
for q = 1:numlines
    if strcmp(status(q),'Closed')
        pcflows(q) = preflows(q)+LCDFs(q)/100*Pplus1;
    end
end
pcflows(newIndex) = Pplus1+LCDFs(newIndex)/100*Pplus1; %post-closure flow on new line

% Calculate new LODFs including the new line

pcpcflows = zeros(numlines+1, numlines+1);
for q = 1:numlines+1 % line impacted
    for l = 1:numlines % outaged line except the new line
        if strcmp(sysStatus(l),'Closed')
            pcpcflows(q,l) = preflows(q)+LODFs(l,q)/100*preflows(l)+OCDFs(q,l)/100*Pplus1;  
        end
    end
end
% if you opened the new line, the flows would just be restored to the
% pre-closure flows
pcpcflows(:,newIndex) = [preflows(1:numlines); 0];
