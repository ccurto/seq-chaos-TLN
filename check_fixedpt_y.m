function [TF,y_fp] = check_fixedpt_y(W,sig,b)
% CHECK_FIXEDPT_Y - Check if a fixed point of y exists with given support sigma.
% Modified by Jie: neurons not in sigma are kept but their outgoing weights are set to zero.
%
% INPUT:
%   W   : n×n weight matrix
%   sig : support set (indices of "on" neurons)
%   b   : n×1 bias vector (default: ones(n,1))
%
% OUTPUT:
%   TF    : 1 if a fixed point exists, 0 otherwise
%   y_fp  : n×1 fixed point vector

    n = size(W,1);           % number of neurons
    TF = 1;                  % assume fixed point exists by default

    if nargin < 3 || isempty(b)
        b = ones(n,1);
    end

    % ----------------------------------------------------------
    % 1) Modify W so that all outgoing weights from neurons not
    %    in the support set are zero.
    % ----------------------------------------------------------
    W_mod = W;
    sigbar = setdiff(1:n, sig);
    W_mod(:, sigbar) = 0;    %  zero out columns for non-sigma neurons

    % ----------------------------------------------------------
    % 2) Solve (I - W_mod)x = b
    % ----------------------------------------------------------
    M = eye(n) - W_mod;
    y_fp = M \ b;

    % ----------------------------------------------------------
    % 3) Check fixed point conditions
    % ----------------------------------------------------------

    % Condition 1: "on" neurons must be positive
    if any(y_fp(sig) <= 0)
        TF = 0;
        return
    end

    % Condition 2: "off" neurons must satisfy W_{k,:} x + b_k <= 0
    tol = 1e-10;              % numerical tolerance
    for k = sigbar
        sk = W_mod(k,:) * y_fp + b(k);
        if sk > tol
            TF = 0;
            return
        end
    end
end
