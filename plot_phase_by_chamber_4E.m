function plot_phase_by_chamber_4E(Y,zidx,fig)
% PLOT_PHASE_BY_CHAMBER_4E (difference view)
% -------------------------------------------------------------------------
% Standalone chamber-colored plotter for 5D (E-only) systems.
%
% - Chamber colors come from chamber_color(4) based on signs of y1..y4.
% - Plots the *difference coordinates*: (y2−y1, y3−y2, y4−y3).
% - Includes a concise LaTeX legend showing only chambers that appear.
% - 1-point temporal dilation removes gaps at sign transitions.
%
% INPUT
%   Y : T×5 matrix
%       Columns: [y1, y2, y3, y4, yL]
%
% Created by Jie on Oct 22, 2025
% updated in Carina's office on Nov 3, 2025
% -------------------------------------------------------------------------
% 

if nargin < 2 || isempty(zidx)
    zidx = [1,2,3];
end

if nargin < 3 || isempty(fig)
    fig = 12;
end

% define z variables
z(:,1) = Y(:,2)-Y(:,1);
z(:,2) = Y(:,3)-Y(:,2);
z(:,3) = Y(:,4)-Y(:,3);
z(:,4) = Y(:,1)-Y(:,4);

% ---- y-difference labels corresponding to z ----
y_diff_labels = { ...
    '$y_2 - y_1$', ... % z1
    '$y_3 - y_2$', ... % z2
    '$y_4 - y_3$', ... % z3
    '$y_1 - y_4$'  ... % z4
};

% define z_i strings for axis labels
z1_str = y_diff_labels{zidx(1)};
z2_str = y_diff_labels{zidx(2)};
z3_str = y_diff_labels{zidx(3)};

    [T, d] = size(Y);
    if d ~= 5
        error('plot_phase_by_chamber_d5 expects Y to be T×5.');
    end

    figure(fig); hold on
    set(gcf,'Renderer','opengl');
    set(gca,'SortMethod','depth','FontSize',18,'TickLabelInterpreter','latex');
    grid on
    xlabel(z1_str,'FontSize',24,'Interpreter','latex');
    ylabel(z2_str,'FontSize',24,'Interpreter','latex');
    zlabel(z3_str,'FontSize',24,'Interpreter','latex');
    view(45,30);

    % ---- Excitatory subset (first 4) determines chamber ----
    E = Y(:,1:4);
    % Plot using difference coordinates
    P = [z(:,zidx(1)), z(:,zidx(2)), z(:,zidx(3))];
    tol = 1e-20;

    % ---- Chamber keys and colors ----
    keys = { ...
        'R1234','R123','R124','R12','R134','R13','R14','R1', ...
        'R234','R23','R24','R2','R34','R3','R4','R_empty'};
    cmap = chamber_color(4);
    col  = cellfun(@(k) cmap.(k), keys, 'uni', false);

    % ---- Sign logic for y1..y4 ----
    e1 = E(:,1) > tol;
    e2 = E(:,2) > tol;
    e3 = E(:,3) > tol;
    e4 = E(:,4) > tol;
    chamber_idx = 1 + 8*~e1 + 4*~e2 + 2*~e3 + 1*~e4;  % 1..16

    % ---- Plot each chamber ----
    lw = 2;
    dilate = [1 1 1];
    h_used = gobjects(1,numel(keys));
    used   = false(1,numel(keys));

    for k = 1:numel(keys)
        mask = (chamber_idx == k);
        mask = conv(double(mask), dilate, 'same') > 0;  % 1-pt dilation
        if any(mask)
            PP = P; PP(~mask,:) = NaN;
            h_used(k) = plot3(PP(:,1), PP(:,2), PP(:,3), ...
                              'LineWidth', lw, 'Color', col{k});
            used(k) = true;
        end
    end

    % ---- Render R_empty behind others ----
    idxE = find(strcmp(keys,'R_empty'),1);
    if ~isempty(idxE) && used(idxE) && ishandle(h_used(idxE))
        uistack(h_used(idxE),'bottom');
    end

    % ---- Build concise legend ----
    maskShow = used & arrayfun(@ishandle,h_used);
    h_show   = h_used(maskShow);
    key_show = keys(maskShow);
    leg_labels = cell(size(key_show));
    for i = 1:numel(key_show)
        if strcmp(key_show{i},'R_empty')
            leg_labels{i} = '$R^y_{\emptyset}$';
        else
            leg_labels{i} = ['$R^y_{', key_show{i}(2:end), '}$'];
        end
    end

    legend(h_show, leg_labels, 'Interpreter','latex', ...
           'FontSize',22, 'Location','bestoutside');
end
