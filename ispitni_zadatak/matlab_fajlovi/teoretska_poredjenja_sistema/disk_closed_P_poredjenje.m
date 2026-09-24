Ts = 0.04; a = 0.87517; b = 0.09986; umax = 125;
fname = 'closed_loop_P_trace.csv';


if exist('readmatrix','file')
    T = readmatrix(fname);
else
    T = csvread(fname, 1, 0);        
end
T = T(all(isfinite(T),2), :);        
assert(size(T,2) >= 3, 'CSV mora imati bar 3 kolone (u, y, r)');

u_plc = T(:,end-2); y_plc = T(:,end-1); r = T(:,end);
N = numel(r); t = (0:N-1)'*Ts;

% --- regulator ---
Kc = 5; Ki = 0; pi_mode = false; arw = true;   % za PI: Kc = 3, Ki = 10, pi_mode = true
ystat = 0; ustat = 0; yout = 0; ui = 0;
y_sim = zeros(N,1); u_sim = zeros(N,1);

for k = 1:N
    e = r(k) - yout;                 % FB1 vidi y iz prethodnog ciklusa
    if pi_mode
        ui = ui + Ki*Ts*e;
        if arw, ui = min(max(ui,0),umax); end
        u = Kc*e + ui;
    else
        u = Kc*e;
    end
    u = min(max(u,0),umax);
    ystat = a*ystat + b*ustat;       % FB_Plant
    yout = ystat; ustat = u;
    y_sim(k) = yout; u_sim(k) = u;
end

fprintf('N = %d, max|dy| = %.4f, RMSE = %.4f\n', N, max(abs(y_sim-y_plc)), sqrt(mean((y_sim-y_plc).^2)));
plot(t,y_plc,t,y_sim,'--'); legend('PLC Trace','Model'); grid on