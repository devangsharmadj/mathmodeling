syms x y C0 C1
syms Init_price_subs Init_number_subs Init_price_advert Init_number_adverts
syms v0 v1

C0_substitution_constants = [Init_number_subs, v0, Init_price_subs];
C0_substitution_values = [80000, -0.5, 1.50];

C1_substitution_constants = [Init_number_adverts, v1, Init_price_advert];
C1_substitution_values = [350, -0.01, 250];

%C0_subs = subs(C0, C0_substitution_constants, C0_substitution_values);

C0 = 2 * Init_number_subs - ((2 * Init_number_subs) / (1 + exp(v0*(x-Init_price_subs)))) - ((y - Init_price_advert) / 100) * 1000;
C0_subs = subs(C0, C0_substitution_constants, C0_substitution_values);
C1 = 2 * Init_number_adverts - ((2 * Init_number_adverts) / (1 + exp(v1*(y - Init_price_advert))));
C1_subs = subs(C1, C1_substitution_constants, C1_substitution_values);

R = x * C0 + y * C1; 

R_subs = - x * C0_subs - y * C1_subs;

pyrunfile("Logistic_numerical_optimization.py");

%%% Sensitivity Analysis %%%
substitution_constants = [Init_number_subs, v0, Init_price_subs, Init_number_adverts, v1, Init_price_advert, x, y];
% substitute the last two entries with optimal x and y obtained from Logistic_numerical_optimization.py 
substitution_values = [80000, -0.5, 1.50, 350, -0.01, 250, 2.974550611131228, 218.97158696272078];

dR_dInit_price_subs = subs(diff(R, Init_price_subs), substitution_constants, substitution_values);
dR_dInit_number_subs = subs(diff(R, Init_number_subs), substitution_constants, substitution_values);
dR_dInit_price_advert = subs(diff(R, Init_price_advert), substitution_constants, substitution_values);
dR_dInit_number_adverts = subs(diff(R, Init_number_adverts), substitution_constants, substitution_values);
dR_dv0 = subs(diff(R, v0), substitution_constants, substitution_values);
dR_dv1 = subs(diff(R, v1), substitution_constants, substitution_values);

R_val = subs(R, substitution_constants, substitution_values);


sensitivity_Init_price_subs = (1.5 / R_val) * dR_dInit_price_subs;
sensitivity_Init_number_subs = (80000 / R_val) * dR_dInit_number_subs;
sensitivity_Init_price_advert = (250 / R_val) * dR_dInit_price_advert;
sensitivity_Init_number_adverts = (350 / R_val) * dR_dInit_number_adverts;
sensitivity_v0 = (-0.5 / R_val) * dR_dv0;
sensitivity_v1 = (-0.01 / R_val) * dR_dv1;

%disp(double(sensitivity_Init_price_subs));
%disp(['optimal x = ' num2str(2.974550611131228)]);
%disp(['optimal y = ' num2str(218.97158696272078)]);
%disp(['maximized objective function = ' num2str(243369.07260973746)]);
disp('Sensitivity analysis:');
disp(['Sensitivity of Init_price_subs: ' num2str(double(sensitivity_Init_price_subs))]);
disp(['Sensitivity of Init_number_subs: ' num2str(double(sensitivity_Init_number_subs))]);
disp(['Sensitivity of Init_price_advert: ' num2str(double(sensitivity_Init_price_advert))]);
disp(['Sensitivity of init_number_adverts: ' num2str(double(sensitivity_Init_number_adverts))]);
disp(['Sensitivity of v0: ' num2str(double(sensitivity_v0))]);
disp(['Sensitivity of v1: ' num2str(double(sensitivity_v1))]);

%{
Results:
Non_linear_model_2
optimal x = 2.9746
optimal y = 218.9716
maximized objective function = 243369.0726
Sensitivity analysis:
Sensitivity of Init_price_subs: 0.32103
Sensitivity of Init_number_subs: 0.63283
Sensitivity of Init_price_advert: 0.41487
Sensitivity of init_number_adverts: 0.36338
Sensitivity of v0: -0.31559
Sensitivity of v1: 0.047699
%}





