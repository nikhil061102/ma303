clear all
m=input('The number of constraints ');
n=input('The number of variables ');
leq=input('The number of the leq constraints\n');
eq=input('The number of the eq constraints\n');
Obj=input('The objective function coefficients in row matrix form\n');
%geq=input('Enter the number of the geq constraints\n');

if leq>0
    for i=1:leq
        A(i,:)=input('Input the leq constraint in row matrix form\n');
    end
end

if eq>0
    for i=1:eq
        A(leq+i,:)=input('Input the eq constraint in row matrix form\n');
    end
end
Obj=[Obj zeros(1,leq)];
b=A(:,end);
A=A(:,1:end-1);
C=zeros(m,leq);
A=[A C];
for i=1:leq
    A(i,i+n)=1;
end
bs_sol=[];
n1=size(A,2);
ncm=nchoosek(1:n1,m);
for i=1:size(ncm,1)
    x1=zeros(size(A,2),1);
    if inv(A(:,ncm(i,:)))==0
        fprintf("This basis matrix is singular\n");
    else
        fprintf("The Basis matrix is \n");
        disp(A(:,ncm(i,:)));
        fprintf("The corresponding basic solution is \n");
        x=inv(A(:,ncm(i,:)))*b;
        x1(ncm(i,:))=x;
        if sum(x)==sum(abs(x)) && x(1)~=inf
            bs_sol=[bs_sol x1];
            disp(x1);
        end
    end
end
fprintf('Set of all BFS is\n');
%disp(bfs_soln);
disp(bs_sol);
fprintf('Value of the objective functions for each of the BFS are\n');
soln=Obj*bs_sol;
disp(soln);
fprintf('Optimal solution is\n');
[s,ind]=min(soln);
disp(s);
fprintf('For the value of the variables\n');
disp(bs_sol(:,ind));
