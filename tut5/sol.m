clc
clear all
format long

vars = {'x1','x2','x3','s1','s2','sol'};
cost = [-2 0 -1 0 0 0];
info = [-1 -1 1; -1 2 -4];
b = [-5 ; -8];

% vars = {'x1','x2','s1','s2','sol'};
% cost = [-5 -6 0 0 0];
% info = [-1 -1; -4, -1];
% b = [-2 ; -4];
s = eye(size(info,1));
A = [info s b];

BV = [];
for j = 1:size(s,2)
    for i= 1:size(A,2)
        if A(:,i) == s(:,j)
            BV = [BV i];
        end
    end
end
fprintf("Basic Variables (BV) :");
disp(vars(BV));

B = A(:,BV);
A = inv(B)*A;
zjcj = cost(BV)*A - cost;

zcj = [zjcj; A];
simplexTable = array2table(zcj);
simplexTable.Properties.VariableNames(1:size(zcj,2)) = vars

RUN = true;
while RUN
    SOL = A(:,end);
    if any(SOL < 0)
        fprintf("The current BFS is NOT feasible !\n");
       
        [LeaveVal, pvt_row] = min(SOL);
        fprintf("Leaving row is %d\n",pvt_row);
        ROW = A(pvt_row,1:end-1);
        zj = zjcj(:,1:end-1);
       
        for i=1:size(ROW,2)
            if ROW(i) < 0
                ratio(i) = abs(zj(i)./ROW(i));
            else
                ratio(i) = inf;
            end
        end
        [EnterVal, pvt_col] = min(ratio);
        fprintf("Entering col is %d\n",pvt_col);
       
        BV(pvt_row) = pvt_col;
        fprintf("Basic Variables (BV) :");
        disp(vars(BV));
       
        pvt_key = A(pvt_row,pvt_col);
        A(pvt_row,:) = A(pvt_row,:)./pvt_key;
       
        for i= 1: size(A,1)
            if i ~= pvt_row
                A(i,:) = A(i,:) - A(i,pvt_col).*A(pvt_row,:);
            end
        end
        zjcj = cost(BV)*A - cost;
       
        zcj = [zjcj; A];
        simplexTable = array2table(zcj);
        simplexTable.Properties.VariableNames(1:size(zcj,2)) = vars

    else        
        fprintf("The current BFS is feasible & optimal !\n");
        RUN = false;
    end
end

FINAL_BFS = zeros(1,size(A,2));
FINAL_BFS(BV) = A(:,end);
FINAL_BFS(end) = sum(FINAL_BFS.*cost);

optiBFS = array2table(FINAL_BFS);
optiBFS.Properties.VariableNames(1:size(optiBFS,2))=vars