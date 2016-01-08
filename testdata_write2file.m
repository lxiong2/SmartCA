fid = fopen('B7caseresults.txt','w');

% L to R = time dimension, Top to Bottom = bus number

% Write input data (generated load data) to file
fprintf(fid, 'Load [MW]\n');
for b = 1:numbuses
    for a = 1:timesteps
        fprintf(fid, '%4.4f  ', loadMW(b,a));
    end
    fprintf(fid, '\n');
end

fprintf(fid, '\nLoad [MVAR]\n');
for b = 1:numbuses
    for a = 1:timesteps
        fprintf(fid, '%4.4f  ', loadMVR(b,a));
    end
    fprintf(fid, '\n');
end

% Write generator results of power flow to file
fprintf(fid, '\nGeneration [MW]\n');
for b = 1:numbuses
    for a = 1:timesteps
        fprintf(fid, '%4.4f  ', genMW(b,a));
    end
    fprintf(fid, '\n');
end

fprintf(fid, '\nGeneration [MVAR]\n');
for b = 1:numbuses
    for a = 1:timesteps
        fprintf(fid, '%4.4f  ', genMVR(b,a));
    end
    fprintf(fid, '\n');
end

% Write bus results of power flow to file
fprintf(fid, '\nBus Voltage [per unit]\n');
for b = 1:numbuses
    for a = 1:timesteps
        fprintf(fid, '%4.4f  ', busvolt(b,a));
    end
    fprintf(fid, '\n');
end

fprintf(fid, '\nBus Angle [deg]\n');
for b = 1:numbuses
    for a = 1:timesteps
        fprintf(fid, '%4.4f  ', busang(b,a));
    end
    fprintf(fid, '\n');
end

% Write line results of power flow to file
fprintf(fid, '\nLine Flows [MVA]\n');
for b = 1:numlines
    for a = 1:timesteps
        fprintf(fid, '%4.4f  ', lineflows(b,a));
    end
    fprintf(fid, '\n');
end

fprintf(fid, '\nMaximum Line Violation [Percent]\n');
for b = 1:numlines
    for a = 1:timesteps
        fprintf(fid, '%4.4f  ', linemaxper(b,a));
    end
    fprintf(fid, '\n');
end





