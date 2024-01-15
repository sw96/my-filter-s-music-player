function y=comb_filter(x,tau,fs)

D= floor(tau*fs);
g=10^(-3*tau/1.2);

m= zeros(D,1);
for i = 1:length(x)
    m=[x(i) + g*m(end);m(1:D-1)];
    y(i)=m(end);
end