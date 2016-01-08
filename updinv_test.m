clear all
clc

A = [1.5 -0.5 -1.5 2 -3;
    -3 1.5 2 -3 4;
    -1 0.5 1 -1 1;
    2 -0.5 -1 2 -2;
    -1 0.5 0 -0.5 0.5]

invA = inv(A);

% D is sparse and singular (cannot be inverted)
D = [0 0 0 0 0;
    0 -1.5 0 -1 2;
    -2 -2 3 1 2;
    -6 -5 4 3 8;
    -2 -1 0 1 2];

tic
inv(A+D)
toc

tic
newinv = updinv(A, invA, D)
toc