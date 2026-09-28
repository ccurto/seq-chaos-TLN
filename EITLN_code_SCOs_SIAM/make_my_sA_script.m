% make_my_sA_script
%
% Script for creating a custom adjacency matrix sA for the excitatory
% subnetwork in E-I TLNs.
%
% Here sA(i,j) = 1 means j -> i in the underlying directed graph.
%
% Created by Jie on Apr 7 2026

clear all

% -------------------------------------------------------------------------
% STEP 1. Define an adjacency matrix sA
%
% Enter any n x n adjacency matrix sA for the excitatory subnetwork.
% By convention, if i -> j in the graph, then sA(j,i) = 1.
%
% Example:
% sA = [0 0 1;
%       1 0 0;
%       0 1 0];
% which represents the directed cycle 1 -> 2 -> 3 -> 1.

n = 5;
sA = zeros(n);          % initialize adjacency matrix

% Example graph: directed cycle on 5 nodes
% 1 -> 2 -> 3 -> 4 -> 5 -> 1
for j = 1:n-1
    sA(j+1, j) = 1;
end
sA(1,n) = 1;


% -------------------------------------------------------------------------
% STEP 2. Construct W for the E-I TLN
%
% We first specify the E-I TLN parameters (a,c), and then convert them to
% the matched CTLN parameters (epsilon, delta), since threshlin_ode is
% written in terms of e and d.
a = 0.5;                % excitatory value in the E-I TLN
c = 2.5;                % inhibitory value in the E-I TLN

% Construct W for E-I TLNs
W_EI = graph2_EI_net(sA, a, c);


% -------------------------------------------------------------------------
% STEP 3. Set parameters for the E-I TLN
b = [ones(n,1);0];         % external input: 1 to each E node and 0 to the I node
T = 1400;                   % total simulation time (in units of the excitatory timescale)
tau_I = 1;                 % inhibitory timescale
tau = [ones(n,1);tau_I];   % excitatory timescales are set to 1
X0 = [0.1*rand(n,1);0.1];  % initial condition

% Title for E-I summary
figtitle = sprintf('E-I TLN with $c = %g,\\ a = %g,\\ \\tau_I = %g$', c, a, tau_I);

% -------------------------------------------------------------------------
% STEP 4. Simulate the E-I TLN
soln_EI = threshlin_ode(W_EI, b, T, X0, tau);

% -------------------------------------------------------------------------
% STEP 5.  Check fixed points and plot the E-I TLN dynamics

% Candidate supports used for the fixed-point check.
support = [];  % An empty input means that all nonempty supports are tested.

% Compute all fixed points in y-space.
[FPs, supports] = check_fixed_points_y(W_EI, b, support);


% Available summary plots:
plot_EI_summary(soln_EI, figtitle)
% plot_EI_summary_z_mode(soln_EI, figtitle) % also shows the z-mode and mean mode

% Plot the phase trajectory colored by sign-defined chambers
idx = [1 2 3]; % coordinates used for the 3D phase portrait
figure(11);clf;
figure(12);clf;
plot_phase_by_chamber(soln_EI.X, soln_EI.Y, idx)
