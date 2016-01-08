% Subsequent timesteps
fprintf(fid, 'Future Time\n');

fprintf(fid, 'Scenario %d\n', c);
fprintf(fid, 'Date: 23-Oct-2013\n');
fprintf(fid, '9:%2.0f\n\n',(c+1)*5);

fprintf(fid, 'Generator Change\n');
fprintf(fid, 'Bus# Size[MW]\n');
for b = 1:numbuses
    fprintf(fid, '%d %4.4f\n', netgens(b,1), diffS(b,c));
end
fprintf(fid, '\n');

fprintf(fid, 'Load Change\n');
fprintf(fid, 'Bus# Size[MW]\n');
for b = 1:numbuses
    fprintf(fid, '%d %4.4f\n', netloads(b,1), diffB(b,c));
end
fprintf(fid, '\n');

fprintf(fid, 'N-1 Contingency Analysis: Flagged Violations\n');
fprintf(fid, 'LineOut LineAffected PerViolation\n');

for e = 1:size(flagged,1)
    fprintf(fid, '%d %d %d %d %d %d %4.4f\n',...
        flagged(e,1), flagged(e,2), flagged(e,3),...
        flagged(e,4), flagged(e,5), flagged(e,6),...
        flagged(e,7));
end

fprintf(fid, '\n\n');

