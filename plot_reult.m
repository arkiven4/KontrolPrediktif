close all
clear

load("Modelout2.mat")
[sim_mpc_refftraj, sim_mpc_mo] = synchronize(sim_mpc_refftraj, sim_mpc_mo, 'union');
[sim_mpc_refftraj, sim_nmpc_mo] = synchronize(sim_mpc_refftraj,sim_nmpc_mo,'union');
[sim_mpc_mv, sim_nmpc_mv] = synchronize(sim_mpc_mv,sim_nmpc_mv,'union');
[sim_mpc_ca, sim_nmpc_ca] = synchronize(sim_mpc_ca,sim_nmpc_ca,'union');

time_reff = sim_mpc_refftraj.Time;
refference_trajectory = sim_mpc_refftraj.Data;

tmpc_reactortemperature = sim_mpc_mo.Time;
mpc_reactortemperature = sim_mpc_mo.Data;
tnmpc_reactortemperature = sim_nmpc_mo.Time;
nmpc_reactortemperature = sim_nmpc_mo.Data;

time_mv = sim_mpc_mv.Time;
mpc_manipulated_variable = sim_mpc_mv.Data;
nmpc_manipulated_variable = sim_nmpc_mv.Data;

time_ca = sim_mpc_ca.Time;
mpc_concentration = sim_mpc_ca.Data;
nmpc_concentration = sim_nmpc_ca.Data;

figure
subplot(2,1,1);
plot(time_reff,refference_trajectory, 'k-', 'LineWidth', 2)
hold on
plot(tmpc_reactortemperature,mpc_reactortemperature, 'b-.', 'LineWidth', 2)
plot(tnmpc_reactortemperature,nmpc_reactortemperature, 'r--', 'LineWidth', 2)
legend('Reference Trajectory', 'MPC Reactor Temperature', 'NMPC Reactor Temperature');
xlabel('Time (t)');
ylabel('Temperature (°C)');
grid on;

subplot(2,1,2);
plot(time_mv,mpc_manipulated_variable, 'b-.', 'LineWidth', 2)
hold on
plot(time_mv,nmpc_manipulated_variable, 'r--', 'LineWidth', 2)
legend('MPC Cooling Temperature (MV)', 'NMPC Cooling Temperature (MV)');
xlabel('Time (t)');
ylabel('Temperature (°C)');
grid on;

figure
plot(time_ca,mpc_concentration, 'b-.', 'LineWidth', 2)
hold on
plot(time_ca,nmpc_concentration, 'r--', 'LineWidth', 2)
legend('MPC Concentration of reagent', 'NMPC Concentration of reagent');
xlabel('Time (t)');
ylabel('Concentration reagent (kmol/m3)');
grid on;