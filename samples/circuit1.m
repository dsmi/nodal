
%% 2        3 
%% .---R2---.---.
%% |        |   |
%% |        |   |
%% V1       R3  R4
%% |        |   |
%% |        |   |
%% .--------.---.
%% 1

addpath(genpath([ pwd, '/..' ]));

W1=5;
R2=6;
R3=7;
R4=8;

R34=R3*R4/(R3+R4);
R234=R2+R34;
Itest=-W1/R234

branches=[ 1 2 ; 2 3 ; 3 1 ; 3 1 ];

nb=size(branches, 1);
W = [ W1 ; 0 ; 0 ; 0 ];
K = 0*W;
Y = zeros(nb,nb);
Y(1,1) = 1e10;
Y(2,2) = 1/R2;
Y(3,3) = 1/R3;
Y(4,4) = 1/R4;

[F, V, I, dYd] = solve(branches,Y,W,K)

%
%                I3=V3*Y3
%  I2=V2*Y2      I4=V4*Y4
% node2:  I1-I2=0
% node3:  I2-I3-I4=0
%  V1=F2
%  V2=F3-F2
%  V3=-F3
%  V4=-F3
%  I1=(F2-W1)*Y1    I3=-F3*Y3
%  I2=(F3-F2)*Y2    I4=-F3*Y4
%  F2*(Y2)  - F3*Y2                = 0
%  F2*Y2      + F3*(Y2+Y3+Y4)      = 0
%                              I1 
% | Y2     Y2          1 |  F2
% | Y2     (Y2+Y3+Y4)  0 |  F3
% | (1-K)  K           0 |  I1 = W1
% W1 = (F3-F2)*K

