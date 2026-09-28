# seq-chaos-TLN
TLN package for sequential chaotic attractors

This repository contains MATLAB code for simulating the excitatory-inhibitory threshold-linear networks (E-I TLNs) 
in the model introduced in the following paper on sequential chaotic attractors (SCOs):

Sequential chaotic oscillations in excitatory-inhibitory threshold-linear networks, by Jie Zang and Carina Curto.
The arxiv version is available at: https://arxiv.org/abs/2606.00373

The code was written by Jie Zang and Carina Curto, and packaged on Sept 25, 2026. The structure of this code
is modeled on the related package CTLN Basic 2.0 (https://github.com/ccurto/CTLN-Basic-2.0/)

GETTING STARTED

To reproduce the simulation results in the paper above, begin with the script:

run_EITLN_example_script.m

Inside this script, uncomment one example line, such as 
"run('examples/EITLN_example_5_8cycle_SCOs')" 
to load the corresponding example from the examples folder. 

To define and simulate your own graph, use the alternative script:

make_my_sA_script.m

MAIN FUNCTIONS

Both scripts will use the following functions:

1. W = graph2_EI_net(sA, a, c). 

This function constructs the connectivity matrix W of an E-I TLN from the adjacency matrix sA of the underlying graph.

2. soln_EI = threshlin_ode(W_EI, b, T, X0, tau)

This function simulates the threshold-linear network dynamics using MATLAB's ode45. 

3. plot_EI_summary.m

Plots a summary of the E-I TLN dynamics. 
Related plotting functions include: plot_grayscale.m, plot_ratecurves.m, plot_chamber_time.m.  
Chamber colors are defined in chamber_color.m. 

To additionally display the mean mode and z-mode, use: plot_EI_summary_z_mode. 

4. plot_phase_by_chamber_auto.m

This function computes and plots fixed points and phase portrait in y-coordinates, thus the plotted values may be negative. 
It calls the following functions for plotting fixed points and trajectories.

For fixed points: 
check_fixedpt_y.m, check_fixed_points.m, and plot_fixed_points.m. 

For trajectories:
plot_phase_by_chamber.m: plots the x-trajectory and y-trajectory, colored by the R_sigma chamber, for an E-I TLN solution.
plot_phase_by_chamber_4E.m: developed for the 4-cycle E-I TLN to show the flower-like attractor. 

5. (additional) plot_phase_by_time_period.m shows the time evolution of a trajectory, with later segments plotted in darker shades.
This was not used in the accompanying paper.
