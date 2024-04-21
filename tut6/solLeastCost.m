cost = [10 10 10 10;
        10 10 10 10;
        10 10 10 10];
A = [10 10 10];
B = [10 10 10 10];

% Check if balanced or not
if(sum(A) == sum(B))
    fprintf("Given Problem is balanced.\n")
else
    fprintf("Given Problem is unbalanced.\n")
    if (sum(A) < sum(B))
        cost(end+1,:) = zeros(1,size(B,2));
        A(end+1) = sum(B) - sum(A);
    else
        cost(:,end+1) = zeros(1,size(A,2));
        B(end+1) = sum(A) - sum(B);
    end
    fprintf("This is new cost matrix :-\n");
    disp(cost);
    fprintf("This is new A vector :-\n");
    disp(A');
    fprintf("This is new B vector :-");
    disp(B);
end
% LEAST COST METHOD START
ICost = cost;
X = zeros(size(cost));
[m,n] = size(cost);
BFS = m+n-1;
for i=1:size(cost,1)
    for j=1:size(cost,2)
        hh = min(cost(:));
        [rowmin, colmin] = find(hh==cost);
        xll = min(A(rowmin),B(colmin));
        [val,ind] = max(xll);
        ii = rowmin(ind);
        jj = colmin(ind);
        yll = min(A(ii),B(jj));
        X(ii,jj) = yll;
        A(ii) = A(ii) - yll;
        B(jj) = B(jj) - yll;
        cost(ii,jj) = Inf;
    end
end
fprintf("This is the allocation matrix X:\n");
fprintf("0 indicates zero amount to be taken, and positive values indicate the amount taken.\n");
disp(X)
% degen or non-degen
totalBFS = length(nonzeros(X));
if(totalBFS == BFS)
    fprintf("Given solution is non-degenerate as no. of BFS inn final solution is %d, which is = %d + %d - 1 i.e. %d\n", totalBFS, size(ICost,1), size(ICost,2), size(ICost,1)+size(ICost,2)-1);
else
    fprintf("Given solution is non-degenerate as no. of BFS inn final solution is %d, which is < %d + %d - 1 i.e. %d\n", totalBFS, size(ICost,1), size(ICost,2), size(ICost,1)+size(ICost,2)-1);
end
% find total cost from least cost method 
finalcost = sum(sum(ICost.*X));
fprintf("Total optimal cost is %d.\n",finalcost);