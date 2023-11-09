function vals = gauss_seidel_w(a, b, vars, vals, tol, w)
%GAUSS_SEIDEL Finds approximate solutions using Gauss Seidel method
%   Takes input matrices, variables involved, initial values, a
%   tolerance, and relaxation values. Returns updated values as solution upon convergence

% matrix multiplication with the inputted matrices
matrix_mult = a*vars == b;
% get equations from the matrix multiplication
eqs = simplify(matrix_mult);
for i = 1:height(eqs)
    % rearrange each equation to the form i1 = ..., i2 = ..., etc.
    eqs(i) = solve(eqs(i), vars(i));
end

iter = 0;
convergence_bool = 0;
while convergence_bool == 0 % iterate so long as convergence criteria is not met
    iter = iter + 1; % increment iteration
    prev_vals = vals; % set previous values to current values before updating current values for later comparison
    for i = 1:height(eqs) % iterate through equations
        % substitute current values in place of the variables and solve
        s = subs(eqs(i), vars, vals);
        vals(i) = w*s + (1-w)*vals(i); % apply relaxation parameter
    end
    error = abs(prev_vals - vals);
    if error < tol
        convergence_bool = 1; % convergence is true if error is within tolerance
    end
    fprintf('iter: %d | convergence = %d \nerror:\n', [iter, convergence_bool])
    disp(error);
end
fprintf('Converged in %d iterations \nSolution:\n', iter);
disp(vals)

% verify
fprintf('----- Verify -----\n')
for i = 1:height(eqs)
    fprintf('i%d = %f = ', i, vals(i));
    disp(eqs(i));
    fprintf('= %f\n-------------------\n', subs(eqs(i), vars, vals));
end

end

