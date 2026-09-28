function cmap = chamber_color(n)
% CHAMBER_COLOR  
% -------------------------------------------------------------------------
% Generate a color map (struct) assigning a unique RGB color to each
% possible "chamber" (region) defined by sign patterns of n coordinates.
%
% OUTPUT
%   cmap : struct with fields like
%          'R_empty', 'R1', 'R12', 'R13', ..., 'R123..n'
%
% COLOR RULES (for ring-like systems)
% -------------------------------------------------------------------------
% (1) Empty chamber:   R_empty → light gray  [0.7 0.7 0.7]
% (2) Singletons:      Ri → base colors from MATLAB's lines(n)
% (3) Pair chambers Rij (i < j):
%       - R12 is *always* the darkened color of R1 (fixed convention)
%       - Adjacent pairs (i, i+1) and (1, n) on the ring:
%             use darkened color of the smaller index,
%             except (1, n) → use darkened color of Rn.
%       - Non-adjacent pairs → mean of the two singleton colors (mix)
% (4) Full mix chamber R123...n → dark gray [0.1 0.1 0.1]
% (5) Intermediate mixes (3 ≤ k < n) → mean of their singleton colors
%
% Example:
%   cmap = chamber_color(5);
%   cmap.R12  → darkened R1 color
%   cmap.R15  → darkened R5 color (cyclic neighbor)
%   cmap.R24  → mixed color of R2 and R4
%
% Created by Jie on Oct 22, 2025
% -------------------------------------------------------------------------

    % ====== Base parameters ======
    base        = lines(n);      % base colors for R1..Rn
    if n >= 8
        base(8,:) = [0.50, 0.20, 0.20];   % add brown as the 8th color
    end
    dark_factor = 0.55;          % factor for darkening colors
    cmap        = struct();      % output struct initialization

    % Helper functions
    keystr = @(idxs) ['R' strjoin(arrayfun(@num2str, idxs, 'UniformOutput', false), '')];
    darken = @(rgb) max(min(rgb * dark_factor, 1), 0);   % clamp to [0,1] after darkening

    % ====== 1) Empty and full mix ======
    cmap.R_empty = [0.7 0.7 0.7];          % background / silent chamber
    cmap.(keystr(1:n)) = [0.1 0.1 0.1];    % full mix (all active) → dark gray

    % ====== 2) Singletons ======
    for i = 1:n
        cmap.(sprintf('R%d', i)) = base(i,:);  % assign base color
    end

    % ====== 3) Pairs (i < j) ======
    % Generate colors for all two-node chambers Rij.
    %   - Adjacent pairs follow "pair rule"
    %   - Non-adjacent pairs use "mix rule"
    for i = 1:n-1
        for j = i+1:n
            if i == 1 && j == 2
                % Fixed: R12 always darkened R1
                col = darken(base(1,:));
            elseif (j == i+1)
                % Adjacent pair (e.g., R23, R34, R45)
                col = darken(base(i,:));
            elseif (i == 1 && j == n)
                % Cyclic pair (R1n, e.g., R15 when n=5)
                col = darken(base(n,:));
            else
                % Non-adjacent pair (e.g., R13, R24, R35)
                col = mean(base([i j],:), 1);
            end
            cmap.(sprintf('R%d%d', i, j)) = col;
        end
    end

    % ====== 4) Higher-order mixes (3 ≤ k < n) ======
    % For chambers involving 3 or more indices (but not all n),
    % take the mean color of their constituent singletons.
    for k = 3:n-1
        sets = nchoosek(1:n, k);   % all combinations of k nodes
        for s = 1:size(sets,1)
            idxs = sets(s,:);
            cmap.(keystr(idxs)) = mean(base(idxs,:), 1);
        end
    end
end
