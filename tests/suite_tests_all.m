function suite_tests_all
% suite_tests_all : testsuite including all the nodal analysistests.
%

addTest('test_mkbranchmat');
addTest('test_parallel');
addTest('test_series');
addTest('test_shortgndz');
addTest('test_csrc');
