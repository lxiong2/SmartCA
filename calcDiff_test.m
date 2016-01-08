clear all
clc

buses = [101; 102; 103]
busGen1 = [101 1 80; 102 1 20]
busLoad1 = [103 1 100]

busGen2 = [101 1 85 90; 102 1 25 30]
busLoad2 = [103 1 110 120]

[diffS, diffB] = calcDiff(buses, busGen1, busLoad1, busGen2, busLoad2)