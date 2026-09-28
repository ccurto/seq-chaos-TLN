function W_EI = graph2_EI_net(sA, a, c)
%GRAPH2_EI_NET Construct an E-I TLN weight matrix from a directed graph.
%
%   W_EI = graph2_EI_net(sA, a, c)
%
% Inputs
%   sA : n x n binary adjacency matrix for a directed graph
%        Convention: sA(i,j) = 1 means j -> i.
%   a  : excitatory weights between E nodes
%   c  : inhibitory strength
%
% Output
%   W_EI : (n+1) x (n+1) E-I TLN weight matrix
%          The first n nodes are excitatory, and node n+1 is the global
%          inhibitory node.
%
% Construction from sA
%   Excitatory-excitatory connections are decided by the graph
%       W_EI(i,j) = a    if sA(i,j) = 1 and i ~= j
%       W_EI(i,j) = 0    if sA(i,j) = 0 and i ~= j
%
% Prescribed weights
%   For self-excitation of excitatory neurons:
%       W_EI(i,i) = c
%
%   For the inhibitory node:
%       W_EI(i,n+1) = -1   for i = 1,...,n   (I -> E)
%       W_EI(n+1,j) = c    for j = 1,...,n   (E -> I)
%       W_EI(n+1,n+1) = 0                    (I -> I)
%
% Created by Jie on April 22 2026

    n = size(sA, 1);

    if size(sA, 2) ~= n
        error('sA must be a square matrix.');
    end

    if nargin < 2 || isempty(a)
        error('Parameter a must be provided.');
    end

    if nargin < 3 || isempty(c)
        error('Parameter c must be provided.');
    end

    W_EI = zeros(n+1, n+1);

    % E -> E block determined by sA
    for i = 1:n
        for j = 1:n
            if i ~= j && sA(i,j) ~= 0
                W_EI(i,j) = a;
            end
        end
        W_EI(i,i) = c;
    end

    % Prescribed couplings involving the inhibitory node
    W_EI(1:n, n+1) = -1; % I -> E
    W_EI(n+1, 1:n) = c;  % E -> I
    W_EI(n+1, n+1) = 0;  % I -> I
end