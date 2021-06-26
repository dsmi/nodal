% Experiments with multi-reference transmission line
%

addpath(genpath([ pwd, '/..' ]));

% 1    - port1
% 2    - port2
% 3, 4 - tline second reference ports
% 5, 6 - tline signal ports

%          prt1  prt2  ref1  ref2  sig1  sig2  
%% branches=[ 1 2 ; 1 3 ; 1 4 ; 1 5 ; 1 2 ; 1 3 ; 1 4 ; 1 5 ];
branches=[ 4 2 ; 4 3 ; 4 4 ; 4 4 ; 4 2 ; 4 3 ; 5 1 ];

nb = size( branches, 1 ); % number of the branches
np = 2;                   % number of the ports

W = zeros( nb, np );
K = zeros( nb, np );

% Currents applied to ports
K( 1, 1 ) = 1;
K( 2, 2 ) = 1;

% Tline block to be updated on each frequench
Y = zeros(nb,nb);

% The resulting z-params
Z = [ ];

% frequency range
wrange = 2*pi*linspace(1.0e7, 4.1e9, 1001);
%% wrange = 2*pi*linspace(1.0e7, 4.1e9, 11);

for w = wrange

    %% Port admittance is zero, but in some cases we need to set
    %% it to some small value
    Y(1,1) = 1e-6;
    Y(2,2) = 1e-6;
    
    Ys = tliney(70,1e-9,w);
    k2 = 0.1; % the other reference carries k of the total current
    k = [ k2 0 ; 0 k2 ];
    
    % The overall Y matrix of the transmission line with multiple references
    % we are composing here looks like this, where Ys is the single-reference
    % transmission line admittance and k is the current distribution
    Yl = [ k*Ys*k'   k*Ys ; ...
             Ys*k'    Ys ];

    % Multi ref line inserted into the total admittance matrix
    Y(3:6,3:6) = Yl;

    % Path to ground!
    Y(7,7) = 1;

    %% % Another tline which connects references
    %% Y(7:8,7:8) = tliney(10,1e-12,w);

    [ F, V, I ] = solve( branches, Y, W, K );

    % Extracted z-parameters
    Zw = -V(1:np,1:np);
    Z = cat( 3, Z, Zw );
    
end

% Convert to 50-ohm s-parameters
S = renorms( z2s( Z ), ones( np, 1 ), 50.0*ones( np, 1 ) );

tswrite( 'tline70_mref.s2p', wrange/(2*pi), S, 'S', 50.0 );
