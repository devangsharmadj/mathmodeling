syms x y C0 C1
syms Init_price_subs Init_number_subs Init_price_advert Init_number_adverts
syms lam mu0 mu1 Subs_lost_per_advert_decrease

C0_substitution_constants = [Init_number_subs, lam, Init_price_subs];
C0_substitution_values = [80000, -90000, 1.50];

C1_substitution_constants = [Init_number_adverts, mu0, mu1, Init_price_advert];
C1_substitution_values = [350,  0.0000000015, -0.0001, 250];

C0 = Init_number_subs + lam * (x - Init_price_subs)^3;
C0_subs = subs(C0, C0_substitution_constants, C0_substitution_values);

C1 = Init_number_adverts + (mu0*C0 + mu1) * (y - Init_price_advert)^3;
C1_sub_inter = Init_number_adverts + (mu0*(C0_subs - 80000) + mu1) * (y - Init_price_advert)^3;
C1_subs = subs(C1_sub_inter, C1_substitution_constants, C1_substitution_values);

%y_values = linspace(0, 500, 100);
%C1_values = subs()

%figure;
R = x * C0 + y * C1; 

%disp(R);

R_subs = x * C0_subs + y * C1_subs;


% Calculate the gradient
grad = gradient(R_subs, [x, y]);

% Solve for x and y such that the gradient is zero
assume(x,'real');
assumeAlso(0 <= x);
assume(y, 'real');
assumeAlso(0 <= y);
sol = vpasolve(grad == [0; 0], [x, y], [1.5, 250]);


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

substitution_constants = [Init_number_subs, lam, Init_price_subs, Init_number_adverts, mu0, mu1, Init_price_advert, x, y];
substitution_values = [80000, -90000, 1.50, 350,  0.0000000015, -0.0001, 250, 1.8764676380259616281529126148734, 307.69576827944854127627650076179];

dR_dInit_price_subs = subs(diff(R, Init_price_subs), substitution_constants, substitution_values);
dR_dInit_number_subs = subs(diff(R, Init_number_subs), substitution_constants, substitution_values);
dR_dInit_price_advert = subs(diff(R, Init_price_advert), substitution_constants, substitution_values);
dR_dInit_number_adverts = subs(diff(R, Init_number_adverts), substitution_constants, substitution_values);
dR_dmu0 = subs(diff(R, mu0), substitution_constants, substitution_values);
dR_dmu1 = subs(diff(R, mu1), substitution_constants, substitution_values);
dR_dlam = subs(diff(R, lam), substitution_constants, substitution_values);

R_val = subs(R, substitution_constants, substitution_values);

sensitivity_Init_price_subs = (1.5 / R_val) * dR_dInit_price_subs;
sensitivity_Init_number_subs = (80000 / R_val) * dR_dInit_number_subs;
sensitivity_Init_price_advert = (250 / R_val) * dR_dInit_price_advert;
sensitivity_Init_number_adverts = (350 / R_val) * dR_dInit_number_adverts;
sensitivity_mu0 = (0.0000000015 / R_val) * dR_dmu0;
sensitivity_mu1 = (-0.0001 / R_val) * dR_dmu1;
sensitivity_lam = (-90000 / R_val) * dR_dlam;

%disp(double(sensitivity_Init_price_subs));
disp(['optimal x = ' num2str(1.8764676380259616281529126148734)]);
disp(['optimal y = ' num2str(307.69576827944854127627650076179)]);
disp(['maximized objective function = ' num2str(double(R_val))]);
disp('Sensitivity analysis:');
disp(['Sensitivity of Init_price_subs: ' num2str(double(sensitivity_Init_price_subs))]);
disp(['Sensitivity of Init_number_subs: ' num2str(double(sensitivity_Init_number_subs))]);
disp(['Sensitivity of Init_price_advert: ' num2str(double(sensitivity_Init_price_advert))]);
disp(['Sensitivity of init_number_adverts: ' num2str(double(sensitivity_Init_number_adverts))]);
disp(['Sensitivity of mu0: ' num2str(double(sensitivity_mu0))]);
disp(['Sensitivity of mu1: ' num2str(double(sensitivity_mu1))]);
disp(['Sensitivity of lam: ' num2str(double(sensitivity_lam))]);

%{
Results:
optimal x = 1.8765
optimal y = 307.6958
maximized objective function = 249556.304
Sensitivity analysis:
Sensitivity of Init_price_subs: 0.45199
Sensitivity of Init_number_subs: 0.62995
Sensitivity of Init_price_advert: -0.039392
Sensitivity of init_number_adverts: 0.43154
Sensitivity of mu0: 0.026711
Sensitivity of mu1: -0.02368
Sensitivity of lam: -0.037813
%}






