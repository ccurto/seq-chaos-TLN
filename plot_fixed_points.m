function FPs = plot_fixed_points(W, b, sigma)
% PLOT_FIXED_POINTS  
% -------------------------------------------------------------------------
% Find and plot all fixed points of a threshold-linear network (TLN) for a
% given weight matrix W. The function automatically determines which axes
% to use depending on network size.
%
% AXIS RULE:
%   n = 2 → [y1, yI]
%   n = 3 → [y1, y2, yI]
%   n ≥ 4 → [y1, y2, y3]
%
% INPUTS
%   W      : n×n connectivity matrix.
%   b      : n×1 bias vector (optional; default = ones(n,1)).
%   sigma  : (optional) candidate supports to test.
%             - []          → test all nonempty subsets of {1,…,n}.
%             - vector      → treated as a single support.
%             - numeric matrix (rows) → each row is a support.
%             - cell array   → each cell is a vector of node indices.
%
% OUTPUT
%   FPs : n×m matrix, each column is a fixed point y of the TLN.
%
% DEPENDENCY
%   Requires function: [TF, y] = check_fixedpt_y(W, sig, b)
%     - TF = logical flag indicating whether support 'sig' yields a valid FP
%     - y  = corresponding fixed point vector (n×1)
%
% NOTES
%   For large n, the total number of subsets (2^n - 1) grows exponentially,
%   so enumerating all possible supports can be computationally expensive.
%
% Created by Jie, Oct 2025
% -------------------------------------------------------------------------

    % ===== Basic checks =====
    n = size(W,1);
    if n < 2
        error('This plotter expects n ≥ 2.');
    end
    if nargin < 2 || isempty(b)
        b = ones(n,1);
    end
    if size(b,1) ~= n || size(b,2) ~= 1
        error('b must be an n×1 column vector.');
    end
    if nargin < 3
        sigma = [];
    end

    % ===== Construct candidate supports =====
    if isempty(sigma)
        % Enumerate all nonempty subsets of {1,…,n}
        % (⚠ combinatorial explosion when n is large)
        cand = arrayfun(@(m) find(bitget(m,1:n)), 1:(2^n-1), 'UniformOutput', false);

    elseif iscell(sigma)
        % Input is already a cell array of index sets
        cand = cellfun(@(v) unique(v(:)'), sigma, 'UniformOutput', false);

    else
        % Numeric input: either a vector or a matrix (rows are supports)
        if isvector(sigma)
            sigma = sigma(:)'; % row vector
        end
        cand = mat2cell(sigma, ones(size(sigma,1),1), size(sigma,2));
        cand = cellfun(@(v) unique(v(:)'), cand, 'UniformOutput', false);
    end

    % Clean up: clip indices to [1..n] and remove empty entries
    cand = cellfun(@(v) v(v>=1 & v<=n), cand, 'UniformOutput', false);
    cand = cand(~cellfun('isempty', cand));

    % ===== Evaluate each candidate support =====
    FPs = []; 
    supports = {};
    for k = 1:numel(cand)
        [TF, y] = check_fixedpt_y(W, cand{k}, b);
        if TF
            FPs = [FPs, y];            %#ok<AGROW>  % collect valid fixed points
            supports{end+1} = cand{k}; %#ok<AGROW>  % record support indices
        end
    end
    if isempty(FPs)
        warning('No fixed points found.');
        return;
    end

%     FPs(:,1) = [0;0;0;0;1]; % case for y4-y3 y3-y2 y2-y1 in 4-cycle with c<a+1
    
    % ===== Plot fixed points =====
    figure(4); hold on; grid on
    set(gca, 'FontSize',14, 'TickLabelInterpreter','latex');
    ms = 50; % marker size

    if n == 2
        % ---- 2D case: plot [y1, yI] ----
        scatter(FPs(1,:), FPs(2,:), ms, 'filled', ...
            'MarkerFaceColor','k', 'MarkerEdgeColor','k', 'HandleVisibility','off');
        xlabel('$y_1$', 'Interpreter','latex');
        ylabel('$y_I$', 'Interpreter','latex');

    elseif n == 3
        % ---- 3D case: plot [y1, y2, yI] ----
        scatter3(FPs(1,:), FPs(2,:), FPs(3,:), ms, 'filled', ...
            'MarkerFaceColor','k', 'MarkerEdgeColor','k', 'HandleVisibility','off');
        xlabel('$y_1$', 'Interpreter','latex');
        ylabel('$y_2$', 'Interpreter','latex');
        zlabel('$y_I$', 'Interpreter','latex');
        view(45,30);

    else
        % ---- Higher-dimensional case: plot first three coordinates ----
        scatter3(FPs(1,:), FPs(2,:), FPs(3,:), ms, 'filled', ...
            'MarkerFaceColor','k', 'MarkerEdgeColor','k', 'HandleVisibility','off');
        xlabel('$y_1$', 'Interpreter','latex');
        ylabel('$y_2$', 'Interpreter','latex');
        zlabel('$y_3$', 'Interpreter','latex');
        view(45,30);
    end

    % ===== Console summary =====
    fprintf('Found %d fixed point(s).\n', size(FPs,2));
    for i = 1:size(FPs,2)
        fprintf('FP %d (support = {%s}): ', i, num2str(supports{i}));
        fprintf('%g ', FPs(:,i));
        fprintf('\n');
    end
end
