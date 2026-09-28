function plot_phase_by_chamber(X, Y, idx)
% PLOT_PHASE_BY_CHAMBER
% Chamber-colored phase trajectories for E-I TLNs.
%
% X   : T x n matrix in x-coordinates
% Y   : T x n matrix in y-coordinates, with Y = y(x)
% idx : two or three coordinates used for plotting, default [1 2 n]
%
% E-I convention:
%   Columns 1,...,n-1 are excitatory coordinates.
%   Column n is the inhibitory coordinate.
%
% Chambers are determined only by excitatory signs:
%   R_sigma = { y_i(x) > 0 for i in sigma, i = 1,...,n-1 }
%
% In x-space, chambers are labeled R^x_sigma.
% In y-space, chambers are labeled R^y_sigma.
%
% Created by Jie on Oct 22, 2025.
% Updated by Jie on July 2, 2026 for arbitrary dimension.
% -------------------------------------------------------------------------
    
    [T1, nX] = size(X);
    [T2, nY] = size(Y);
    
    if T1 ~= T2
        error('X and Y must have the same number of time points.');
    end
    
    if nX ~= nY
        error('X and Y must have the same number of coordinates.');
    end
    
    n  = nY;
    ne = n - 1;
    
    % Automatically choose 2D or 3D plotting
    % 2D system: plot coordinates 1 and 2
    % Higher-dimensional system: plot x_1, x_2, and x_I
    if nargin < 3 || isempty(idx)
        if n == 2
            idx = [1 2];
        else
            idx = [1 2 3];
        end
    end

    if numel(idx) ~= 2 && numel(idx) ~= 3
        error('idx must contain either 2 or 3 coordinates.');
    end

    if any(idx < 1) || any(idx > n)
        error('Entries of idx must be between 1 and n.');
    end

    if numel(unique(idx)) ~= numel(idx)
        error('Entries of idx must be distinct.');
    end

    tol = 1e-20;
    lw  = 1.8;
    dil = [1 1 1];

    cmap = chamber_color(ne);

    % Chamber assignment is determined only by excitatory y-coordinates
    S = Y(:,1:ne) > tol;

    wts = 2 .^ (0:ne-1);
    patt = S * wts.';
    [uniq, ~, grp] = unique(patt, 'stable');

    plot_one_space(X, idx, uniq, grp, n, ne, cmap, dil, lw, ...
        'x', 'Trajectory in $x$-space', 11);

    plot_one_space(Y, idx, uniq, grp, n, ne, cmap, dil, lw, ...
        'y', 'Trajectory in $y$-space', 12);
end


function plot_one_space(Z, idx, uniq, grp, n, ne, cmap, dil, lw, ...
    coord_symbol, fig_title, fig_num)

    figure(fig_num); 
    % clf; 
    hold on; grid on;
    set(gcf,'Renderer','opengl');
    set(gca,'SortMethod','depth','FontSize',25,'TickLabelInterpreter','latex');

    P = Z(:, idx);

    h_empty = gobjects(1);
    h_used = gobjects(numel(uniq),1);
    labels = cell(numel(uniq),1);
    used_count = 0;

    for u = 1:numel(uniq)

        bits = bitget(uint64(uniq(u)), 1:ne) > 0;
        idxs = find(bits);

        mask = (grp == u);

        % Dilate mask slightly so colored segments connect better
        mask = conv(double(mask), dil, 'same') > 0;

        if any(mask)
            PP = P;
            PP(~mask,:) = NaN;

            c = pick_color_EI(idxs, cmap);

            if numel(idx) == 2
                hline = plot(PP(:,1), PP(:,2), ...
                    'LineWidth', lw, 'Color', c);
            else
                hline = plot3(PP(:,1), PP(:,2), PP(:,3), ...
                    'LineWidth', lw, 'Color', c);
            end

            used_count = used_count + 1;
            h_used(used_count) = hline;

            if isempty(idxs)
                labels{used_count} = ...
                    ['$R^', coord_symbol, '_{\emptyset}$'];
                h_empty = hline;
            else
                labels{used_count} = ...
                    ['$R^', coord_symbol, '_{', ...
                    strjoin(arrayfun(@num2str, idxs, ...
                    'UniformOutput', false), ''), '}$'];
            end
        end
    end

    h_used = h_used(1:used_count);
    labels = labels(1:used_count);

    if isgraphics(h_empty)
        uistack(h_empty, 'bottom');
    end

    xlabel(make_axis_label(coord_symbol, idx(1), n), ...
        'Interpreter','latex','FontSize',36);
    ylabel(make_axis_label(coord_symbol, idx(2), n), ...
        'Interpreter','latex','FontSize',36);

    if numel(idx) == 3
        zlabel(make_axis_label(coord_symbol, idx(3), n), ...
            'Interpreter','latex','FontSize',36);
        view(307.5369,38.6732);
    end

    title(fig_title, 'Interpreter','latex','FontSize',30);

    legend(h_used, labels, 'Interpreter','latex', ...
        'FontSize',26, 'Location','bestoutside');
end


function c = pick_color_EI(idxs, cmap)

    if isempty(idxs)
        c = cmap.R_empty;
        return;
    end

    key = ['R' strjoin(arrayfun(@num2str, idxs, ...
        'UniformOutput', false), '')];

    if isfield(cmap, key)
        c = cmap.(key);
    else
        cols = cellfun(@(i) cmap.(sprintf('R%d', i)), ...
            num2cell(idxs), 'UniformOutput', false);
        c = mean(cat(1, cols{:}), 1);
    end
end


function label = make_axis_label(coord_symbol, idx, n)

    if idx == n
        label = ['$', coord_symbol, '_{\mathrm{I}}$'];
    else
        label = ['$', coord_symbol, '_', int2str(idx), '$'];
    end

end