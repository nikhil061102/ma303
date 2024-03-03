clc
clear all 
format short 

numVariables = input('Enter the number of variables: ');

numConstraints = input('Enter the number of constraints: ');

fprintf("NOTE : Keep in mind that number of ≤ and ≥ constraints should be equal to total number of constraints !\n")
fprintf("NOTE : The code assumes that ≥ constraints can be converted to ≤ form.\n")
numLessThanConstraints = input('Enter the number of ≤ constraints: ');
numGreaterThanConstraints = input('Enter the number of ≥ constraints: ');

BVog = [];
BV = [];
usage = [];

for i = 1:numVariables
    var{i} = ['x', num2str(i)];
end

for i = 1:numLessThanConstraints+numGreaterThanConstraints
    var{end+1} = ['s', num2str(i)];
end

var{end+1} = 'sol';

A = [];
numZeros = length(var) - numVariables;

l = numVariables+1;
if numLessThanConstraints > 0
    fprintf("NOTE : Mention it in form of no.-of-variables-length vector. Add 0s if necessary.\n")
    disp('Enter coefficients and RHS for ≤ constraints:');
    for i = 1:numLessThanConstraints
        lessConstraint = input(['Coefficients for constraint ', num2str(i), ': ']);
        lessConstraint = [lessConstraint, zeros(1, numZeros)];
        lessConstraint(l) = 1;
        BV = [BV l];
        BVog = [BVog l];
        l = l+1;
        lessRHS = input(['RHS for constraint ', num2str(i), ': ']);
        lessConstraint(end) = lessRHS;
        A = [A; lessConstraint];
    end
end

if numGreaterThanConstraints > 0
    fprintf("NOTE : Mention it in form of no.-of-variables-length vector. Add 0s if necessary.\n")
    disp('Enter coefficients and RHS for ≥ constraints:');
    for i = 1:numGreaterThanConstraints
        greatConstraint = input(['Coefficients for constraint ', num2str(i), ': ']);
        greatConstraint = [(-1)*greatConstraint, zeros(1, numZeros)];
        greatConstraint(l) = 1;
        BV = [BV l];
        BVog = [BVog l];
        l = l+1;
        greatRHS = input(['RHS for constraint ', num2str(i), ': ']);
        if greatRHS > 0
            fprintf("The ≥ constraint could not be converted to ≤ form !\n")
            return;
        end
        greatConstraint(end) = -greatRHS;
        A = [A; greatConstraint];
    end
end

fprintf("NOTE : Write only 'max' or 'min' for below. Anything else and you will get error. Any error and its your fault, I already mentioned.\n")
problemType = input('Enter the problem type (maximization/minimization): ', 's');
fprintf("NOTE : Mention it in form of no.-of-variables-length vector. Add 0s if necessary.\n")
origC = input('Enter the coefficients of the objective function: ');
origC = [origC, zeros(1, numZeros)];
cost = zeros(1,length(var));
if strcmp(problemType, 'min')
    origC = (-1)*origC;
end

startBV = find(cost < 0);

fprintf("\n\t\t\tMax : Z* = ");
for i=1:length(var)-1
    fprintf("+ %f*%s ",origC(i),var{i});
end
fprintf("\n");

[optBFS,optA] = simp(A,BV,origC,var);
if isempty(optBFS)
    return;
end
FINAL_BFS = zeros(1,size(A,2));
FINAL_BFS(optBFS) = optA(:,end);
FINAL_BFS(end) = sum(FINAL_BFS.*origC);
if strcmp(problemType, 'min')
    FINAL_BFS(end) = (-1)*FINAL_BFS(end);
end
optimalBFS = array2table(FINAL_BFS);
optimalBFS.Properties.VariableNames(1:size(optimalBFS,2))=var