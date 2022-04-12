%% Constants
Kg = 33.3; %Gear Ratio
Km = 0.0401; %Motor Constant [NM\amp]
Rm  = 19.2; %Armature Resitance (Output motor resistance) [ohms]
L = 0.45; %Link length [m0]
Marm = 0.060; %Mass of ruler
Mtip = 0.05; %Tip mass [kg]
Jhub = 0.0005;
Jextra = 0.2*0.2794^2;
Jload = 0.0015;
Jarm = (Marm*L^2)/3; %Link Rigid body of inertia
Jm = Mtip*L^2; %Tip mass inertia
Jl = Jarm+Jm; %Inertia of flex link and mass
J = Jhub+Jload+Jextra; %Moment of inertia about the shaft [Kgm^2]
fc = 1.8; %Natural Frequency [Hz]
Kstiff = (2*pi*fc)^2*(Jl);

%% Closed Loop System
Kd = 1.5;
Kp = 5;
num = (Kg*Km)/(J*Rm);
d2 = 1; %s^2 coeff
d1 = (((Kg^2)*(Km^2))/(J*Rm))+((Kd*Kg*Km)/(J*Rm));
d0 = (Kp*Kg*Km)/(J*Rm);
den = [d2 d1 d0];
sysTF = tf(num,den);


%% Step Response
[x,t] = step(sysTF);

figure()
hold on
plot(t,x);
title('Simulation');
xlabel('Time');
ylabel('Position');
hold off

%% Peak Time

%% Maximum Overshoot 
Mp = 0.2; %20 percent 
%% Settling Time
%5%
ts = 1;
% ts = 3.0/zeta*wn
