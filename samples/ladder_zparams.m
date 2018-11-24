%
% z-parameters of a ladder network
%
% (1)--L--(2)--L--(3)
%          |
%          C
%          |
%         (4)

addpath(genpath([ pwd, '/..' ]));

% 1 - port1
% 2 - port2
% 3 - L
% 4 - C
% 5 - L
branches=[ 1 4 ; 3 4 ; 1 2 ; 2 4 ; 2 3 ];

nb = size( branches, 1 ); % number of the branches
np = 2;                   % number of the ports

W = zeros( nb, np );
K = zeros( nb, np );

% Currents applied to ports
K( 1, 1 ) = 1;
K( 2, 2 ) = 1;

% Ladder elements
C = 2.0e-11;
L2 = 2.5e-8; % half-admittance

% frequency
w = 2*pi*1.0e8;

Y = zeros(nb,nb);
Y(3,3) = 1.0 / ( j * w * L2 );
Y(4,4) = j * w * C;
Y(5,5) = 1.0 / ( j * w * L2 );

[ F, V, I ] = solve( branches, Y, W, K );

% V = Z * I
% v1 = Z11*i1 + Z12*i2
% v2 = Z21*i1 + Z22*i2

% Extracted z-parameters
Z = -V(1:np,1:np)


