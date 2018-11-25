%
% S-parameters extraction with wave unknowns
%

addpath(genpath([ pwd, '/..' ]));

%
% s-parameters of a ladder network
%
% (1)--L--(2)--L--(3)
%          |
%          C
%          |
%         (4)

% 1 - port1
% 2 - port2
% 3 - L
% 4 - C
% 5 - L
branches=[ 1 4 ; 3 4 ; 1 2 ; 2 4 ; 2 3 ];

% Ladder elements
C = 2.0e-11;
L2 = 2.5e-8; % half-admittance

% frequency
w = 2*pi*1.0e8;

nb = size( branches, 1 ); % number of the branches

% overall s
S = zeros( nb, nb );
S(3,3) = y2s( 1.0 / ( j * w * L2 ) );
S(4,4) = y2s( j * w * C );
S(5,5) = y2s( 1.0 / ( j * w * L2 ) );

% 1 the branch is a port, 0 otherwise
isport = zeros( 1, nb );
isport( 1 ) = 1;
isport( 2 ) = 1;

% Inverted square root of the normalization impedances -- just 1 so far
z0x = eye( nb );

% branches matrix
d=mkbranchmat(branches);
d=d(:,2:end); % Node 1 is the ground

% that is the one we actually need -- dd*I = 0
dd=d';

% Matrix to remove port columns/rows
M = eye( nb, nb );
M = M( : , find( !isport ) ); % S * M removes port columns

% Matrix to remove model columns/rows
P = eye( nb, nb );
P = P( : , find( isport ) ); % S * P removes model columns

% P0*S zeroes non-port rows, S*P0 zeroes non-port columns
P0 = diag( ~isport );

% M0*S zeroes port rows, S*M0 zeroes port columns
M0 = diag( isport );

% To simplify the expressions below
L = dd*z0x;
Lm = L*M;
Lp = L*P;

np = 2;                   % number of the ports
nm = nb - np;             % number of the model branches
nn = size( d, 2 );        % number of nodes

% Excitation waves
Bp = eye( np, np );

% Formulation with the node potentials
A = [ zeros( nn, nn )     -L*( S - eye( nb, nb ) ) ;
                  L'        -( S + eye( nb, nb ) ) ];

b = [ Lp*Bp ; Bp ; zeros( nm, np ) ];

x = A\b;

Ap = x( nn+1:nn+np , : );

Sm = Ap

% Only A unknowns
L = dd*z0x;
Lm = L*M;

% number of the model branches
nm = nb - np;

Ib = eye( nb, nb );

A = L'*inv(Lm*Lm')*L + -Ib + 0.5 * P0 * ( Ib - S ) * P0;

% rhs
b = ( ( L'*inv(Lm*Lm')*L + Ib ) * P ) * Bp;

x = A \ b;

Ap = x( 1:np , : );

Sm = Ap



