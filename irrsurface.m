%[q_hyp d_instant q_exp q]  = dailyoil();
clear all; close all; 
[q_hyp d_instant q_exp q NGL shrunk_gas t]  = monthlyoil();

%%Test Change

semilogy(t, q, 'g', t, NGL, 'b', t, shrunk_gas, 'r')
hold on 
%semilogy(NGL)
hold on 
%semilogy(shrunk_gas)
title("Monthly Production (IP = 1000 Bbl/Day, Dei = 70%, GOR = 2000scf/Bbl)")
xlabel('Month')
ylabel('Monthly Rate (Bbl/mo, Mcf/mo)')
legend('show')
legend('Oil', 'NGL (Yield = 141 B/MM)', 'Shrunk Gas (Shrink = 0.67)')

fprintf('Monthly oil plotted. Program paused. Press enter to continue.\n');
pause;
NRI = 0.77;
WI = 1; 
price_range = 40:70;
capital_range = 5e6:0.5e6:10e6;
irr_surface = zeros(length(price_range), length(capital_range));

oil_revenue = zeros(length(q),1);
for c = 1:length(capital_range)
	for i = 1:length(price_range)
		oil_revenue = q*price_range(i)*NRI;
		gas_revenue = shrunk_gas * 3 * NRI;
		ngl_revenue = NGL * 0.26 * price_range(i) * NRI;
	capital_vec = zeros(length(q),1);
	capital_vec(1) = capital_range(c)*WI; 

	cf = oil_revenue + gas_revenue + ngl_revenue - capital_vec; 

	irr_surface(i , c) = irr(cf)*100;
	end
end

figure; 
surf(capital_range/1e6, price_range, irr_surface)
title ("Capital/Price IRR Surface")
xlabel('D&C Capital (MM$)')
ylabel('Oil Price ($/Bbl)')
zlabel('IRR (%)')
colorbar; 

fprintf('Return surface plotted. Program paused. Press enter to continue.\n');
pause;

figure 
%plot capital sensitivity
plot(capital_range/1e6,irr_surface(15,:))
title('Capital Sensitivity at $55 Oil')
xlabel('D&C Capital (MM$)')
ylabel('IRR (%)')

fprintf('Capital sensitivty plotted. Program paused. Press enter to continue.\n');
pause;

figure 
%plot price sensitivity
plot(price_range,irr_surface(:,3))
title('Price Sensitivity at $6MM D&C')
xlabel('Price ($/Bbl)')
ylabel('IRR (%)')