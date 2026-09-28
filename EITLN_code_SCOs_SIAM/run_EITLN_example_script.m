% run_EITLN_example_script
%
% Master script for running example simulations of excitatory-inhibitory
% threshold-linear networks (E-I TLNs).
% The fixed points and phase portraits shown in this script are expressed
% in y-coordinates, so their values may be negative.
%
%
% Created by Jie on Apr 7 2026

clear all

% -------------------------------------------------------------------------
% STEP 1. Choose which example to run
%
% Uncomment exactly ONE of the following examples to load a network configuration. 
% Each example script defines:
%   - sA                 : adjacency matrix of the excitatory subnetwork
%   - a, c               : excitatory and inhibitory parameters
%   - tau                : timescale vector
%   - b                  : external input vector
%                          The input to each excitatory node is b_i = theta, set to 1 here.
%                          The inhibitory node receives no external input.
%   - T                  : total simulation time
%   - X0cell             : selected initial conditions
%   - range              : time indices used for plotting the phase portrait
%   - supportcell        : candidate support sets for fixed-point analysis
%
%
% Example 1: E-I TLN on an 8-path to show sequential chaotic oscillations (SCOs) （Fig.1C and Fig.4D）
% run('examples/EITLN_example_1_8path_SCOs')

% Example 2: Singleton E-I TLN to show stable/unstable fixed-point cases (Fig. 3C)
% run('examples/EITLN_example_2_singleton_unstable_fp')   % c = 2.1
% run('examples/EITLN_example_2_singleton_stable_fp')     % c = 1.8

% Example 3: E-I TLN on a 4-path to show chaotic attractors at P2 and SCOs at P3 (Fig. 4C)
% run('examples/EITLN_example_3_4path_P2')                % c = 2.1, a = 0.5
% run('examples/EITLN_example_3_4path_P3')                % c = 2.5, a = 0.5

% Example 4: E-I TLN on a 3-cycle to show chaotic attractors at P2 and SCOs at P3 (Fig. 5C)
% run('examples/EITLN_example_4_3cycle_P2')               % c = 2.1, a = 0.5
run('examples/EITLN_example_4_3cycle_P3')               % c = 2.5, a = 0.5

% Example 5: E-I TLN on an 8-cycle to show sequential chaotic oscillations (Fig. 5D)
% run('examples/EITLN_example_5_8cycle_SCOs')

% Example 6: E-I TLN on a 3-cycle to show attractors near the full-support fixed point (Fig. 6B)
% run('examples/EITLN_example_6_3cycle_P4')               % a = 0.5, c = 0.5
% run('examples/EITLN_example_6_3cycle_P5')               % a = 2,   c = 0.8
% run('examples/EITLN_example_6_3cycle_P6')               % a = 0.5, c = 1.3
% run('examples/EITLN_example_6_3cycle_P7')               % a = 2,   c = 2.5

% Example 7: E-I TLN on a 4-cycle to show the flower-like attractor near the full-support fixed point (Fig. 6C)
% run('examples/EITLN_example_7_4cycle_P8')               % a = 2, c = 2.5, tau_I = 0.7

% Example 8: E-I TLN on an 8-path in the moderate and weak inhibition regimes (Supplementary Fig. 10)
% run('examples/EITLN_example_8_8path_P4')                % a = 1,   c = 1.5
% run('examples/EITLN_example_8_8path_P5')                % a = 2,   c = 2.2
% run('examples/EITLN_example_8_8path_P6')                % a = 0.5, c = 0.5
% run('examples/EITLN_example_8_8path_P7')                % a = 3,   c = 0.8


% -------------------------------------------------------------------------
% Notes on the examples
%
% Example 1:
%   X0 = X0cell{1} for the left figure of Fig. 1C  (X_1(0) = 1)
%   X0 = X0cell{2} for the right figure of Fig. 1C (X_1(0) = 1.01)
%   X0 = X0cell{3} for Fig. 4D, where X_1(0) = 1 and the other nodes are initialized randomly.
%
% Example 3:
%   At P2, changing X0 from X0cell{1} to X0cell{4} yields different attractors.
%   around singleton fixed points.
%   At P3, use X0 = X0cell{1} to observe SCOs.
%
% Example 4:
%   At P2, changing X0 from X0cell{1} to X0cell{4} yields different attractors
%   At P3, use X0 = X0cell{1} to observe SCOs.


% -------------------------------------------------------------------------
% STEP 2. Select an initial condition and a support set
%
% Each example script defines:
%   - X0cell      : a cell array of selected initial conditions
%   - supportcell : a cell array of candidate support sets
%
% By default, we use X0cell{1} and supportcell{1}.
% You can change the indices below to try other choices, such as X0 = X0cell{2}; 

X0 = X0cell{1}; 
support = supportcell{1};


% -------------------------------------------------------------------------
% STEP 3. Simulate E-I TLN dynamics
%
% Both the CTLN and the E-I TLN are built from the same excitatory graph sA.
% We first construct the connectivity matrices, and then integrate the
% E-I TLN dynamics using threshlin_ode.


W = graph2_EI_net(sA, a, c);          % W for the E-I TLN
soln_EI = threshlin_ode(W, b, T, X0, tau);
% 

% -------------------------------------------------------------------------
% STEP 4. Plot results
%
% Available summary plots:
figure(1);
clf;
plot_EI_summary(soln_EI, figtitle)
% plot_EI_summary_z_mode(soln_EI, figtitle);  % to show the z-mode and mean mode.

% Plot the fixed points and phase trajectory which is colored by sign-defined chambers
figure(11);
clf; % comment this out if you want to display multiple attractors
figure(12);
clf; % comment this out if you want to display multiple attractors
plot_phase_by_chamber_auto(soln_EI, range, W, b, support)


