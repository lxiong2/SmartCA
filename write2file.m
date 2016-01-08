fid = fopen('CAresults.txt','w');

% Display base case timestamp
fprintf(fid, 'Present Time\n');
fprintf(fid, 'Date: 23-Oct-2013\n');
fprintf(fid, '9:05\n\n');

fprintf(fid, 'Line Status\n');
for a = 1:numlines
   fprintf(fid, '%s\n', lineStatus{a}); 
end
fprintf(fid, '\n');

netgens = calcNet(buses, gens(:,1), gens(:,2), gens(:,3));
fprintf(fid, 'Generator Information\n');
fprintf(fid, 'Bus#   Size [MW]\n');
for a = 1:size(netgens,1)
    fprintf(fid, '%d %4.4f\n', netgens(a,1), netgens(a,2));
end
fprintf(fid, '\n');

netloads = calcNet(buses, loads(:,1), loads(:,2), -loads(:,3));
fprintf(fid, 'Load Information\n');
fprintf(fid, 'Bus#   Size [MW]\n');
for a = 1:size(netloads,1)
    fprintf(fid, '%d %4.4f\n', netloads(a,1), netloads(a,2));
end
fprintf(fid, '\n\n');

% Subsequent timesteps
for a = 1:timesteps
    fprintf(fid, 'Future Time\n');
    fprintf(fid, 'Date: 23-Oct-2013\n');
    fprintf(fid, '9:%d\n',(timesteps+1)*5);
    fprintf(fid, 'Scenario %d\n\n', a);
    
    fprintf(fid, 'Generator Change\n');
    fprintf(fid, 'Bus# Size[MW]\n');
    for b = 1:numbuses
        fprintf(fid, '%d %4.4f\n', netgens(b,1), diffS(b,a));
    end
    fprintf(fid, '\n');
    
    fprintf(fid, 'Load Change\n');
    fprintf(fid, 'Bus# Size[MW]\n');
    for b = 1:numbuses
        fprintf(fid, '%d %4.4f\n', netloads(b,1), diffB(b,a));
    end
    fprintf(fid, '\n');
    
    fprintf(fid, 'N-1 Contingency Analysis: Flagged Violations\n');
    fprintf(fid, 'LineOut LineAffected PerViolation\n');
    for b = 1:height(a)
        fprintf(fid, '%d %d %d %d %4.4f\n', flagged(b,1,a), ...
            flagged(b,2,a), flagged(b,3,a), flagged(b,4,a), ...
            flagged(b,5,a));
    end
    
    fprintf(fid, '\n\n');
end

