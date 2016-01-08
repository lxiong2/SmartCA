% Perturbed matrix inversion example

clc
clear all

A = [1.5 -0.5 -1.5 2 -3;
    -3 1.5 2 -3 4;
    -1 0.5 1 -1 1;
    2 -0.5 -1 2 -2;
    -1 0.5 0 -0.5 0.5]

detA = det(A)
invA = inv(A);

B = invA

% D is sparse and singular (cannot be inverted)
D = [0 0 0 0 0;
    0 -1.5 0 -1 2;
    0 0 0 0 0;
    0 1.5 0 0 1;
    0 0 0 0 0]

detD = det(D)

Dtb = [-1.5 -1 2;
       1.5 0 1]
Btb = [4 0;
       -5 3;
       -1 1]
Bt = [B(:,2) B(:,4)] 
Bb = [B(2,:);
      B(4,:);
      B(5,:)]
  
% inv(I + Dtb*Btb)
disp('This inversion is better since the matrix has smaller dimension')
temp1 = (eye(2)+Dtb*Btb)
invtemp1 = inv(temp1)

% inv(I + Btb*Dtb)
temp2 = eye(3)+Btb*Dtb
invtemp2 = inv(temp2)

H1 = -Bt*invtemp1*Dtb*Bb

H2 = -Bt*Dtb*invtemp2*Bb

invAandD = B+H2

inv(A+D)