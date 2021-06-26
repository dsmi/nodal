% Admittance/impedance of 2-port terminated at one side

addpath(genpath([ pwd, '/..' ]));

% Branches:
%   1 - port1
%   2 - port2
%   3 - Is excitation
%   4 - Yl termination

Yl = 7.3;
Is = 2.6;

branches=[ 1 2 ; 1 3 ; 1 2 ; 1 3 ];

nb = size( branches, 1 ); % number of the branches
np = 1;                   % number of the ports

W = zeros( nb, np );
K = zeros( nb, np );

% Currents applied to ports
K( 3, 1 ) = Is;

Y = zeros(nb,nb);
Y(1,1) = 1.9;
Y(1,2) = 0.4;
Y(2,1) = 0.6;
Y(2,2) = 3.45;
Y(4,4) = Yl;

[ F, V, I ] = solve( branches, Y, W, K );

F

% My formula for the terminated two-port
V1 = (Y(2,2)+Yl)*Is/((Y(2,2)+Yl)*Y(1,1)-Y(2,1)*Y(1,2))
