%%% Read input wave file
[xin,Fs]=audioread('C:\Users\KSB\Desktop\guitar.wav');
Len = Fs*10;
xin = xin(1:Len,1);

%%% Read UC Davis HRIR DB
load small_pinna_final.mat;
% If you load this *.mat file, you will have left(n,iangle) and right(n,iangle)
% where 1 <= n <= 200 is the sample index and iangle is an angle index with
% a resolution of 5 degre. iangle=1 -> 0 degree, iangle=2 -> 5 degrees,
% iangle3 = 10 degrees, ... iangle=72 -> 355 degrees etc

%%% Extract a pair of HRTF corresponding to an angle
angle = 150;
ai = right(:,fix(angle/5)+1);     % Ipsi-lateral path impulse response
ac = left(:,fix(angle/5)+1);      % contra-lateral path impulse response

%% % Extract minimum-phase components using Ceptrum-based method
N = 200;        % order of the FIR filter
ai = ai(1:N,1);
ac = ac(1:N,1);

%% filtering
x_r = zeros(N,1);
x_l = zeros(N,1);
x_r_output = zeros(length(xin),1);
x_l_output = zeros(length(xin),1);

for i = 1:length(xin)
    x_r = [ xin(i); x_r(1:end-1) ];
    x_r_output(i)=ai'*x_r;
    
    x_l = [ xin(i); x_l(1:end-1) ];
    x_l_output(i)=ac'*x_l;
end


output = [x_l_output',x_r_output'];

figure,plot(ai);
hold on,plot(ac);
legend('left','right');
grid on;

sound(output,Fs);

% figure,plot(x_l_output(:,1));
% title('Left Channel');
% xlabel('Time (s)');
% ylabel('Amplitude');