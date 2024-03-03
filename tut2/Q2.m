clc
clear all 
format short 

numVariables = input('Enter the number of variables (n): ');

numConstraints = input('Enter the number of constraints (m): ');

fprintf("NOTE : Keep in mind that number of ≤ and ≥ and = constraints should be equal to total number of constraints !\n")
numLesserThanConstraints = input('Enter the number of ≤ constraints: ');
numGreaterThanConstraints = input('Enter the number of ≥ constraints: ');
numEqualToConstraints = input('Enter the number of = constraints: ');

equalConstraints = [];
if numEqualToConstraints > 0
    disp('Enter coefficients and RHS for = constraints:');
    for i = 1:numEqualToConstraints
        equalConstraint = input(['Coefficients for constraint ', num2str(i), ': ']);
        equalRHS = input(['RHS for constraint ', num2str(i), ': ']);
        equalConstraint = [equalConstraint equalRHS];
        equalConstraints = [equalConstraints; equalConstraint];
    end
end
lessConstraints = [];
if numLesserThanConstraints > 0
    disp('Enter coefficients and RHS for ≤ constraints:');
    for i = 1:numLesserThanConstraints
        lessConstraint = input(['Coefficients for constraint ', num2str(i), ': ']);
        lessRHS = input(['RHS for constraint ', num2str(i), ': ']);
        lessConstraint = [lessConstraint lessRHS];
        lessConstraints = [lessConstraints; lessConstraint];
    end
end
greatConstraints = [];
if numGreaterThanConstraints > 0
    disp('Enter coefficients and RHS for ≥ constraints:');
    for i = 1:numGreaterThanConstraints
        greatConstraint = input(['Coefficients for constraint ', num2str(i), ': ']);
        greatRHS = input(['RHS for constraint ', num2str(i), ': ']);
        greatConstraint = [greatConstraint greatRHS];
        greatConstraints = [greatConstraints; greatConstraint];
    end
end

v = input('Enter the vector v in R^n: ');
flag = true;

if numEqualToConstraints > 0
    for i = 1:numEqualToConstraints
        coeff = equalConstraints(i,1:end-1);
        rhs = equalConstraints(i,end);
        
        if coeff*v' ~= rhs
            flag = false;
            fprintf("Failed at = constraints no. %d\n",i);
            for j = 1:numVariables
                fprintf("+ %f*%f ",coeff(i),v(i));
            end
            fprintf("= %f != %f\n",coeff*v',rhs);
        end
    end
end
if numLesserThanConstraints > 0
    for i = 1:numLesserThanConstraints
        coeff = lessConstraints(i,1:end-1);
        rhs = lessConstraints(i,end);
        
        if coeff*v' > rhs
            flag = false;
            fprintf("Failed at ≤ constraints no. %d\n",i);
            for j = 1:numVariables
                fprintf("+ %f*%f ",coeff(j),v(j));
            end
            fprintf("= %f > %f\n",coeff*v',rhs);
        end
    end
end
if numGreaterThanConstraints > 0
    for i = 1:numGreaterThanConstraints
        coeff = greatConstraints(i,1:end-1);
        rhs = greatConstraints(i,end);
        
        if coeff*v' < rhs
            flag = false;
            fprintf("Failed at ≥ constraints no. %d\n",i);
            for j = 1:numVariables
                fprintf("+ %f*%f ",coeff(j),v(j));
            end
            fprintf("= %f < %f\n",coeff*v',rhs);
        end
    end
end

if(flag)
    fprintf("Yes, v is indeed a feasible soln to the set of inequalities!\n");
else 
    fprintf("Hence, v is not a feasible soln to the set of inequalities!\n");
end