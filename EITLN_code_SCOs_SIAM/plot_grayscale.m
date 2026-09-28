function plot_grayscale(X)

% function plot_grayscale(X)
%
% X = solution matrix, like soln.X from output of threshlin_ode.m.
% updated Sep 2, 2026 by Jie to change boundary from 1 to 3 for E-I TLNs


% grayscale colormap
cmap = [.05:.001:1]'*[1 1 1];  % make scale refined, with a "gap" from 0
cmap = ones(size(cmap))-cmap;
cmap = [1 1 1; cmap]; % use white when activity hits 0
colormap(cmap)
% clim = [0,min(1,max(X(:)))];
clim = [0,min(3,max(X(:)))];

imagesc(X',clim)
set(gca,'XTick',[]); % to remove tick marks on x-axis
ylabel('neuron number')