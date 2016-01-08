clear all
clc

% 118 bus case

% Best case: change in line status for a line connecting 2 nearby buses
n = 118;
m1 = 2;
m2 = 2;

C1 = 2*m1^2*m2;
C2 = m1^2;
C3 = 2*m1*m2*n;
C4 = 2/3*m1^3+2*m1^2*n;
H = 2*m1*n^2;
AD = n^2;

total = C1+C2+C3+C4+H+AD

% Worst case: change in line status for a line connect 2 farthest buses
n = 118;
m1 = 118;
m2 = 118;

C1 = 2*m1^2*m2;
C2 = m1^2;
C3 = 2*m1*m2*n;
C4 = 2/3*m1^3+2*m1^2*n;
H = 2*m1*n^2;
AD = n^2;

total = C1+C2+C3+C4+H+AD

% Average case
n = 118;
m1 = 118/2;
m2 = 118/2;

C1 = 2*m1^2*m2;
C2 = m1^2;
C3 = 2*m1*m2*n;
C4 = 2/3*m1^3+2*m1^2*n;
H = 2*m1*n^2;
AD = n^2;

total = C1+C2+C3+C4+H+AD

% Matrix inversion
total = n^3
