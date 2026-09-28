function [W,W_EI] = graph2net(sA,e,d)

% function [W,W_EI] = graph2net(sA,e,d)
%
% sA = nxn binary adjacency matrix for a directed graph
%      -> can also have t values in [0,1] for interpolation b/w graphs
% e = epsilon value to control synaptic strengths (default: e = 0.25)
%     -> can be a vector of length n, for varied eps_i's, or a scalar
% d = delta value for inhibitory weights (default: d = 2*e)
%     -> can be a vector of length n, for varied delta_i's, or a scalar
%
% W = nxn matrix for a threshold-linear network from directed graph
%     -> this creates W for a CTLN or generalized CTLN
% W_EI = (n+1)x(n+1) matrix for the accompanying E-I network
%
%
% modified june 22, 2015
% updated dec 30, 2020 to allow generalized sA matrices for interpolation
% updated apr 23, 2022 to fix bug: A was unassigned, now fixed
% updated aug 10, 2023 to remove A since unnecessary
% updated mar 29, 2025 to allow eps and delta (e,d) to be vectors,
% as in generalized CTLNs (gCTLNs)
% comments updated mar 30, 2025
%
% updated may 4, 2025 to create a second E-I matrix, W_EI, with excitatory
% connections and a single I node for global inhibition
% note: W is an nxn matrix, while W_EI is (n+1)x(n+1)
%
% updated may 8, 2025
% last updated may 19, 2025 to ensure W_EI has 0s on the diagonal
% updated Aug 29, add d+1 on the diagonal of W_EI
%

n = size(sA,1);

if nargin < 2 || isempty(e)
    e = 0.25*ones(1,n);
end

if nargin < 3 || isempty(d)
    d = 0.5*ones(1,n);
end

% if e,d are not long enough, just use first entry of each
% to make them into constant vectors (this is for backwards compatibility)
if length(e)<n
    e = e(1)*ones(1,n);
end

if length(d)<n
    d = d(1)*ones(1,n);
end


%-------------------W(nxn)--------------------
% create matrix W from sA, allow e(j), d(j) to depend on source node j
% note that entries can be t in [0,1] to interpolate between graphs
W = zeros(n);
for i=1:n
    for j=1:n
        t = sA(i,j);
        W(i,j) = t*(-1+e(j)) + (1-t)*(-1-d(j));
    end
    W(i,i) = 0; % make sure diagonal is 0
end


%-------------------W_EI((n+1)x(n+1))--------------------
% create E-I matrix W_EI from sA, the inhibitory node is the (n+1)st
% put eps+delta on excitatory edges j->i, and 0 when there is no edge
exc = e+d;
W_EI = zeros(n+1);
for i=1:n
    for j=1:n
        t = sA(i,j);
        W_EI(i,j) = t*exc(j) + (1-t)*(0); % for clarity, convex combo w/ 0
    end
    W_EI(i,i) = 1+d(i);
end


% now add edges for E->I (W_{Ij} = 1+delta) and I->E (W_{iI} = -1)
W_EI(n+1,n+1) = 0; % I->I, no connection (0 entry)
W_EI(n+1,1:n) = 1+d; % E->I, W_{Ij} terms (+ entries)
W_EI(1:n,n+1) = -1; % I->E, W_{iI} terms (- entries)



end