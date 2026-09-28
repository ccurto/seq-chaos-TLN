% EITLN_example_8_8path_P5
%
% Example: An E-I TLN with 8 excitatory nodes and 1 inhibitory node,
% where the underlying graph is a directed path on 8 nodes.
% The inhibitory node is indexed by n+1.
%
% This script illustrates the dynamical states P4-P7 for the E-I TLN
% on an 8-path, in the moderate and weak inhibition regimes.(Supplementary Fig. 10)
%
% Created by Jie on Sep 30
%
% --------------------------------------------------------------
% Adjacency matrix of the directed graph on the excitatory nodes
n = 8;
sA = zeros(n);           % initialize adjacency matrix

% Create edges j -> j+1 to form a directed path
for j = 1:n-1
    sA(j+1, j) = 1;
end

% --------------------------------------------------------------
% Simulation parameters
% excitatory connection strength: a
% inhibitory connection strength: c
% a = 1;   c = 1.5;     % P4
a = 2;   c = 2.2;       % P5
% a = 0.5; c = 0.5;     % P6
% a = 3;   c = 0.8;     % P7

e = a-c+1;              % epsilon in the matched CTLN
d = c-1;                % delta in the matched CTLN

% External input: each excitatory node receives input 1,
% while the inhibitory node receives no external input
b = [ones(n,1);0];

% total simulation time (in units of E timescale)
T = 200;

% inhibitory timescale
tau_I = 1;

% timescale vector: the first n excitatory nodes have timescale 1,
% and the inhibitory node has timescale tau_I
tau = [ones(n,1);tau_I];

% --------------------------------------------------------------
% Initial conditions
X0cell = {};            % initialize a cell array of selected initial conditions

% neuron 1 starts active, while the remaining nodes are initialized randomly
X0cell{1} = [1;0.1*rand(n,1)];

% random initial condition
X0cell{2} = [0.1*rand(n,1);0.1];

% --------------------------------------------------------------
% Visualization options
% Here we assume that the simulated trajectory is sampled at 100 points
% per unit time, so a total simulation time T corresponds to T*100 data points.
range = 1:T*100;        % time indices used for plotting the phase portrait

% initialize a cell array of fixed-point supports to compute/check
supportcell = {};

% check the fixed point supported on the nth excitatory node
% together with the inhibitory node
supportcell{1} = [n,n+1];

% check all possible fixed points
supportcell{2} = [];

% Title for E-I summary
figtitle = sprintf('E-I TLN with $c = %g,\\ a = %g,\\ \\tau_I = %g$', c, a, tau_I);