function test_series
%
% Circuit consisting of a voltage source and two resistors
% connected in series

e = [ 1 2 ; 2 3; 3 1 ];
ne = size(e,1);
K=zeros(ne,1);
W=zeros(ne,1);
Y=eye(ne);
Y(1,1) = 1e10;
Y(2,2) = 1/50;
Y(3,3) = 1/50;
W(1,1) = 1;

F_test = [ -1 -0.5 ]';
V_test = [ 1 -0.5 -0.5 ]';
I_test = [ -0.01 -0.01 -0.01 ]';

[F, V, I] = solve(e,Y,W,K);

assertEquals(F_test, F, 1e-10)
assertEquals(V_test, V, 1e-10)
assertEquals(I_test, I, 1e-5)

% Solve it again but this time using the modified nodal analysis - notice
% the improved accuracy
Y(1,1) = 1e100;
[F,V,I] = msolve(e, Y, W, K);

assertEquals(F_test, F, 1e-15)
assertEquals(V_test, V, 1e-15)
assertEquals(I_test, I, 1e-15)
