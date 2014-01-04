function d=mkbranchmat(branches)
% d=mkbranchmat(branches)
%
% Makes the branches matrix d (co-boundary operator) which if multiplied
% by the node potienials vector gives the vector of the branch voltages
% with the minis sign:
%   d*F=-V, where F is the vector of node potentials and V is the vector
% of branch voltages.
%   The transpose of the d (designated to as dd) if multiplied by
% the vector of the branch currents gives the summary current enering
% a node, which is zero if the circuit is complete.
%  dd*I=0
% The only input is num_of_branches-by-2 array, first element of the row
% is the index of the branch beginning node, second element is the end
% node index.

nb=size(branches,1);
nn=max(branches(:));
d=zeros(nb,nn);
branchidx=[ (1:nb)' (1:nb)' ];
idx=sub2ind(size(d), branchidx, branches);
d(idx)=[ -ones(nb,1) ones(nb,1) ];
