function soln = threshlin_ode(W,b,T,X0,tau)

% THRESHLIN_ODE  Solve a threshold-linear network (TLN) ODE.
%
%   soln = threshlin_ode(W,b,T,X0,tau)
%
% Inputs
%   W   : N x N recurrent connectivity matrix
%         (for an E-I TLN, N = n+1, where the last node is inhibitory)
%
%   b   : external input
%         - either an N x 1 column vector, or
%         - an N x m matrix, where each column is an input vector
%           applied over one time interval
%
%   T   : simulation duration for each input vector
%         - scalar or 1 x m vector
%         - if b has m columns, then T(i) is the duration for b(:,i)
%
%   X0  : N x 1 column vector of initial firing rates
%
%   tau : N x 1 vector of node-specific timescales
%         - default: tau = ones(N,1)
%         - for CTLNs, this gives the standard form
%         - for E-I TLNs, tau may differ between E and I nodes
%
% Dynamics
%   The system evolves according to
%
%       dx/dt = tau.^(-1) .* ( -x + [W x + b]_+ ),
%
%   where [·]_+ denotes the ReLU / threshold-linear activation.
%
% Output
%   soln : structure containing the simulated trajectory and metadata
%
%       soln.time : column vector of sampled time points
%       soln.X    : length(time) x N array of firing rates x(t)
%       soln.Y    : length(time) x N array of pre-threshold values W x + b
%       soln.Z    : length(time) x (N-2) array of z-mode coordinates
%                   defined by z_i = x_{i+1} - x_i
%                   for i = 1,...,N-2
%       soln.W    : input connectivity matrix W
%       soln.b    : input matrix b
%       soln.T    : input duration vector T
%       soln.X0   : initial condition
%       soln.tau  : timescale vector
%       soln.N    : total number of nodes
%
% Notes
%   - If b has multiple columns, the system is solved sequentially over
%     each time interval, using the terminal state of one interval as the
%     initial condition for the next.
%   - The time grid is sampled at increments of 0.01.
%
%   - Jan 9, 2017: added soln.Y to store the quantities W x + b
%   - Aug 29, 2025 by Jie: extended to E-I TLNs with node-dependent timescales tau
%                   and added z-mode coordinates
%

% -------------------------------------------------------------------------
% Input checks and defaults
% -------------------------------------------------------------------------
N = size(W,1);  % total number of nodes (including the inhibitory node, if present)
if N ~= size(W,2)
    error('W must be a square matrix.');
end

if nargin < 2 || isempty(b)
    b = ones(N,1);  % default: uniform external input
end

if N ~= size(b,1)
    error('b must have same dimension as sides of W');
end

m = size(b,2);  % number of input vectors

if nargin < 3 || isempty(T)
    T = 10*ones(1,m);  % default duration for each input vector
end

if nargin < 4 || isempty(X0)
    X0 = zeros(N,1);   % default initial condition
end

if nargin < 5 || isempty(tau)
    tau = ones(N,1);   % default: uniform timescale
end
inv_tau = 1 ./ tau(:);

% -------------------------------------------------------------------------
% Initialize output structure
% -------------------------------------------------------------------------
soln.W = W;
soln.b = b;
soln.T = T;
soln.X0 = X0;
soln.X = [];
soln.Y = [];
soln.Z = [];
soln.time = [];
soln.tau = tau;
soln.N = N;

% -------------------------------------------------------------------------
% Solve the TLN ODE sequentially for each input vector
% -------------------------------------------------------------------------
t0 = 0;
x0 = X0;

for i = 1:m
    % Threshold-linear dynamics under the i-th input vector
    model = @(t,x) inv_tau .* (-x + relu(W*x + b(:,i)));

    % Sample the solution on a uniform time grid with step size 0.01
    tspan = t0:.01:t0+T(i);

    % Integrate the ODE
    [time,X] = ode45(model,tspan,x0);

    % Compute the pre-threshold quantities W x + b along the trajectory
    Y = W*X' + b(:,i)*ones(1,size(X',2));

    % Store the trajectory
    soln.X = [soln.X; X];
    soln.Y = [soln.Y; Y'];
    soln.time = [soln.time; time];

    % Compute z-mode coordinates:
    %   z_i = x_{i+1} - x_i,  for i = 1,...,N-2
    %
    % For an E-I TLN with n excitatory nodes + 1 inhibitory node,
    % this gives differences between consecutive excitatory coordinates.
    n = size(X,2);
    Z = X(:,2:n-1) - X(:,1:n-2);
    soln.Z = [soln.Z; Z];

    % Use the final state as the initial condition for the next interval
    x0 = X(end,:)';
    t0 = soln.time(end);
end

% -------------------------------------------------------------------------
% Auxiliary function: ReLU activation
% -------------------------------------------------------------------------
function y = relu(x)
    y = x;
    y(x < 0) = 0;
end

end