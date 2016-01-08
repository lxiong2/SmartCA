clc
clear all

tic

simauto = actxserver('pwrworld.SimulatorAuto');
%simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B7FLAT_DC.pwb');
%simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE Reliability\24Bus_DC.pwb');
simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE 118 Bus Case\118_DC.pwb');

DC_CA

simauto.CloseCase();
delete(simauto);

[Bp, Ybusp] = calcBp(buses, lines(:,1), lines(:,2), lines(:,5), slack, lineStatus)

[lineinc] = createIncidentMat(numbuses, buses, numlines, lines, lineStatus, slack)

datestr(datenum(now),0)

fid = fopen('case.txt','w');

fprintf(fid, 'Bus Information\n');
fprintf(fid, '// From  To  LineID  R  X  B  LimMVA\n');
for a = 1:numbuses
    fprintf(fid, '%d %d\n', buses(a,1), buses(a,2));
end

fprintf(fid, '\nLine Information\n');
fprintf(fid, '// From  To  LineID  R  X  B  LimMVA\n');
for a = 1:numlines
    fprintf(fid, '%d %d %d %f %f %f %d\n', lines(a,1), lines(a,2),...
        lines(a,3), lines(a,4), lines(a,5), lines(a,6), lines(a,7)); 
end

fprintf(fid, '\nLine Incidence Matrix\n');
for a = 1:numlines-1
    for b = 1:numbuses-1
        fprintf(fid, '%d', lineinc(a,b));
        fprintf(fid, ' ');
    end
    fprintf(fid, '\n');
end

fprintf(fid, '\nBp Matrix\n');
for a = 1:numbuses-1
    for b = 1:numbuses-1
        fprintf(fid, '%f', Bp(a,b));
        fprintf(fid, ' ');
    end
    fprintf(fid, '\n');
end

fclose(fid)