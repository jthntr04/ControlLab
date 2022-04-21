%% Set Up Command Window
clc; clear; close all;

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

%% Maximum Overshoot 
Mp = 1.2*0.12; %20 percent 
zeta = sqrt((log(Mp))^2/(pi^2+(log(Mp))^2));
%% Settling Time
% 5%
ts = 1;
Wn = 3/(zeta*ts);

%% Solve for Proportional Gain & Kd 
Kp = ((Wn^2)*(J*Rm))/(Kg*Km);
Kd = (zeta*(2*sqrt(Kp*Kg*Km*J*Rm))-((Kg^2)*(Km^2)))/(Kg*Km);

%% Closed Loop System
num = (Kg*Km)/(J*Rm);
d2 = 1; %s^2 coeff
d1 = (((Kg^2)*(Km^2))/(J*Rm))+((Kd*Kg*Km)/(J*Rm));
d0 = (Kp*Kg*Km)/(J*Rm);
den = [d2 d1 d0];
sysTF = tf(num,den);


%% Step Response
[x,t] = step(sysTF);
%% Import Data 
testData = load('testData');
A = (testData(2494:4500,1)-11925000)/1000;
B = testData(2494:4500,2)+(-1*testData(2493,2));
testData2 = load('testData2');

% A = load('April72022/rigid_5_kp_5_kd_0'); %Kp = 5, Kd = 0
% B = load('April72022/rigid_5_kp_10_kd_0'); %Kp = 10, Kd = 0
% C = load('April72022/rigid_5_kp_15_kd_1pt5'); %Kp = 15, Kd = 1
% D = load('April72022/rigid_5_kp_20_kd_0'); %Kp = 20, Kd = 0
% 
% figure()
% hold on 
% plot(A(:,1)/1000),A(:,2);

%% Plotting
figure()
hold on 
title('Model Vs Experimental');
plot(t,x*4.9);
plot(A,B);
xlabel('Time');
ylabel('Angular Position');
legend('Model', 'Experimental');
hold off

% figure()
% hold on
% plot(t,x*3);
% plot((testData(2494:10000,1)-11925000)/1000, testData(2494:10000,2));
% xline(ts);
% yline(Mp);
% ylim([0,0.3]);
% title('Model Response');
% xlabel('Time');
% ylabel('Position');
% legend('Response', 'Settling Time', 'Maximum Overshoot');
% hold off
% 
% figure()
% hold on
% %plot((testData(2494:10000,1)-11925000)/1000, testData(2494:10000,2)+(-1*testData(2494,2))); %+0.319
% plot(A,B);
% xline(1);
% yline(1.2*0.3);
% title('Experimental Response');
% xlabel('Time');
% ylabel('Position');
% legend('Response', 'Settling Time', 'Maximum Overshoot');
% hold off
% 
% figure()
% hold on
% plot((testData2(2249:10000,1)-13405000)/1000, testData2(2249:10000,2));
% xline(1);
% yline(1.2*0.3);
% title('Modified Response');
% xlabel('Time');
% ylabel('Position');
% legend('Response', 'Settling Time', 'Maximum Overshoot');
% hold off



