clc
clear all

simauto = actxserver('pwrworld.SimulatorAuto');

%% Small: IEEE RTS-24 system for full AC N-1 CA
simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\Timing\24Bus_ACN-1.pwb')
tic
simauto.RunScriptCommand('EnterMode(Run)');
str = sprintf('CTGSolveAll');
results = simauto.RunScriptCommand(str);
toc
str = sprintf('CTGWriteResultsAndOptions("CAreport.txt",[default],SECONDARY,YES)'); % CAreport.txt is in \Test Cases folder
results = simauto.RunScriptCommand(str);
simauto.CloseCase();

simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\Timing\24Bus_ACN-2.pwb')
tic
simauto.RunScriptCommand('EnterMode(Run)');
str = sprintf('CTGSolveAll');
results = simauto.RunScriptCommand(str);
toc
str = sprintf('CTGWriteResultsAndOptions("CAreport.txt",[default],SECONDARY,YES)'); % CAreport.txt is in \Test Cases folder
results = simauto.RunScriptCommand(str);
simauto.CloseCase();

%% Medium: IEEE 118-bus system for full AC N-1 CA
% simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\Timing\IEEE118_ACN-1.pwb')
% tic
% simauto.RunScriptCommand('EnterMode(Run)');
% str = sprintf('CTGSolveAll');
% results = simauto.RunScriptCommand(str);
% toc
% str = sprintf('CTGWriteResultsAndOptions("CAreport.txt",[default],SECONDARY,YES)'); % CAreport.txt is in \Test Cases folder
% results = simauto.RunScriptCommand(str);
% simauto.CloseCase();
% 
% 
% % Medium: IEEE 118-bus system for full AC N-2 CA
% simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\Timing\IEEE118_ACN-2.pwb')
% tic
% simauto.RunScriptCommand('EnterMode(Run)');
% str = sprintf('CTGSolveAll');
% results = simauto.RunScriptCommand(str);
% toc
% str = sprintf('CTGWriteResultsAndOptions("CAreport.txt",[default],SECONDARY,YES)'); % CAreport.txt is in \Test Cases folder
% results = simauto.RunScriptCommand(str);
% simauto.CloseCase();

%% Full AC N-1 takes about 50 secs, full AC N-2 takes about 3.5 hrs

% Large: TVA system for full AC N-1 CA
% tic
% simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\Timing\TVASummer15Base_ACN-1.pwb')
% simauto.RunScriptCommand('EnterMode(Run)');
% str = sprintf('CTGSolveAll');
% results = simauto.RunScriptCommand(str);
% str = sprintf('CTGWriteResultsAndOptions("CAreport.txt",[default],SECONDARY,YES)'); % CAreport.txt is in \Test Cases folder
% results = simauto.RunScriptCommand(str);
% simauto.CloseCase();
% toc

% Large: TVA system for full AC N-2 CA
% tic
% simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\Timing\TVASummer15Base_ACN-2.pwb')
% simauto.RunScriptCommand('EnterMode(Run)');
% str = sprintf('CTGSolveAll');
% results = simauto.RunScriptCommand(str);
% str = sprintf('CTGWriteResultsAndOptions("CAreport.txt",[default],SECONDARY,YES)'); % CAreport.txt is in \Test Cases folder
% results = simauto.RunScriptCommand(str);
% simauto.CloseCase();
% toc

delete(simauto);