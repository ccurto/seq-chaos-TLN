----------- MATLAB Code for Simulating E-I TLNs -----------

This repository contains MATLAB code for simulating the excitatory-inhibitory threshold-linear network (E-I TLN) model introduced in the paper:

Sequential Chaotic Oscillations (SCOs) in Excitatory-Inhibitory Threshold-Linear Networks (E-I TLNs). 

The code was written by Jie Zang and Carina Curto, and packaged on Sept 25, 2026.


--------------------- Getting Started --------------------

To reproduce the simulation results in the paper "SCOs in E-I TLNs", start with "run_EITLN_example_script.m"
Inside this script, uncomment one example line, such as "run('examples/EITLN_example_5_8cycle_SCOs')" to load the corresponding example from the examples folder. 
To define and simulate your own graph, use "make_my_sA_script.m". 
Both of the scripts will run the following main functions automatically. 

--------------------- Main functions ---------------------

1.W = graph2_EI_net(sA, a, c). 

It constructs the connectivity matrix of the E-I TLN from the adjacency matrix sA of the underlying graph.


2. soln_EI = threshlin_ode(W_EI, b, T, X0, tau)

Simulates the threshold-linear network dynamics using MATLAB's ode45. 


3. plot_EI_summary.m

Plots a summary of the E-I TLN dynamics. Related plotting functions include: plot_grayscale.m, plot_ratecurves.m, plot_chamber_time.m.  
Chamber colors are defined in chamber_color.m. 
To additionally display the mean mode and z-mode, use: plot_EI_summary_z_mode. 

4. plot_phase_by_chamber_auto.m

It computes and plots fixed points and phase portrait in y-coordinates, thus the plotted values may be negative. It call the following functions for plotting fixed points and trajectories.

For fixed points: check_fixedpt_y.m, check_fixed_points.m, and plot_fixed_points.m. 

For phase portraits: plot_phase_by_chamber.m, plot_phase_by_chamber_4E.m

plot_phase_by_chamber.m: plots the x-trajectory and y-trajectory, colored by the R_sigma chamber, for a solution an E-I TLN.

plot_phase_by_chamber_4E.m: developed for the 4-cycle E-I TLN to show the flower-like attractor. 

5. (additional) plot_phase_by_time_period.m: shows the time evolution of a trajectory, with later segments plotted in darker shades. This was not used in the accompanying paper.




