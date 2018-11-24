%
% Branches 1 and 2 here form an ideal transformer
%

addpath(genpath([ pwd, '/..' ]));

branches=[ 3 2 ; 5 4 ; 1 2 ; 2 3 ; 1 4 ; 4 5];

nb=size(branches, 1);
W = [ 0 ; 0 ; 3 ; 4 ; 5 ; 6 ];
K = 0*W;
Y = zeros(nb,nb);
Y(3,3) = 1e4;
Y(4,4) = 10;
Y(5,5) = 1e4;
Y(6,6) = 11;

% That's the simplest solution which adds just one I
Y(2,2) = 1e100;

A = 0*Y;
A(1,2) = -1;

B = 0*Y;
B(2,1) = 1;

Z = Y*0;

%% % Solution with two extra unknowns, more stable?
%% Y(1,1) = 1e100;
%% Y(2,2) = 1e100;

%% A = 0*Y;

%% B = 0*Y;
%% B(1,1) = 1;
%% B(2,1) = -1;
%% B(2,2) = 2;

%% Z = Y*0;
%% Z(1,1) = 1;
%% Z(1,2) = 1;

[ F, V, I, M, b ] = msolve(branches, Y, W, K, Z, A, B);

V12 = V(1:2)
I12 = I(1:2)
