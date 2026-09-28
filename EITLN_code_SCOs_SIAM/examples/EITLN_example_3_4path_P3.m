% EITLN_example_3_4path_P3
%
% Example: An E-I TLN with 4 excitatory nodes and 1 inhibitory node,
% where the underlying graph is a directed path on 4 nodes:
% 1 -> 2 -> 3 -> 4.
% The inhibitory node is indexed by n+1.
%
% This script is used for Figure 4C (P3) in the E-I TLN paper to
% illustrate sequential chaotic oscillations for the E-I TLN on 4-path (Fig. 4C)
%
% Created by Jie on Oct 20
%
% --------------------------------------------------------------
% Adjacency matrix of the directed graph on the excitatory nodes
n = 4;
sA = zeros(n);           % initialize adjacency matrix
% Create edges j -> j+1 to form a directed path
for j = 1:n-1
    sA(j+1, j) = 1;
end

% --------------------------------------------------------------
% Simulation parameters
a = 0.5;              % excitatory value in the E-I TLN
c = 2.5;            % inhibitory value for P3

e = a-c+1;            % epsilon in the matched CTLN
d = c-1;              % delta in the matched CTLN

% inhibitory timescale
tau_I = 1;

% timescale vector: the first n excitatory nodes have timescale 1,
% and the inhibitory node has timescale tau_I
tau = [ones(n,1);tau_I];

% External input: each excitatory node receives input 1,
% while the inhibitory node receives no external input
b = [ones(n,1);0];

% total simulation time (in units of E timescale)
T = 120;

% --------------------------------------------------------------
% Initial conditions
X0cell = {};          % initialize a cell array of selected initial conditions

% initial condition for the attractor around the singleton fixed point {1,I}
X0cell{1} = [0.4;0.1;0.1;0.1;1];

% random initial condition
X0cell{2} = [0.1*rand(n,1);0.1];

% --------------------------------------------------------------
% Visualization options
% Here we assume that the simulated trajectory is sampled at 100 points
% per unit time, so a total simulation time T corresponds to T*100 data points.
range = 1:T*100;      % time indices used for plotting the phase portrait

% initialize a cell array of fixed-point supports to compute/check
supportcell = {};

% check the singleton fixed point supported on {i,I} i = 1,2,3,4
supportcell{1} = [1,n+1;2,n+1;3,n+1;4,n+1];

% check all possible fixed points
supportcell{2} = [];

% Title for E-I summary
figtitle = sprintf('E-I TLN with $c = %g,\\ a = %g,\\ \\tau_I = %g$', c, a, tau_I);