%
% Two stacked ladders, simulated in two different ways
%
% Here is the first way, with the mutual inductances:
%
% (2)---L---(4)--2L---(6)--L/2--(8)
%       |    |    |    |    |
%      M/2   C    M    C   M/2
%       |    |    |    |    |
% (3)--L/2--(5)---L---(7)--L/2--(9)
%            |         |
%            C         C
%            |         |
% (1)---------------------------(1)
%
% Branches:
%   1 - port1
%   2 - port2
%   3 - port3
%

addpath(genpath([ pwd, '/..' ]));

% L and C of a section
L = 1.0e-8/2;
C = 1.0e-10/2;
M = L; % Mutual L on the top layer

% Number of sections
ns = 2;

% Frequency
w = 2*pi*1.0e6;

branches=[ 1 2 ; 9 8 ; 1 9 ]; % ports
for s = 1:ns
    branches = [ branches ; s*2 s*2+2 ; s*2+1 s*2+3 ; s*2+2 s*2+3 ; s*2+3 1 ];
end
branches=[ branches ; ns*2+2 ns*2+4 ; ns*2+3 ns*2+5 ]; % last with no caps
           
nb = size( branches, 1 ); % number of the branches
np = 3;                   % number of the ports

W = zeros( nb, np );
K = zeros( nb, np );

% Currents applied to ports
K( 1:np, 1:np ) = eye( np );

Y = zeros( nb, nb );
k = 0.5; % First section has half L
for s = 1:ns
    Y( s*4+0 : s*4+1, s*4+0 : s*4+1 ) = inv( j*w*k*[ 2*L M ; M L ] );
    Y( s*4+2 : s*4+3, s*4+2 : s*4+3 ) = j*w*C * eye( 2 );
    k = 1.0;
end
% Last section with half L and no C
Y( ns*4+4 : ns*4+5, ns*4+4 : ns*4+5 ) = inv( j*w/2*[ 2*L M ; M L ] );

[ F, V, I, A1 ] = solve( branches, Y, W, K );

% Extracted z-parameters
Z1 = -V(1:np,1:np);
imag(Z1)

% And here is curcuit with no mutual inductances
%
% (2)--L/2--(4)---L---(6)--L/2--(8)
%            |         |
%            C         C
%            |         |
%    +--------------------------(3)
%    |
%    +-L/2--(5)---L---(7)--L/2--(9)
%            |         |
%            C         C
%            |         |
% (1)---------------------------(1)

branches=[ 1 2 ; 3 8 ; 1 9 ]; % ports
for s = 1:ns
    branches=[ branches ; s*2 s*2+2 ; s*2+1 s*2+3 ; s*2+2 3 ; s*2+3 1 ];
end
branches=[ branches ; ns*2+2 ns*2+4 ; ns*2+3 ns*2+5 ]; % last sect with no caps
           
nb = size( branches, 1 ); % number of the branches
np = 3;                   % number of the ports

W = zeros( nb, np );
K = zeros( nb, np );

% Currents applied to ports
K( 1:np, 1:np ) = eye( np );

Y = zeros( nb, nb );
%% Y(4:5,4:5)     = 1 / (j*w*L/2) * eye( 2 );
%% Y(6:7,6:7)     = j*w*C * eye( 2 );
%% Y(8:9,8:9)     = 1 / (j*w*L) * eye( 2 );
%% Y(10:11,10:11) = j*w*C * eye( 2 );
k = 0.5; % First section has half L
for s = 1:ns
    Y( s*4+0 : s*4+1, s*4+0 : s*4+1 ) = 1 / (j*w*L*k) * eye( 2 );
    Y( s*4+2 : s*4+3, s*4+2 : s*4+3 ) = j*w*C * eye( 2 );
    k = 1.0;
end
% Last section with half L and no C
Y( ns*4+4 : ns*4+5, ns*4+4 : ns*4+5 ) = 1 / (j*w*L/2) * eye( 2 );

[ F, V, I, A2 ] = solve( branches, Y, W, K );

% Extracted z-parameters
Z2 = -V(1:np,1:np);
%imag(Z2)
Z1-Z2
cond(A1)
cond(A2)
