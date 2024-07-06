close all
clear

plant_mdl = 'mpc_cstr_plant';
op = operspec(plant_mdl);

% Feed concentration is known at the initial condition.
op.Inputs(1).u = 10;
op.Inputs(1).Known = true;

% Feed temperature is known at the initial condition.
op.Inputs(2).u = 298.15;
op.Inputs(2).Known = true;

% Coolant temperature is known at the initial condition.
op.Inputs(3).u = 298.15;
op.Inputs(3).Known = true;

% Compute initial condition.
[op_point, op_report] = findop(plant_mdl,op); 

% Obtain nominal values of x, y and u.
x0 = [op_report.States(1).x;op_report.States(2).x];
y0 = [op_report.Outputs(1).y;op_report.Outputs(2).y];
u0 = [op_report.Inputs(1).u;op_report.Inputs(2).u;op_report.Inputs(3).u];

% Obtain linear plant model at the initial condition.
sys = linearize(plant_mdl, op_point); 

% Drop the first plant input CAi and second output CA because they are not
% used by MPC.
sys = sys(1,2:3);

% Discretize the plant model because Adaptive MPC controller only accepts a
% discrete-time plant model.
Ts = 0.5;
plant = c2d(sys,Ts);

%% Design MPC Controller

% Specify signal types used in MPC.
plant.InputGroup.MeasuredDisturbances = 1;
plant.InputGroup.ManipulatedVariables = 2;
plant.OutputGroup.Measured = 1;
plant.InputName = {'Ti','Tc'};
plant.OutputName = {'T'};

% Create MPC controller with default prediction and control horizons
mpcobj = mpc(plant);

% Set nominal values in the controller
mpcobj.Model.Nominal = struct('X', x0, 'U', u0(2:3), 'Y', y0(1), 'DX', [0 0]);

% Set scale factors because plant input and output signals have different
% orders of magnitude
Uscale = [30 50];
Yscale = 50;
mpcobj.DV.ScaleFactor = Uscale(1);
mpcobj.MV.ScaleFactor = Uscale(2);
mpcobj.OV.ScaleFactor = Yscale;

% Due to the physical constraint of coolant jacket, Tc rate of change is
% bounded by 2 degrees per minute.
mpcobj.MV.RateMin = -2;
mpcobj.MV.RateMax = 2;

if ~mpcchecktoolboxinstalled('ident')
    disp('System Identification Toolbox(TM) is required to run this example.')
    return
end
%%
% Open the Simulink model.
mdl = 'ampc_cstr_estimation';
open_system(mdl);

[num, den] = tfdata(plant);
Aq = den{1};
Bq = num;

% Simulate the closed-loop performance.
open_system([mdl '/Concentration'])
open_system([mdl '/Temperature'])
sim(mdl)

mdl1 = 'ampc_cstr_no_estimation';
open_system(mdl1)
open_system([mdl1 '/Concentration'])
open_system([mdl1 '/Temperature'])
sim(mdl1)



