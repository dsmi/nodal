function test_csrc
%
% Controlled sources tests.
% The tests are done using the circuit below.
%
%  2           3  
%  .------.    .--------.
%  |      |    |        |
%  V1     R2  I/V3      R4
%  |      |    |        |
%  .------.    .--------.
%         1             1
%
% The I/V3 is:
%  1) Voltage controlled current source - uses Y matrix
%      I3=k*V(R2), Y(3,2)=k
%  2) Voltage controlled voltage source - uses B matrix
%      V3=k*V(R2), B(3,2)=k
%  3) Current controlled current source - uses A matrix
%      I3=k*I(V1), A(3,1)=k
%  4) Current controlled voltage source - uses Z matrix
%      V3=k*I(V1), Z(3,1)=k
%
  
V1=5;
R2=10;
V3=0;
R4=20;

branches = [ 1 2 ; 2 1 ; 1 3 ; 3 1 ];

nb=size(branches,1); % num of branches

Y=zeros(nb,nb);
Y(1,1)=1e100;
Y(2,2)=1/R2;
Y(3,3)=0;
Y(4,4)=1/R4;

% current sources
K=zeros(nb,1);

% voltage sources
W=zeros(nb,1);
W(1)=V1;
W(3)=V3;

k=0.5;
Y0=Y;

% Case 1 - vccs.
Y(3,2)=k;
[F, V, I, M]=msolve(branches, Y, W, K);
I2=-V1/R2;
I3=-k*V1;
V4=R4*I3;
assertEquals([ V1 ; -V1 ; -V4 ; V4 ], V, 1e-15)
assertEquals([ I2 ; I2 ; I3 ; I3 ], I, 1e-15)

% Case 2 - vcvs.
Y=Y0;
B=Y*0;
B(3,2)=k;
Y(3,3)=1e100;
[F, V, I, M]=msolve(branches, Y, W, K, [], [], B);
V3=-k*V1;
I4=-V3/R4;
assertEquals([ V1 ; -V1 ; V3 ; -V3 ], V, 1e-15)
assertEquals([ I2 ; I2 ; I4 ; I4 ], I, 1e-15)


% Case 3 - cccs.
Y=Y0;
A=Y*0;
A(3,1)=k;
[F, V, I, M]=msolve(branches, Y, W, K, [], A);
I3=k*I2;
V4=R4*I3;
assertEquals([ V1 ; -V1 ; -V4 ; V4 ], V, 1e-15)
assertEquals([ I2 ; I2 ; I3 ; I3 ], I, 1e-15)

% Case 4 - ccvs.
Z=Y*0;
Z(3,1)=k;
Y(3,3)=1e100;
[F, V, I, M]=msolve(branches, Y, W, K, Z);
V3=k*I2;
I4=-V3/R4;
assertEquals([ V1 ; -V1 ; V3 ; -V3 ], V, 1e-15)
assertEquals([ I2 ; I2 ; I4 ; I4 ], I, 1e-15)

