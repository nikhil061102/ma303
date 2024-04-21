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
% VAM METHOD START
ICost = cost;
X = zeros(size(cost));
[m,n] = size(cost);
BFS = m+n-1;
for i=1:size(cost,1)
    for j=1:size(cost,2)
        col = sort(cost,1);
        row = sort(cost,2);
        pRow = row(:,2) - row(:,1);
        pCol = col(2,:) - col(1,:);
        R = max(pRow);
        C = max(pCol);
        rMax = find(pRow == max(R,C));
        cMax = find(pCol == max(R,C));
        cR = cost(rMax,:);
        cC = cost(:,cMax);
        if max(pRow) ~= max(pCol)
            if max(pRow) > max(pCol)
                [rowind, colind] = find(min(min(cR))==cost(rMax,:));
                row1 = rMax(rowind);
                col1 = colind;
            else
                [rowind, colind] = find(min(min(cC))==cost(:,cMax));
                row1 = rowind;
                col1 = cMax(colind);
            end
            xll = min(A(row1),B(col1));
            [val,ind] = max(xll);
            ii = row1(ind);
            jj = col1(ind);
        else
            [rowind1, colind1] = find(min(min(cR))==cost(rMax,:));
            row1 = rMax(rowind1);
            col1 = colind1;
            c1 = cost(row1,col1);
            [rowind2, colind2] = find(min(min(cC))==cost(:,cMax));
            row2 = rowind2;
            col2 = cMax(colind2);
            c2 = cost(row2,col2);
            if c1 < c2 
                xll = min(A(row1),B(col1));
                [val,ind] = max(xll);
                ii = row1(ind);
                jj = col1(ind);
            else
                xll = min(A(row2),B(col2));
                [val,ind] = max(xll);
                ii = row2(ind);
                jj = col2(ind);
            end
        end
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
% find total cost from vam method 
finalcost = sum(sum(ICost.*X));
fprintf("Total optimal cost is %d.\n",finalcost);