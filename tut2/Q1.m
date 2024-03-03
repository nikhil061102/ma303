% for reference : https://www.youtube.com/watch?v=hAQLeBSeKRY
n = input('Enter the number of variables: ');
m = input('Enter the number of constraints: ');
A = [];
b = [];
for i=1:m
    equalConstraint = input(['Coefficients for constraints ', num2str(i), ': ']);
    A = [A; equalConstraint]; % coeff matrix
    rhsConstraint = input(['RHS for constraint ', num2str(i), ': ']);
    b = [b; rhsConstraint]; % constraint rhs values
end  
c = input(['Coefficients for linear objective function : ']);

f = @(X) c*X;
C= nchoosek(n,m); % calc nCm
D = nchoosek(1:n,m); % compute all combinations
fs=[]; % all feasible solns
ifs=[]; % all infeasible solns
z = [];
for i=1:C
    X= zeros(n,1); % initial solution matrix
    index = D(i,:); % 
    B = [];
    for j=1:m
        B = [B A(:,index(j))];
    end
    Y = inv(B)*b;
    X(index) = Y;
    if(X >= 0)
        fs = [fs X];
        z = [z f(X)];
    else 
        ifs = [ifs X];
    end
end
fprintf("So all feasible soln and their respective z values are :-\n");
for i=1:length(z)
    fprintf("%d) ",i)
    fprintf("X is")
    disp(fs(:,i).')
    fprintf("and z = %f\n\n",z(i));
end

[vmin,rmin] = min(z);
fprintf("Finally min z is at ")
disp(fs(:,rmin).')
fprintf("and z = %f\n\n",vmin);

[vmax,rmax] = max(z);
fprintf("Finally max z is at ")
disp(fs(:,rmax).')
fprintf("and z = %f\n\n",vmax);