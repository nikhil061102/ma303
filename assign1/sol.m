clc
clear all 
format short 

numVariables = input('Enter the number of variables: ');

numConstraints = input('Enter the number of constraints: ');

fprintf("NOTE : Keep in mind that number of ≤ and ≥ and = constraints should be equal to total number of constraints !\n")
numLessThanConstraints = input('Enter the number of ≤ constraints: ');
numGreaterThanConstraints = input('Enter the number of ≥ constraints: ');
numEqualToConstraints = input('Enter the number of = constraints: ');

BVog = [];
BV = [];
temp = [];

for i = 1:numVariables
    var{i} = ['x', num2str(i)];
    Ovar{i} = ['x', num2str(i)];
end

for i = 1:numLessThanConstraints+numGreaterThanConstraints
    Ovar{end+1} = ['s', num2str(i)];
    var{end+1} = ['s', num2str(i)];
end

for i = 1:numGreaterThanConstraints+numEqualToConstraints
    var{end+1} = ['A', num2str(i)];
end

var{end+1} = 'sol';
Ovar{end+1} = 'sol';

info = [];
numZeros = length(var) - numVariables;

l = numVariables+numLessThanConstraints+numGreaterThanConstraints+1;
if numEqualToConstraints > 0
    fprintf("NOTE : Mention it in form of no.-of-variables-length vector. Add 0s if necessary.\n")
    disp('Enter coefficients and RHS for = constraints:');
    for i = 1:numEqualToConstraints
        equalConstraint = input(['Coefficients for constraint ', num2str(i), ': ']);
        equalConstraint = [equalConstraint, zeros(1, numZeros)];
        equalConstraint(l) = 1;
        BV = [BV l];
        BVog = [BVog l];
        temp = [temp l];
        l = l+1;
        equalRHS = input(['RHS for constraint ', num2str(i), ': ']);
        equalConstraint(end) = equalRHS;
        info = [info; equalConstraint];
    end
end

k = numVariables+1;
if numGreaterThanConstraints > 0
    fprintf("NOTE : Mention it in form of no.-of-variables-length vector. Add 0s if necessary.\n")
    disp('Enter coefficients and RHS for ≥ constraints:');
    for i = 1:numGreaterThanConstraints
        greatConstraint = input(['Coefficients for constraint ', num2str(i), ': ']);
        greatConstraint = [greatConstraint, zeros(1, numZeros)];
        greatConstraint(k) = -1;
        greatConstraint(l) = 1;
        BV = [BV l];
        BVog = [BVog l];
        temp = [temp l];
        l = l+1; k = k+1;
        greatRHS = input(['RHS for constraint ', num2str(i), ': ']);
        greatConstraint(end) = greatRHS;
        info = [info; greatConstraint];
    end
end

if numLessThanConstraints > 0
    fprintf("NOTE : Mention it in form of no.-of-variables-length vector. Add 0s if necessary.\n")
    disp('Enter coefficients and RHS for ≤ constraints:');
    for i = 1:numLessThanConstraints
        lessConstraint = input(['Coefficients for constraint ', num2str(i), ': ']);
        lessConstraint = [lessConstraint, zeros(1, numZeros)];
        lessConstraint(k) = 1;
        BV = [BV k];
        BVog = [BVog k];
        k = k+1;
        lessRHS = input(['RHS for constraint ', num2str(i), ': ']);
        lessConstraint(end) = lessRHS;
        info = [info; lessConstraint];
    end
end

fprintf("\n==========================================================================================");
fprintf("\nArtificial variables :- ");
noOfArt = 0;
for i = 1:numGreaterThanConstraints+numEqualToConstraints
    fprintf("A%d ",i);
    noOfArt = noOfArt + 1;
end
fprintf("\nSlack variables :- ");
for i = numGreaterThanConstraints+1:numLessThanConstraints+numGreaterThanConstraints
    fprintf("s%d ",i);
end
fprintf("\nSurplus variables :- ");
for i = 1:numGreaterThanConstraints
    fprintf("s%d ",i);
end
fprintf("\n==========================================================================================\n");

fprintf("NOTE : Write only 'max' or 'min' for below. Anything else and you will get error. Any error and its your fault, I already mentioned.\n")
problemType = input('Enter the problem type (maximization/minimization): ', 's');
fprintf("NOTE : Mention it in form of no.-of-variables-length vector. Add 0s if necessary.\n")
origC = input('Enter the coefficients of the objective function: ');
origC = [origC, zeros(1, numZeros)];
cost = zeros(1,length(var));
if strcmp(problemType, 'min')
    origC = (-1)*origC;
end
for i = temp
    origC(i) = -1;
    cost(i) = -1;
end

A = info;
startBV = find(cost < 0);

fprintf("\n\t\t\tMax : Z* = ");
for i=1:length(var)-1
    fprintf("+ %f*%s ",origC(i),var{i});
end
fprintf("\n");

fprintf("==========================================================================================\n");
fprintf("======================================== PHASE-I =========================================\n");
fprintf("==========================================================================================\n");

fprintf("\n\t\t\tMax : Z* = ");
for i=1:length(var)-1
    fprintf("+ %f*%s ",cost(i),var{i});
end
fprintf("\n");

[BFS,A] = simp(A,BV,cost,var);
if isempty(BFS)
    return;
end
range_to_check = (length(A) - noOfArt):(length(A) - 1);
if any(ismember(BFS, range_to_check))
    disp('Infeasible question !');
    return;
end

A(:,startBV) = [];
origC(:,startBV) = [];
fprintf("==========================================================================================\n");
fprintf("======================================== PHASE-II ========================================\n");
fprintf("==========================================================================================\n");

fprintf("\n\t\t\tMax : Z* = ");
for i=1:length(Ovar)-1
    fprintf("+ %f*%s ",origC(i),Ovar{i});
end
fprintf("\n");

[optBFS, optA] = simp(A,BFS,origC,Ovar);
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
optimalBFS.Properties.VariableNames(1:size(optimalBFS,2))=Ovar