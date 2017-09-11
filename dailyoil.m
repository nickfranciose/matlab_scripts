function  [q_hyp d_instant q_exp q]  = dailyoil()
% Decline Curve function

qi = 809.45775;
b = 1.3; 
di = .829613; 
a = 1/b * ((1-di).^(-b) - 1); 


t = 0:50*365;
q_hyp = zeros(length(t),1);
d_instant = zeros(length(t),1);

%Calculate oil rate for hyperbolic curve

for i = 1:length(t)
	q_hyp(i) = qi/((1 + b * a * t(i)/365).^(1/b));
end

%Calculate instantaneous decline

for i = 1:length(t)-1
	d_instant(i)  = (1 - (q_hyp(i+1)/q_hyp(i)))*36500;
end




%find index of d_instant where decline drops below 6%

exp_q =d_instant <6;
end_of_hyp_index = length(exp_q)-sum(exp_q);

q_exp = zeros(length(t),1);

% Get initial daily rate of exponential period
qi_exp = q_hyp(end_of_hyp_index); 

exp_t = 1:sum(exp_q);

a_exp = -log(1-0.06/365);


for i = 1:sum(exp_q)
	q_exp(i+end_of_hyp_index) = qi_exp*exp(-a_exp*exp_t(i)); 
end


%Return Oil rate for both hyperbolic and exponential periods

q = q_hyp;

for i = (end_of_hyp_index+1):length(t)
	q(i) = q_exp(i);
end


