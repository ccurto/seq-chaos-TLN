function [FPs, supports] = check_fixed_points_y(W, b, sigma)
% PLOT_FIXED_POINTS_Y  (compute-only)
% -------------------------------------------------------------------------
% Compute all fixed points of a threshold-linear network (TLN) for a given
% weight matrix W. 
%
% INPUTS
%   W      : n×n connectivity matrix.
%   b      : n×1 bias vector (optional; default = ones(n,1)).
%   sigma  : (optional) candidate supports to test.
%             - []                 → test all nonempty subsets of {1,…,n}.
%             - vector             → treated as a single support.
%             - numeric matrix     → each ROW is a support (indices).
%             - cell array         → each cell is a vector of indices.
%
% OUTPUTS
%   FPs       : n×m matrix; each column is a fixed point y.
%   supports  : 1×m cell array; supports{k} are the active indices for FPs(:,k).
%
% DEPENDENCY
%   Requires: [TF, y] = check_fixedpt_y(W, sig, b)
%     - TF : logical flag (true if 'sig' yields a valid fixed point)
%     - y  : corresponding fixed point vector (n×1)
%
%
% Created by Jie, Oct 2025.
% -------------------------------------------------------------------------

    % ===== Basic checks =====
    n = size(W,1);
    if n < 2
        error('This function expects n ≥ 2.');
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

    % ===== Build candidate supports =====
    if isempty(sigma)
        % All nonempty subsets of {1,…,n}
        % (⚠ combinatorial explosion for large n)
        cand = arrayfun(@(m) find(bitget(m,1:n)), 1:(2^n-1), 'UniformOutput', false);

    elseif iscell(sigma)
        % Cell array of index sets
        cand = cellfun(@(v) unique(v(:)'), sigma, 'UniformOutput', false);

    else
        % Numeric input: vector or matrix whose rows are supports
        if isvector(sigma)
            sigma = sigma(:)'; % force row vector
        end
        cand = mat2cell(sigma, ones(size(sigma,1),1), size(sigma,2));
        cand = cellfun(@(v) unique(v(:)'), cand, 'UniformOutput', false);
    end

    % Clean up supports: clip to [1..n] and drop empties
    cand = cellfun(@(v) v(v>=1 & v<=n), cand, 'UniformOutput', false);
    cand = cand(~cellfun('isempty', cand));

    % ===== Evaluate supports =====
    FPs = [];
    supports = {};
    for k = 1:numel(cand)
        [TF, y] = check_fixedpt_y(W, cand{k}, b);
        if TF
            FPs = [FPs, y];             
            supports{end+1} = cand{k};  
        end
    end

    % Optional: console summary (silent if you prefer)
    fprintf('Found %d fixed point(s).\n', size(FPs,2));
    for i = 1:size(FPs,2)
        fprintf('FP %d (support = {%s}): ', i, num2str(supports{i}));
        fprintf('%g ', FPs(:,i)); fprintf('\n');
    end
end
