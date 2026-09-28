function plot_phase_by_time_period(Y, yidx)
% PLOT_PHASE_BY_TIME_PERIOD
% -------------------------------------------------------------------------
% Plot a 2D or 3D trajectory with smooth grayscale transition
% (light gray → dark gray) over time.
%
% INPUT
%   Y : T×d matrix
%       - d = 2 : [y1, yI]              → EI 2D (plot y1–yI)
%       - d = 3 : [y1, y2, yI]          → EI 3D (plot y1–y2–yI)
%       - d ≥ 4 : [y1, y2, y3, ...]     → E-only 3D (plot y1–y2–y3)
%   yidx : optional, indices of Y to plot (e.g. [2,3,4])
%           - If not given, follows default rules above
%
% FEATURES
%   - Flexible choice of plotted coordinates via yidx.
%   - ~60 equal time segments with monotone grayscale shading.
%   - Gray level darkens gradually from start to end.
%   - LaTeX-style axis labels, vector-friendly output.
%
% Created by Jie on Oct 22 (revised with yidx on Nov 12)
% -------------------------------------------------------------------------

    figure(3); 
    hold on
    [T, d] = size(Y);

    % ------------------------------------------------------------
    % (1) Determine which coordinates to plot
    % ------------------------------------------------------------
    if nargin < 2 || isempty(yidx)
        if d == 2
            yidx = [1, 2];
        elseif d == 3
            yidx = [1, 2, 3];
        else
            yidx = [1, 2, 3];  % default: first 3 excitatory coords
        end
    end

    P = Y(:, yidx);
    ndim = numel(yidx);

    % ------------------------------------------------------------
    % (2) Axis labels
    % ------------------------------------------------------------
    y_str = cell(1, numel(yidx));
    for k = 1:numel(yidx)
        if yidx(k) == d
            y_str{k} = '$y_I$';
        else
            y_str{k} = ['$y_' int2str(yidx(k)) '$'];
        end
    end

    % ------------------------------------------------------------
    % (3) Divide trajectory into equal-length time segments
    % ------------------------------------------------------------
    k = 300;                                  % number of segments
    edges = round(linspace(1, T, k+1));      % segment boundaries
    gvals = linspace(0.75, 0.15, k);         % grayscale (light → dark)
    lw = 1.5;                                % line width

    % ------------------------------------------------------------
    % (4) Plot each segment with its grayscale tone
    % ------------------------------------------------------------
    for i = 1:k
        seg = edges(i):edges(i+1);
        if seg(end) > T, seg(end) = T; end
        g = gvals(i);
        col = [g g g];  % RGB for grayscale

        if ndim == 2
            plot(P(seg,1), P(seg,2), 'LineWidth', lw, 'Color', col);
        elseif ndim >= 3
            plot3(P(seg,1), P(seg,2), P(seg,3), 'LineWidth', lw, 'Color', col);
        end
    end

    % ------------------------------------------------------------
    % (5) Axes and formatting
    % ------------------------------------------------------------
    grid on
    set(gca, 'FontSize', 25, 'TickLabelInterpreter', 'latex');
    xlabel(y_str{1}, 'Interpreter', 'latex', 'FontSize', 30);
    ylabel(y_str{2}, 'Interpreter', 'latex', 'FontSize', 30);
    if ndim >= 3
        zlabel(y_str{3}, 'Interpreter', 'latex', 'FontSize', 30);
        view(254,12);
    end
    
    % set(gca, 'XColor', 'none')
    % set(gca, 'YColor', 'none')
    % set(gca, 'ZColor', 'none')
    % grid off;

    % set(gcf,'Renderer','painters'); 
    % print(gcf, 'figure.pdf', '-dpdf', '-painters');  % for Illustrator
end
