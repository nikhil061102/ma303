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
% NW CORNER METHOD START
X = (-1)*ones(size(cost));
[m,n] = size(cost);
BFS = m+n-1;
i = 1; j = 1;
l = 0;
while(l < BFS)
    if(A(i) <= B(j))
        X(i,j) = A(i);
        B(j) = B(j) - A(i);
        i = i+1;
        l = l+1;
    elseif (B(j) < A(i))
        X(i,j) = B(j);
        A(i) = A(i) - B(j);
        j = j+1;
        l = l+1;
    else
        break;
    end
end
fprintf("This is the allocation matrix X:\n");
fprintf("-1 indicates not taken, 0 indicates zero amount to be taken, and positive values indicate the amount taken.\n");
disp(X)
% find total cost from north west method 