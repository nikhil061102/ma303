% Take input for matrix A
disp('Make a MATLAB code that takes C, A, and b as input. First convert the LPPs in max Z = Ct*x subject to A*x ≤ b form with x ≥ 0');

A = input('Enter the 2x2 matrix A: ');

b = input('Enter the 2x1 vector b: ');

% Call the plotLinearInequality function with user-provided A and B
plotLinearInequality(A, b);

A = [A; -eye(2)];
b = vertcat(b, [0; 0]);
C = input('Enter the 2x1 vector C: ');
[x, fval, exitflag] = linprog(-C, A, b);

% Check if a solution is found
if exitflag == 1
    fprintf('Optimal point is: x = [%f; %f]\n', x);
    fprintf('Optimal value is: %f\n', -fval);
else
    fprintf('No solution possible.\n');
end