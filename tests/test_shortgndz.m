function test_shortgndz
%
% Test shortgndz function by comparison of the results with the results
% obtained using a nodal circuit solver.

% The test matrix
Zfull = ...
[  4.670e-1  -7.941e-1   9.839e-1   3.575e-1   0.000e+0  -6.916e-1 ; ...
  -7.941e-1  -3.902e-1   1.186e+0   6.812e-1   0.000e+0   6.674e-4 ; ...
   9.839e-1   1.186e+0   1.046e+0   0.000e+0  -8.236e-1   9.617e-1 ; ...
   3.575e-1   6.812e-1   0.000e+0   8.484e-1   0.000e+0  -1.196e-1 ; ...
   0.000e+0   0.000e+0  -8.236e-1   0.000e+0   4.849e-1   0.000e+0 ; ...
  -6.916e-1   6.674e-4   9.617e-1  -1.196e-1   0.000e+0   7.672e-2 ];
Z = shortgndz(Zfull);

N = size(Zfull,1);

% N edges representing N-port characterized by N-port plus
% N/2 testing edges
e = [ [ (1:N)' repmat(N+1,N,1)] ; [ (1:2:N)' (2:2:N)' ] ];
ne = size(e,1);
NZ=eye(ne)*1e+10; % Internal resistance of the current source
NZ(1:N,1:N)=Zfull;

W=zeros(ne,N/2);
K=zeros(ne,N/2);
K(N+1:end,:) = -eye(N/2); % Minus is here because positive current
                          % for a port is negative for the testing branch.
[F,V,I] = solve(e,inv(NZ),W,K);

Ztest = V(N+1:end,:);

assertEquals(Ztest, Z, 1e-8)
