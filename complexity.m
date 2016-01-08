clc
clear all
clf

% % IEEE 118 Bus Case
j = 234;
n = 118;
m = 186;

% TVA System
% j = 2870;
% n = 960;
% m = 1338;

t = 1:200;

timesteps = length(t);

AC = zeros(1,timesteps);
DC = zeros(1,timesteps);
DCruntime = zeros(1,timesteps);
DCtop = zeros(1,timesteps);
DCtopruntime = zeros(1,timesteps);
New = zeros(1,timesteps);
Newruntime = zeros(1,timesteps);

% AC CA
% for a = 1:length(t)
%     AC(a) = j^1.4*m*t(a)+m^2*t(a);
    %DC(a) = j^1.4*t(a)+n^1.2*m+m^2+m^2*t(a);
    %DCruntime(a) = j^1.4*t(a)+m^2*t(a);
    %DCtop(a) = j^1.4*t(a)+n^1.2*m*t(a)+2*m^2*t(a); %recalc DFs
    %New(a) = j^1.4+n^1.2*m+2*m^2+n^1.2*t(a)+m*t(a)+2*m^2*t(a);
    %Newruntime(a) = j^1.4+n^1.2*m+2*m^2+m^2*t(a);
% end

% Edited: 1/31/2014
for a = 1:length(t)
    AC(a) = j^1.4*m*t(a)+m^2*t(a);
    DC(a) = j^1.4*t(a)+(n^1.4+n^1.2*m+m)+m^2+2*m^2*t(a);
    DCruntime(a) = j^1.4*t(a)+2*m^2*t(a);
    DCtop(a) = j^1.4*t(a)+(n^1.4+n^1.2*m+m)*t(a)+m^2*t(a)+2*m^2*t(a);
    New(a) = j^1.4+(n^1.4+n^1.2*m+m)+m^2+(n^1.2)*t(a)+3*m^2*t(a);
    Newruntime(a) = m^2*t(a);
end

plot(t, AC)
hold on
plot(t, DC, 'r')
plot(t, DCtop, 'r--')
plot(t, New, 'g')
xlabel('Number of Timesteps')
ylabel('Total Complexity - Includes Cost of Calculating DFs')
legend('AC','DC - DFs Calculated Once', 'DC - Recalculated DFs for every t','New')

figure(2)
plot(t, AC)
hold on
plot(t, DCruntime, 'r')
plot(t, DCtop, 'r--')
plot(t, Newruntime, 'g')
xlabel('Number of Timesteps')
ylabel('Total Complexity - Ignore Cost of Calculating DFs')
legend('AC','DC - DFs Calculated Once', 'DC - Recalculated DFs for every t','New')

a1 = 2*m^3
a2 = m^3+2*m^2+n^3
