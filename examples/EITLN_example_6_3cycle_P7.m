% EITLN_example_6_3cycle_P7
%
% Example: An E-I TLN with 3 excitatory nodes and 1 inhibitory node,
% where the underlying graph is a directed cycle on 3 nodes:
% 1 -> 2 -> 3 -> 1.
% The inhibitory node is indexed by n+1(4).
%
% This script is used to illustrate the dynamical behavior near the
% full-support fixed point for the E-I TLN on a 3-cycle, in the parameter
% regime where both the mean mode and the z-mode are unstable.(Fig. 6B)
%
% Created by Jie on Jan 07 2026
%
% --------------------------------------------------------------
% Adjacency matrix of the directed graph on the excitatory nodes
n = 3;
sA = zeros(n);           % initialize adjacency matrix

% Create edges j -> j+1 to form a directed cycle
for j = 1:n-1
    sA(j+1, j) = 1;
end
sA(1,n) = 1;

% --------------------------------------------------------------
% Simulation parameters
tau_I = 1;              % inhibitory timescale

% excitatory connection strength: a
% inhibitory connection strength: c
% a = 0.5;   c = 0.5;    % P4
% a = 2;     c = 0.8;    % P5
% a = 0.5;   c = 1.3;    % P6
a = 2;     c = 2.5;    % P7

e = a-c+1;              % epsilon in the matched CTLN
d = c-1;                % delta in the matched CTLN

% External input: each excitatory node receives input 1,
% while the inhibitory node receives no external input
b = [ones(n,1);0];

% total simulation time (in units of E timescale)
T = 60;

% timescale vector: the first n excitatory nodes have timescale 1,
% and the inhibitory node has timescale tau_I
tau = [ones(n,1);tau_I];

% --------------------------------------------------------------
% Initial conditions
X0cell = {};            % initialize a cell array of selected initial conditions

% random initial condition
X0cell{1} = [0.1*rand(n,1);0.1];

% --------------------------------------------------------------
% Visualization options
% Here we assume that the simulated trajectory is sampled at 100 points
% per unit time. We start plotting from index 20000 in order to skip
% the initial transient dynamics.
range = 1:T*100;    % time indices used for plotting the phase portrait

% initialize a cell array of fixed-point supports to compute/check
supportcell = {};

% check the full-support fixed point
supportcell{1} = [1,2,3,n+1];

% check all possible fixed points
supportcell{2} = [];

% Title for E-I summary
figtitle = sprintf('E-I TLN with $c = %g,\\ a = %g,\\ \\tau_I = %g$', c, a, tau_I);