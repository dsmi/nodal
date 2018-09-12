function [F, V, I, dYd]=solve(branches, Y, W, K)
% function [F, V, I, dYd]=solve(branches, Y, W, K)
% 
% Solves the linear circuit. Node 1 is assumed to be the only ground.
% The circuit is solved using the nodal analysis, which means that no circuit
% elements are allowed to have infinite admittance, please refer to msolve which
% implements the modified nodal analysis and is free of this restriction.
% Please see a brief description of how the nodal analysis works and how it is
% implemented here below at the bottom of the comment.
%
% Inputs:
%  branches  - array of size NEx2, where NE is the numver of branches,
%              first column is starting node of the branch, second column is
%              the ending node.
%  Y  - edge admittances, matrix of size NExNE
%  W  - column vector(s) of edges' voltage sources
%  K  - column vector(s) of edges' current sources
%  Z  - mutual impedances matrix, size NExNE. 
% Outputs:
%  F - node potentials
%  V - edge voltages
%  I - edge currents
%  dYd - the transform matrix
%
% Nodal analysis description starts here.
%
% The circuit under analysis is modeled as a graph of branches, each of
% the branches have some resistance and may include voltage and/or current
% source as shown in the following schematics:
%
%      +| -    Z
%  .----||--/\/\/\-----. -> I
%  0 |  |           |  1
%    |              |
%    |    ------    |
%    ----| K -> |----
%         ------
%      
%  W - voltage source
%  R - resistance
%  V - voltage across the branch (potential at 0 minus potential at 1)
%  I - current from 0 to 1
% 
% The equation governing each branch is as follows
%     I-K=Y*(V-W)
% This can be written in matrix form: I, K, V and W are the vectors,
% Y is a matrix.
% Then using the boundary map dd which can be used to expresses
% the Kirchhoff's current law as dd*I=0
%     dd*(I-K)=dd*Y*(V-W)
%     dd*I=dd*(K+Y*(V-W))
% Then using the co-boundary map (adjoint of dd, dd=d') d*F=-V
%     dd*I=dd*K-dd*Y*d*F-dd*Y*W
%     dd*Y*d*F=dd*K-dd*I-dd*Y*W
% Finally using the aforementioned dd*I=0
%     dd*Y*d*F=dd*(K-Y*W)                                             (1)
% This can be solved for the node potentials F
%

d=mkbranchmat(branches);
d=d(:,2:end); % Node 1 is the ground

dd=d';

b = dd*(K-Y*W);
dYd = dd*Y*d;

F = dYd\b;
V = -d*F;
I = K + Y*(V-W);
