
%% 2        3 
%% .---R2---.---.
%% |        |   |
%% |        |   |
%% V1       R3  R4
%% |        |   |
%% |        |   |
%% .--------.---.
%% 1

V1=5;
R2=6;
R3=7;
R4=8;

R34=R3*R4/(R3+R4);
R234=R2+R34;
Itest=-V1/R234

branches=[ 1 2 ; 2 3 ; 3 1 ; 3 1 ];

nb=size(branches, 1);
W = [ V1 ; 0 ; 0 ; 0 ];
K = 0*W;
Y = zeros(nb,nb);
Y(1,1) = 1e10;
Y(2,2) = 1/R2;
Y(3,3) = 1/R3;
Y(4,4) = 1/R4;

[F, V, I] = solve(branches,Y,W,K)
