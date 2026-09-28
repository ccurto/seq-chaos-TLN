function plot_phase_by_chamber_auto(soln_EI, range, W, b, sigma)
% PLOT_PHASE_BY_CHAMBER_AUTO
% Automatically chooses an appropriate phase-portrait plotting function
% based on the dimension and structure of the E-I TLN.
%
% Inputs:
%   soln_EI : solution structure returned by threshlin_ode for the E-I TLN
%   range   : time indices used to select the plotted part of the trajectory
%   W       : connectivity matrix of the E-I TLN
%   b       : external input vector
%   sigma   : (optional) candidate supports to test for fixed points
%             - []             : test all nonempty subsets of {1,...,n}
%             - vector         : treated as a single support
%             - numeric matrix : each row is treated as one support
%             - cell array     : each cell is treated as one support vector
%
% This function first computes fixed points for the specified candidate
% supports, then plots the corresponding phase portrait in y-coordinates.
% Since the phase portrait is shown in y-coordinates, the plotted values
% may be negative.
%
% Created by Jie on Oct 22 2025

    % Extract the relevant part of the time series
    Xsub = soln_EI.X(range, :);
    Ysub = soln_EI.Y(range, :);
    N = size(Ysub,2); % total number of nodes(include I node)

    [FPs, ~] = check_fixed_points_y(W, b, sigma);
    
    figure(12); 
    hold on; 
    ms = 50; % marker size
    if N == 2 % singleton E-I TLN
        scatter(FPs(1,:), FPs(2,:), ms, 'filled', 'MarkerFaceColor','k');
        plot_phase_by_chamber(Xsub,Ysub);
    elseif N == 3 || N == 4 
        scatter3(FPs(1,:), FPs(2,:), FPs(3,:), ms, 'filled', 'MarkerFaceColor','k');
        plot_phase_by_chamber(Xsub,Ysub);
    elseif N == 5 && W(2,1) == W(1,4) % set for the flower-like attractor in E-I TLN on 4-cycle
        % use y2-y1, y3-y2, y4-y3 as the coordinates.
        scatter3(FPs(2,:)-FPs(1,:), FPs(3,:)-FPs(2,:), FPs(4,:)-FPs(3,:), ms, 'filled','MarkerFaceColor','k');
        zidx1 = [1,3,4];
        plot_phase_by_chamber_4E(Ysub, zidx1, 12);
    else
        % General higher-dimensional case:
        % choose three representative y-coordinates for visualization
        yidx = [1,2,3]; 
        scatter3(FPs(yidx(1),:), FPs(yidx(2),:), FPs(yidx(3),:), ms, 'filled','MarkerFaceColor','k');
        plot_phase_by_chamber(Xsub,Ysub,yidx);
        
    end

    % Plot the time evolution of the trajectory, with later segments darker
    % figure(3);     
    % clf; 
    % plot_phase_by_time_period(Ysub);
end


