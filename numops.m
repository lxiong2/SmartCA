
% IEEE 118 Bus Case
n = 118
m = 186
c = 2

t = 12 % assume 12 time steps, 5 minutes over the course of an hour

% Worst Case Traditional DC CA
num_md1 = ((n-1)^2+2*m+2*m^2)*(t+1)
num_as1 = ((n-1)*(n-2)+m+m^2)*(t+1)

% Worst Case Smart DC CA
num_md2 = (n-1)^2+2*m+(n-1)^2*t+m*t+m^2+3*m^2*t
num_as2 = (n-1)*(n-2)+m+(n-1)*(n-2)*t+m*t+m^2+2*m^2*t

% "Average" Case Smart DC CA
num_md3 = (n-1)^2+2*m+(n-1)*c*t+m*t+m^2+3*m^2*t
num_as3 = (n-1)*(n-2)+m+(n-1)*(c-1)*t+m*t+m^2+2*m^2*t