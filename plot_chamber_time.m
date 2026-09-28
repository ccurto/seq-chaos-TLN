function plot_chamber_time(Y, time)
% PLOT_CHAMBER_TIME
% Plot a color band showing which chamber the system is in over time.
%
% Requires: chamber_color(n)
%   chamber_color(n) returns a struct of all chamber colors,
%   with field names like 'R_empty', 'R1', 'R12', 'R123', ..., 'R123...n'.

% Created by Jie on Jan 7 2026

    [T, n] = size(Y);
    if nargin < 2 || isempty(time), time = 1:T; end
    if numel(time) ~= T
        error('time length must match size(Y,1).');
    end
    time = time(:)';  % ensure row vector

    % ----- parameters -----
    tol = 1e-20;       % threshold for positivity
    band_height = 20;  % height of color band in pixels

    % ----- color map for all chambers -----
    cmap = chamber_color(n);

    % ----- preallocate image -----
    pos = Y > tol;           % T×n logical: positive or not
    img = zeros(band_height, T, 3);

    % helper to build field name like 'R12' or 'R135'
    make_key = @(idxs) sprintf('R%s', strjoin(string(idxs), ''));

    % precompute key for the full active chamber
    full_key = make_key(1:n);

    % ----- assign colors for each time point -----
    for t = 1:T
        idxs = find(pos(t,:));   % positive indices
        k = numel(idxs);

        if k == 0
            key = 'R_empty';
        elseif k == n
            key = full_key;
        else
            key = make_key(idxs);
        end

        % get color from cmap; fallback if missing
        if isfield(cmap, key)
            c = cmap.(key);
        else
            base = lines(n);
            if k == 0
                c = [0.8 0.8 0.8];
            elseif k == 1
                c = base(idxs(1),:);
            else
                c = mean(base(idxs,:),1);
            end
        end
        img(:,t,1) = c(1);
        img(:,t,2) = c(2);
        img(:,t,3) = c(3);
    end

    % ----- plot -----
    imagesc(time, 1:band_height, img);
    axis tight
    set(gca, 'YTick', [], 'TickLength', [0 0]);
    xlabel('Time');
    ylabel('Chamber');
end
