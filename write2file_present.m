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
fprintf(fid, '\n');

fprintf(fid, 'Number of Future Timesteps: %d\n', timesteps);

fprintf(fid, '\n\n');

