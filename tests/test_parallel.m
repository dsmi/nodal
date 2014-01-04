function test_parallel
%
% Circuit consisting of a voltage source and two resistors
% connected in parallel

e = [ 1 2 ; 2 1; 2 1 ];
ne = size(e,1);
nn = 2;
K=zeros(ne,1);
W=zeros(ne,1);
Y=eye(ne);
Y(1,1) = 1e10;
Y(2,2) = 1/50;
Y(3,3) = 1/50;
W(1,1) = 1;

[F,V,I] = solve(e, Y, W, K);

F_test = [ -1 ]';
V_test = [ 1 -1 -1 ]';
I_test = [ -0.04 -0.02 -0.02 ]';

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
