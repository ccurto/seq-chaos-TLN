% EITLN_example_5_8cycle_SCOs
%
% Example: An E-I TLN with 8 excitatory nodes and 1 inhibitory node,
% where the underlying graph is a directed cycle on 8 nodes:
% 1 -> 2 -> ... -> 8 -> 1.
% The inhibitory node is indexed by n+1.
%
% The parameters are set to a = 0.5 and c = 2.5, for which the network
% exhibits sequential chaotic oscillations (SCOs), with activity
% propagating from neuron j to neuron j+1 around the cycle.(Fig. 5D)
%
%
% Created by Jie on Sep 30 2025
%
% --------------------------------------------------------------
% Adjacency matrix of the directed graph on the excitatory nodes
n = 8;
sA = zeros(n);           % initialize adjacency matrix

% Create edges j -> j+1 to form a directed cycle
for j = 1:n-1
    sA(j+1, j) = 1;
end
sA(1,n) = 1;

% --------------------------------------------------------------
% Simulation parameters
a = 0.5;              % excitatory value in the E-I TLN
c = 2.5;              % inhibitory value in the E-I TLN

e = a-c+1;            % epsilon in the matched CTLN
d = c-1;              % delta in the matched CTLN

% External input: each excitatory node receives input 1,
% while the inhibitory node receives no external input
b = [ones(n,1);0];

% total simulation time (in units of E timescale)
T = 1200;

% inhibitory timescale
tau_I = 1;

% timescale vector: the first n excitatory nodes have timescale 1,
% and the inhibitory node has timescale tau_I
tau = [ones(n,1);tau_I];

% --------------------------------------------------------------
% Initial conditions
X0cell = {};          % initialize a cell array of selected initial conditions

% random initial condition
X0cell{1} = [0.1*rand(n,1);0.1];

% --------------------------------------------------------------
% Visualization options
% Here we assume that the simulated trajectory is sampled at 100 points
% per unit time, so a total simulation time T corresponds to T*100 data points.
range = 1:T*100;      % time indices used for plotting the phase portrait

% initialize a cell array of fixed-point supports to compute/check
supportcell = {};


% check all singleton fixed points
supportcell{1} = [1,n+1;2,n+1;3,n+1;4,n+1;5,n+1;6,n+1;7,n+1;8,n+1];

% check all possible fixed points
supportcell{2} = [];

% Title for E-I summary
figtitle = sprintf('E-I TLN with $c = %g,\\ a = %g,\\ \\tau_I = %g$', c, a, tau_I);