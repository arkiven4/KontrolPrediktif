close all
clear

load("ctsr_openloop.mat")

residutemp_t = sim_openctsr_residualtemperature.Time;
residutemp_data = sim_openctsr_residualtemperature.Data;

temperature_t = sim_openctsr_temperature.Time;
temperature_data = sim_openctsr_temperature.Data;


figure
subplot(1,2,1);
plot(temperature_t,temperature_data, 'k-', 'LineWidth', 2)
xlabel('Time (t)');
ylabel('Temperature (°C)');
ylim([220 320])
grid on;

subplot(1,2,2);
plot(residutemp_t,residutemp_data, 'k-', 'LineWidth', 2)
xlabel('Time (t)');
ylabel('Concentration reagent (kmol/m3)');
ylim([8.5 10.2])
grid on;