s = tf('s'); % Define a Laplace parameter
G = 2/(s-1); H = 1/(s+3); % Individual Transfer Functions
L = G*H; % Loop Transfer Function
rlocus(L); grid on % Root Locus Plot of Loop Transfer Function

