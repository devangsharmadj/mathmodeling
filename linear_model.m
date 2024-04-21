syms x y C0 C1
syms Init_price_subs Init_number_subs Init_price_advert Init_number_adverts
syms subs_lost_price adv_lost subs_lost_adv Subs_lost_per_advert_decrease mu0 mu1 lam

C0_substitution_constants = [Init_number_subs, subs_lost_price, Init_price_subs, Init_price_advert, subs_lost_adv, adv_lost];
C0_substitution_values = [80000, 5000/.1, 1.50, 250, 1000/50, 50/100];

C1_substitution_constants = [Init_number_adverts, adv_lost, Init_price_advert];
C1_substitution_values = [350,  50/100, 250];

C0 = Init_number_subs - (x-Init_price_subs)*(subs_lost_price) - (y-Init_price_advert) * subs_lost_adv * adv_lost;
C0_subs = subs(C0, C0_substitution_constants, C0_substitution_values);
%disp(C0_subs);
C1 = Init_number_adverts - (y-Init_price_advert) * adv_lost;
C1_subs = subs(C1, C1_substitution_constants, C1_substitution_values);

%y_values = linspace(0, 500, 100);
%C1_values = subs()

%figure;
R = C0 * x + C1 * y; 

%disp(R);

R_subs = C0_subs * x + C1_subs * y;

%disp(R_subs);
% Calculate the gradient
grad = gradient(R_subs, [x, y]);

% Solve for x and y such that the gradient is zero
assume(x,'real');
assumeAlso(0 <= x);
assume(y, 'real');
assumeAlso(0 <= y);
%sol = vpasolve(grad == [0; 0], [x, y], [1.5, 500]);
sol = fsolve(@(vars) double(subs(grad, [x, y], vars)), [1.5, 250]);
%disp(double(subs(subs(grad, x, 1.52902), y, 459.7067)));
%disp(sol);
%disp(double(subs(subs(R_subs, x, 1.53), y, 359)));
%disp(double(subs(subs(R_subs, x, 1.53), y, 600)));
%[x_opt, y_opt] = solve([dR_dx == 0, dR_dy == 0], [x, y]);
%value = 255;
%x_opt_val = subs(x_opt, v, value);
%x_opt_val = subs(y_opt, v, value);

% Display the solution with 10 significant figures
%disp(['x = ' char(sol.x)]);
%disp(['y = ' char(sol.y)]);
%C0_subs_val = subs(C0, x, 1.8764676380259616281529126148734);

%R_subs_val = subs(R_subs, x, 1.5);
%R_subs_val = subs(R_subs_val, y, 433);

%disp(double(R_subs_val));


%x = [1.8764676380259616281529126148734; 0.91857965340981308297580687927781; 1.9001412272877111242594699148336; 1.9367125598483000560918425151926]
%y = [307.69576827944854127627650076179; 318.24315970040624075953362510479; 158.32479043469949623280932907675; 95.415382647485939784795513728968]
%R = [2.4246e+05; 1.9369e+05; 2.0972e+05; 2.1302e+05]


%%% Sensitivity Analysis %%%

substitution_constants = [Init_number_subs, adv_lost, Init_price_subs, Init_number_adverts, subs_lost_adv, subs_lost_price, Init_price_advert, x, y];
substitution_values = [80000, 50/100, 1.50, 350,  1000/50, 5000/.1, 250, 1.5290292912452677, 459.7067436151746];

dR_dInit_price_subs = subs(diff(R, Init_price_subs), substitution_constants, substitution_values);
dR_dInit_number_subs = subs(diff(R, Init_number_subs), substitution_constants, substitution_values);
dR_dInit_price_advert = subs(diff(R, Init_price_advert), substitution_constants, substitution_values);
dR_dInit_number_adverts = subs(diff(R, Init_number_adverts), substitution_constants, substitution_values);
dR_dmu0 = subs(diff(R, adv_lost), substitution_constants, substitution_values);
dR_dmu1 = subs(diff(R, subs_lost_adv), substitution_constants, substitution_values);
dR_dlam = subs(diff(R, subs_lost_price), substitution_constants, substitution_values);

R_val = subs(R, substitution_constants, substitution_values);

sensitivity_Init_price_subs = (1.5 / R_val) * dR_dInit_price_subs;
sensitivity_Init_number_subs = (80000 / R_val) * dR_dInit_number_subs;
sensitivity_Init_price_advert = (250 / R_val) * dR_dInit_price_advert;
sensitivity_Init_number_adverts = (350 / R_val) * dR_dInit_number_adverts;
sensitivity_mu0 = (50/100 / R_val) * dR_dmu0;
sensitivity_mu1 = (1000/50 / R_val) * dR_dmu1;
sensitivity_lam = (5000/.1 / R_val) * dR_dlam;

%disp(double(sensitivity_Init_price_subs));
disp(['optimal x = ' num2str(sol(1))]);
disp(['optimal y = ' num2str(sol(2))]);
disp(['maximized objective function = ' num2str(double(R_val))]);
disp('Sensitivity analysis:');
disp(['Sensitivity of Init_price_subs: ' num2str(double(sensitivity_Init_price_subs))]);
disp(['Sensitivity of Init_number_subs: ' num2str(double(sensitivity_Init_number_subs))]);
disp(['Sensitivity of Init_price_advert: ' num2str(double(sensitivity_Init_price_advert))]);
disp(['Sensitivity of init_number_adverts: ' num2str(double(sensitivity_Init_number_adverts))]);
disp(['Sensitivity of advs_count: ' num2str(double(sensitivity_mu0))]);
disp(['Sensitivity of subs_lost_adv: ' num2str(double(sensitivity_mu1))]);
disp(['Sensitivity of subs_lost_price: ' num2str(double(sensitivity_lam))]);
 
% %{
% Results:
% optimal x = 1.8765
% optimal y = 307.6958
% maximized objective function = 249556.304
% Sensitivity analysis:
% Sensitivity of Init_price_subs: 0.45199
% Sensitivity of Init_number_subs: 0.62995
% Sensitivity of Init_price_advert: -0.039392
% Sensitivity of init_number_adverts: 0.43154
% Sensitivity of mu0: 0.026711
% Sensitivity of mu1: -0.02368
% Sensitivity of lam: -0.037813
% %}