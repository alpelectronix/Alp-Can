s = tf('s'); % Define a Laplace parameter

%**SPECIFICATIONS**
Vs = 60; Vo = 15; % Input and output DC voltage values

%**SELECTIONS**
f_s = 1e5; % Switching frequency

%**BUCK CONTROLLER IC: LM5146**
Vref = 0.8; % Reference voltage from Buck Controller LM5146
Vramp = Vs/15; %Ramp voltage amplitude from Buck Controller LM5146
A_DC = 50119; % Error amplifier open-loop DC gain
f_pe = 129.7; % Error amplifier open-loop pole

%**COMPONENTS**
R = 7.5; L = 300e-6; C = 20e-6; % Buck converter output filter values
r_C = 0.400; % ESR of the capacitor C 
r_L = 0.025; % ESR of the inductor L

%**TRANSFER FUNCTIONS**
M = Vs/Vramp; % PWM modulator transfer function
F = (1+r_C*C*s)/(1+r_L/R + (L/R+(r_C+r_L)*C+r_C*r_L*C/R)*s + (1+r_C/R)*L*C*s^2); % Filter and Load

%**BREAK FREQUENCIES**
f_LC = 1/(2*pi*sqrt(L*C)); % Filter's resonant frequency
f_z1 = 0.9*f_LC; % First zero frequency slightly lower than f_LC
f_t = 0.1*f_s; % Crossover frequency (selected value one decade below f_s)

%**CONTROLLER COMPONENT VALUES**
R4 = 1e4; % Bottom resistor for reference voltage divider (selected)
R1 = (Vo/Vref - 1)*R4; % Top resistor for reference voltage divider
C3 = 1/(2*pi*f_z1*R1);
R3 = 1/(2*pi*f_t*C3);

G_MF = M*F; % Loop transfer function Modulator + Filter
K_comp = 1.438; % Required compensator gain at the crossover frequency

R2 = K_comp*(R1^-1+R3^-1)^-1;
C2 = 1/(2*pi*0.9*f_LC*R2);
C1 = 1/(2*pi*10*f_t*R2);

%**COMPENSATOR TRANSFER FUNCTION**
G_OL = -A_DC/(1+s/(2*pi*f_pe)); % Error amplifier transfer
beta = (R1*R3*C1*s*(s+(C1+C2)/(C1*C2*R2))*(s+1/(R3*C3)))/((R1+R3)*(s+1/(R2*C2))*(s+1/((R1+R3)*C3)));
G_comp = G_OL/(1+G_OL*beta); % Compensator transfer
G_loop = M*F*G_comp;

