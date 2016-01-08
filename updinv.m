function res = updinv(a, ainv, d)

%updinv(a, ainv, d) returns inverse of the matrix a+d
%here: a is an invertible matrix with its inverse ainv=a^(-1)
% and d i a given perturbatin

% check accuracy of the inverse (slow
% err = 1e-6
% if (norma(a*ainv-speye(size(a,1)),Inf)>err)
%   disp(['Inaccurate inverse:||a*ainv-I||>',num2str(err)]);
%   return;
% end

n = size(a,1);

% nonzero elements
[rows,cols]=find(d);

%remove duplicates and sort
rows = union(rows,rows)
cols = union(cols,cols)

m1 = length(rows)
m2 = length(cols)

D11 = d(rows,cols)
Bll = ainv(cols,rows)

restcols = setdiff(1:n,cols)
restrows = setdiff(1:n,rows)

% permutation of rows, columns
newrows = [rows.', restrows]
newcols = [cols.', restcols]

Bc = ainv(newcols,rows)
Br = ainv(cols',newrows)

if m1 <= m2
    C1 = D11*Bll;
    C2 = speye(m1)+C1;
    C3 = D11*Br;
    C4 = C2\C3;
    H = -Bc*C4;
else
    C1 = B11*D11;
    C2 = speye(m2)+C1;
    C3 = Bc*D11;
    C4 = C2\Br;
    H = -C3*C4;
end

% inverse permutation of rows, columns
invrows(newrows) = 1:n;
invcols(newcols) = 1:n;

Hn = H(invcols,invrows);
res = ainv+Hn;