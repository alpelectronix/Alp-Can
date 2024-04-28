s = tf('s'); % Define a Laplace parameter
L1 = 1e3/((s+4)*(s+8)*(s+10)); % Loop Transfer Function
L2 = 2e3/((s+4)*(s+8)*(s+10)); % Loop Transfer Function
L3 = 4e3/((s+4)*(s+8)*(s+10)); % Loop Transfer Function

bode(L1,L2,L3); grid on % Bode plot of the Loop Transfer Function

