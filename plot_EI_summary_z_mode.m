function plot_EI_summary_z_mode(soln_EI, figtitle)
% PLOT_EI_SUMMARY_Z_MODE - Plot summary of an E-I network solution
% including chamber, z-mode, mean mode, and excitatory activities
%
% soln_EI: struct with fields .X, .Y, .Z, .time
% figtitle: title string (or cell array for multi-line title)

    n = size(soln_EI.X,2)-1;
    colors = lines(n);
    colors = [colors; [1 .7 .7]];    % inhibitory neuron color
    tlim = [soln_EI.time(1) soln_EI.time(end)];
    
    n_fig = 5;
    
    set(groot,'defaultAxesFontSize',12)

    % initial point from the first time point
    X0 = soln_EI.X(1,:);
    X0str = strjoin(arrayfun(@(v) sprintf('%.2f', v), X0, ...
        'UniformOutput', false), ', ');

    % global title
    if nargin >= 2 && ~isempty(figtitle)
        sgtitle({figtitle, sprintf('initial condition $X_0 = (%s)$', X0str)}, ...
            'Interpreter','latex','FontSize',16,'FontWeight','bold');
    else
        sgtitle(sprintf('initial condition $X_0 = (%s)$', X0str), ...
            'Interpreter','latex','FontSize',16,'FontWeight','bold');
    end

    % 1) grayscale plot
    subplot(n_fig,1,1)
    plot_grayscale(soln_EI.X)
    ylabel('neuron idx','FontSize', 12)

    % 2) chambers
    subplot(n_fig,1,2)
    plot_chamber_time(soln_EI.Y(:,1:n), soln_EI.time);
    xlim(tlim)
    ylabel('Chamber','FontSize', 12)
    set(gca,'XTick',[])
    xlabel('')
    title('Chamber identity over time','FontSize',16,'FontWeight','normal');

    % 3) z mode
    subplot(n_fig,1,3)
    plot_ratecurves(soln_EI.Z(:,1:n-1), soln_EI.time)
    xlim(tlim)
    set(gca,'XTick',[])
    xlabel('')
    ylabel('z value','FontSize', 12)
    title('Activity for z-mode','FontSize',16,'FontWeight','normal');

    % 4) mean mode
    subplot(n_fig,1,4)
    plot_ratecurves(sum(soln_EI.X(:,1:n),2), soln_EI.time, [0 0 0])
    hold on
    plot_ratecurves(soln_EI.X(:,n+1), soln_EI.time, colors(n+1,:))
    hold off
    xlim(tlim)
    ylabel('firing rate','FontSize', 12)
    set(gca,'XTick',[])
    xlabel('')
    title('Activity for mean mode','FontSize',16,'FontWeight','normal');

    % 5) excitatory neuron activities
    subplot(n_fig,1,5)
    plot_ratecurves(soln_EI.X(:,1:n), soln_EI.time, colors)
    xlim(tlim)
    xlabel('time','FontSize', 12)
    ylabel('firing rate','FontSize', 12)
    set(gca,'TickLength',[0 0]);
    title('$x_i$ values of excitatory neurons', ...
        'Interpreter','latex','FontSize',16,'FontWeight','normal');

    exportgraphics(gcf,'ei_summary.pdf','ContentType','vector')
end