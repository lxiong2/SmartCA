% Author: Leilei Xiong
% Date Created: August 29, 2013
% Date Revised: August 29, 2013

%B3L4TestSystem2

clear all
clc

buses = [101; 102; 103; 104]

lines = [101 102 1 0 0.1 0;
         101 103 1 0 0.1 0;
         101 103 2 0 0.2 0;
         101 104 1 0 0.3 0;
         102 103 1 0 0.1 0;
         102 103 2 0 0.1 0;
         102 104 1 0 0.1 0]
     
status = {'Open';
        'Closed';
        'Closed';
        'Closed';
        'Open';
        'Closed';
        'Closed'}
    
[pairs Ztot] = calcZtot(lines(:,1), lines(:,2), lines(:,5), status)
