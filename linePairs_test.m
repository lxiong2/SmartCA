clc
clear all

numlines = 7;
status = {'Closed';
          'Closed';
          'Closed';
          'Closed';
          'Closed';
          'Closed';
          'Closed'};

pairs = linePairs(numlines, status)

size(pairs,1)
