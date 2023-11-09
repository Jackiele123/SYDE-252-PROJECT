% SET STUFF
tol = 10e-6;
target = [4 4 4];
vals = [1, 1, 1]; % initial guesses
error = abs(vals - target); % error btwn target and current values

% EQUATIONS
syms J1 J2 forearm
eqs = [(135*sind(J2)+147*cosd(forearm)+59.7)*cosd(J1),...
       (135*sind(J2)+147*cosd(forearm)+59.7)*sind(J1),...
       135*cosd(J2)-147*sind(forearm)];

% SOLVE
for i = 1:3 % iterate so long as convergence criteria is not met

    disp(i);
    s = subs(eqs, [J1, J2, forearm], vals) % sub values
    % FIXME^^^ NOT SET TO WHAT TO SOLVE
    error = target - s; % update error
    
    % break loop if tolerance condition met
    if error < tol
        break;
    end

    % calculate jacobian
    a = diff(eqs(1), J1);
    b = diff(eqs(1), J2);
    c = diff(eqs(1), forearm);

    d = diff(eqs(2), J1);
    e = diff(eqs(2), J2);
    f = diff(eqs(2), forearm);

    g = diff(eqs(3), J1);
    h = diff(eqs(3), J2);
    i = diff(eqs(3), forearm);

    jac = [a b c;
         d e f;
         g h i;];
    jac1 = inv(jac);

    jac_s = subs(jac, [J1 J2 forearm], vals);

    % newton-raphson update method
    % UPDATE VALS NOT THE SYMBOLIC VALUES
    vals(1) = J1 - jac_s(1)\error(1);
    vals(2) = J2 - jac_s(2)\error(2);
    vals(3) = forearm - jac_s(3)\error(3);

    disp(double(error));
end