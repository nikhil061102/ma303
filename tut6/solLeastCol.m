% wrong code
% Define the cost matrix
cost = [20 25 30 10; 
        15 20 15 30; 
        25 25 20 35];

% Define supply and demand arrays
supply = [30 40 20];
demand = [25 35 30 20];

% Check if balanced or not
if(sum(supply) == sum(demand))
    fprintf("Given Problem is balanced.\n")
else
    fprintf("Given Problem is unbalanced.\n")
    if (sum(supply) < sum(demand))
        cost(end+1,:) = zeros(1,size(demand,2));
        supply(end+1) = sum(demand) - sum(supply);
    else
        cost(:,end+1) = zeros(1,size(supply,2));
        demand(end+1) = sum(supply) - sum(demand);
    end
end

% Perform the least cost column method
while any(supply) && any(demand)
    % Find the minimum cost in each column
    minCosts = min(cost, [], 1);
    [~, minColIndex] = min(minCosts);
    
    % Find the minimum cost cell in the selected column
    [minRow, ~] = find(cost(:, minColIndex) == minCosts(minColIndex), 1);
    
    % Determine the amount to allocate
    amount = min(supply(minRow), demand(minColIndex));
    
    % Update allocation and adjust supply/demand
    X(minRow, minColIndex) = amount;
    supply(minRow) = supply(minRow) - amount;
    demand(minColIndex) = demand(minColIndex) - amount;
    
    % Set the cost of allocated cells to a high value
    cost(minRow, minColIndex) = Inf;
end

% Display the allocation matrix
disp("Allocation Matrix (Least Cost Column Method):");
disp(X);