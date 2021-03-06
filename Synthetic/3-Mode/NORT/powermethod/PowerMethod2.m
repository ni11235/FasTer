function [ U, S, V ] = PowerMethod2( subs, vals, U, V, R, tenSz, para )

maxIter = para.maxIter;

Y = subMultiu( subs, vals, U, V, R, tenSz )';

i = 1;
while(1)
    [Q, ~] = qr(Y, 0);
    
    if(i == maxIter)
        break;
    else
        i = i + 1;
    end
    
    Y = subMultiv( subs, vals, U, V, Q, tenSz );
    Y = subMultiu( subs, vals, U, V, Y, tenSz )';
end

[U, S, V] = reduceSVD( subs, vals, U, V, Q, tenSz );

end

%% ------------------------------------------------------------------------
function [ X ] = subMultiu( subs, vals, U, V, L, tenSz )

X = (L'*U{2})*(V{2}');

for i = 1:size(L,2)
    l = L(:, i);
    
    x = subMulti1M2u( U{1}, V{1}, l, tenSz );
    x = x + subMulti3M2u( U{3}, V{3}, l, tenSz );
    
    X(i, :) = X(i, :) + x;
end

X = X + subSpa2Mu_c(subs, vals, L, tenSz);

end

%% ------------------------------------------------------------------------
function [ X ] = subMultiv( subs, vals, U, V, R, tenSz )

X = U{2}*(V{2}'*R);

for i = 1:size(R,2)
    r = R(:, i);
    
    x = subMulti1M2v( U{1}, V{1}, r, tenSz );
    x = x + subMulti3M2v( U{3}, V{3}, r, tenSz );
    
    X(:, i) = X(:, i) + x;
end

X = X + subSpa2Mv_c(subs, vals, R, tenSz);

end

%% ------------------------------------------------------------------------
function [Ur, Ss, Vr] = reduceSVD(subs, vals, U, V, Q, sz)

Ur = subMultiv(subs, vals, U, V, Q, sz);
[Ur, Rr] = qr(Ur, 0);
[Us, Ss, Vs] = svd(Rr, 'econ');
Ur = Ur*Us;
Vr = Q*Vs;

end