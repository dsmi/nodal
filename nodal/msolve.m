function [F, V, I, M, b]=msolve(branches, Y, W, K, Z, A, B)
% function [F, V, I, M, b]=msolve(branches, Y, W, K, Z, A, B)
% 
% Solves the linear circuit. Node 1 is assumed to be the only ground.
% The circuit is solved using the modified nodal analysis which allows
% the perfecly conducting branches.
% Please see a brief description of the modified nodal analysis at
% the bottom of the comment.
%
% Inputs:
%  branches  - array of size NEx2, where NE is the numver of branches,
%              first column is starting node of the branch, second column is
%              the ending node.
%  Y  - edge admittances, matrix of size NExNE. If Y(n,n)>1e99 then the
%       nth branch is considered to be sungular (short, superconductive)
%       and is treated correspondingly
%  W  - column vector(s) of edges' voltage sources
%  K  - column vector(s) of edges' current sources
%  Z  - mutual impedances matrix, NExNE. Is to be used to add current
%       controlled voltage sources to the circuit: V(n)=Z(n,m)*I(m). Both
%       m and n should be singular branches, otherwise the mutual impedance
%       is ignored.
%       Is allowed to be omitted or empty.
%  A  - mutual current/current matrix, NExNE. Is to be used to add current
%       controlled current sources to the circuit: I(n)=A(n,m)*I(m). n should
%       be non-singular, m should be singular - otherwise A(n,m) is ignored.
%       Is allowed to be omitted or empty.
%  B  - mutual voltage/voltage matrix, NExNE. Is to be used to add voltage
%       controlled voltage sources to the circuit: V(n)=A(n,m)*V(m). n should
%       be singular, m should be non-singular - otherwise B(n,m) is ignored.
%       Is allowed to be omitted or empty.
% Outputs:
%  F - node potentials
%  V - edge voltages
%  I - edge currents
%  M - the matrix of the MNA matrix equation. Se below for the details
%      on how it is built.
%  b - right-hand side vector of the MNA matrix equation. Can be useful
%      for inspection, see below for the details on how it is built.
%
%
% The modified nodal analysis extends the nodal analysis, and the description
% of the MNA extends the description of the NA given in the solve function
% comment - please read it before reading the below.
% The aim of the MNA is to allow the perfectly conducting (short, singular)
% branches. We then introduce the following permutation-like matrices 
%     C=isinf(Y)  
%     D=eye(nb,nb)-C;
% Then the dd*Y*d can be written as
%     dd*C*Y*C*d+dd*D*Y*D*d
% For the singular branches the following holds (K=0):
%     dd*C*Y*C*d*F=-dd*C*I-dd*C*Y*W
%
% Lefthand part of the equation (1)
%   dd*Y*d*F=dd*D*Y*D*d*F-dd*C*I-dd*C*Y*W                             (2)
% Righthand part of the equation (1)
%   dd*(K-Y*W)=dd*K-dd*D*Y*W-dd*C*Y*W                                 (3)
%
% Using (2) and (3):
%   dd*D*Y*D*d*F-dd*C*I-dd*C*Y*W = dd*K-dd*D*Y*W-dd*C*Y*W
%   dd*D*Y*D*d*F-dd*C*I          = dd*K-dd*D*Y*W                      (4)
% Now (4) includes the additional unknowns C*I. (currents in
% the singular branches) We then introduce the matrices CR and CC such
% thet CR*M picks only rows of the matrix M which correspond to the
% singular branches, and M*CC pick the singular columns of M. The
% values of the matrices are
%   CC=C(:,find(diag(C)));
%   CR=CC';
% Now we reshape (4) as
%  [ dd*D*Y*D*d   -dd*CC ]*[ F ; CR*I ] = dd*K-dd*D*Y*W               (5)
% The number of unknowns in (5) is greater than the number of equations.
% (or equal if there is no singular branches). We can augment (5) by
% the following equation:
%                               CR*d*F = CR*W                         (6)
% Equations (5) and (6) implement the modified nodal analysis.
% 
%

% Is allowed to be undefined or empty
if ~exist('Z', 'var') || isempty(Z)
    Z=0*Y;
end

% Is allowed to be undefined or empty
if ~exist('A', 'var') || isempty(A)
    A=0*Y;
end

% Is allowed to be undefined or empty
if ~exist('B', 'var') || isempty(B)
    B=0*Y;
end

% Solution starts here
d=mkbranchmat(branches);
d=d(:,2:end); % Node 1 is the ground

dd=d';

nb=size(branches,1); % num of branches
nn=max(branches(:)); % num of nodes

% Find singular branches (infinite conductance)
% C is a diagonal matrix with the diagonal elements equal to
%   1 if the corresponding branch is singular
%   0 if the branch is not singular
C=double(Y>1e99);

% Resistive  branches - the diagonal has zeros for singular
% branches and ones for non-singular
D=eye(nb,nb)-C;

% Matrix to remove non-singular columns/rows
SC = eye( nb, nb );
SC = SC(:, find(diag(C)) ); % Y * sc removes non-singular columns

% C with zero columns/rows removed
CC = C*SC;
CR = SC'*C;

% Prepare blocks of the MNA matrix
CA = (C+A)*SC;
CB = SC'*(C-B);

ZZ = SC'*Z*SC;

M=[ dd*D*Y*D*d   -dd*CA ; ...
          CB*d    ZZ  ];

b=[ dd*K-dd*D*Y*D*W ; ... 
      -CR*W ];

x=M\b;
F=x(1:nn-1);
V=-d*F;           % branch voltages
Is=x(nn:end);     % singular branch currents
I=D*(K+Y*(V-W));  % branch currents
if ~isempty(Is)
   I = I+CC*Is+A*SC*Is;
end
