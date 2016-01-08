clc
clear all

simauto = actxserver('pwrworld.SimulatorAuto');
%simauto.OpenCase('C:\Users\lxiong7\Dropbox\ACES Research\PSERC EMS Project\Test Cases\3BUSEX_EQUALXs.pwb');
%simauto.OpenCase('C:\Users\lxiong7\Dropbox\ACES Research\PSERC EMS Project\Test Cases\B7FLAT_DC.pwb');
%simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE Reliability\24Bus_DC.pwb');
%simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\IEEE 118 Bus Case\118_DC.pwb')
simauto.OpenCase('C:\Users\lxiong7.AD\Dropbox\ACES Research\PSERC EMS Project\Test Cases\TVA\TVASummer15Base_DC.pwb')

DC_CA

simauto.CloseCase();
delete(simauto);

[Bp, Ybusp] = calcBp(buses, lines(:,1), lines(:,2), lines(:,5), slack, lineStatus);
Bp

invBp = inv(Bp);

Tvec_mat = zeros(numbuses-1,numlines);
for a = 1:numlines
    if strcmp(lineStatus(a),'Closed')
        Tvec_mat(:,a) = calcTvector(buses, lines(a,1), lines(a,2), slack);
    end
end
Tvec_mat