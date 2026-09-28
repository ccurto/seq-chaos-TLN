% EITLN_example_2_singleton_unstable_fp
%
% Example: An E-I TLN with 1 excitatory node and 1 inhibitory node,
% where the underlying graph consists of a single excitatory node.
% The inhibitory node is indexed by n+1 (2 here).
%
% The unique fixed point is stable when c < 1 + 1/tau_I and unstable
% when c > 1 + 1/tau_I. 
% Here we choose c = 2.1, tau_I = 1 to illustrate
% the unstable case. (Fig. 3C)
%
% This script is used for Figure 3C in the E-I TLN paper.
%
% Created by Jie on Oct 20 2025
%
%
%
% --------------------------------------------------------------
% Adjacency matrix of the directed graph on the excitatory nodes
n = 1;
sA = zeros(1);           % initialize adjacency matrix

% --------------------------------------------------------------
% Simulation parameters
a = 0.5;              % excitatory value in the E-I TLN
c = 2.1;              % inhibitory value, giving the unstable case c > 1 + 1/tau_I
% c = 1.8;            % inhibitory value, giving the stable case c < 1 + 1/tau_I

e = a-c+1;            % epsilon in the matched CTLN
d = c-1;              % delta in the matched CTLN

% External input: the excitatory node receives input 1,
% while the inhibitory node receives no external input
b = [1;0];

% total simulation time (in units of E timescale)
T = 100;

% inhibitory timescale
tau_I = 1;

% timescale vector: the excitatory node has timescale 1,
% and the inhibitory node has timescale tau_I
tau = [1;tau_I];

% --------------------------------------------------------------
% Initial conditions
X0cell = {};          % initialize a cell array of selected initial conditions

% small initial activity for the excitatory node,
% and a small positive initial value for the inhibitory node
X0cell{1} = [0.1*rand(1,1);0.1];

% --------------------------------------------------------------
% Visualization options
% Here we assume that the simulated trajectory is sampled at 100 points
% per unit time, so a total simulation time T corresponds to T*100 data points.
range = 1:T*100;      % time indices used for plotting the phase portrait

% initialize a cell array of fixed-point supports to compute/check
supportcell = {};

% check all possible fixed points
supportcell{1} = [];


% Title for E-I summary
figtitle = sprintf('E-I TLN with $c = %g,\\ a = %g,\\ \\tau_I = %g$', c, a, tau_I);