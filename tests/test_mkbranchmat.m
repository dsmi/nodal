function test_mkbranchmat
%
%

e = [ 1 2 ; 2 3 ; 4 5 ; 1 5; 1 3 ];

d = mkbranchmat(e);

P = [ 1 2 3 4 5 ].';
V = [ 1 1 1 4 2 ].';
V_test = d*P;

assertEquals(V_test, V)
