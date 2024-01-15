function y= all_pass_filter(x,tau,fs)

M= floor(tau*fs);
h=0.7;

m=zeros(M,1);

for i = 1:length(x)
    m(end) = m(end) + (-h)*x(i);
    m=[x(i)*(-h)+h*m(end);m(1:M-1)];
    y(i)=m(end);
end



