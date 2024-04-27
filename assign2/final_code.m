clc;
clear all;

check = input("Enter whether it is minimization (press 0) or maximization (press 1) problem in assignment problem : ");
cost_mat = input("Enter costMatrix : ");
disp("Intial entered cost matrix : ")
disp(cost_mat)

[num_sources, num_destinations] = size(cost_mat);
if num_sources ~= num_destinations
    % Add dummy rows or columns to make the matrix square
    max_dim = max(num_sources, num_destinations);
    if num_sources < max_dim
        % Add dummy rows
        cost_mat = [cost_mat; zeros(max_dim - num_sources, num_destinations)];
    elseif num_destinations < max_dim
        % Add dummy columns
        cost_mat = [cost_mat, zeros(num_sources, max_dim - num_destinations)];
    end
    disp("Modified cost matrix for unbalanced assignment problem:");
    disp(cost_mat);
end

if(check == 1)
    cost_mat = max(cost_mat(:)) - cost_mat;
    disp("Altered cost matrix for maximization problem : ")
    disp(cost_mat)
end
cost_mat_copy = cost_mat;
n = size(cost_mat,1);

for i=1:size(cost_mat_copy,1)
    cost_mat_copy(i,:) = cost_mat_copy(i,:)-min(cost_mat_copy(i,:));
end
for i=1:size(cost_mat_copy,2)
    cost_mat_copy(:,i) = cost_mat_copy(:,i)-min(cost_mat_copy(:,i));
end

disp('After subtracting row minimum and column minimum');
disp(cost_mat_copy);

uncoveredZeroes = zeros(1,2*n); % first half for R & second for C
lines = zeros(1,2*n); % first half for R & second for C

while sum(lines) <= n
    for i = 1:n 
        for j = 1:n
            if cost_mat_copy(i,j) == 0
                uncoveredZeroes(i) = uncoveredZeroes(i) + 1;
                uncoveredZeroes(j+n) = uncoveredZeroes(j+n) + 1;
            end
        end
    end
    while any(uncoveredZeroes(:) > 0)
        max_val = max(uncoveredZeroes);
        first_max_index = find(uncoveredZeroes == max_val, 1);
        lines(first_max_index) = 1;
        if sum(lines) > n
            break
        end
        uncoveredZeroes(first_max_index) = 0;
        if first_max_index <= n
            zeros_indices = find(cost_mat_copy(first_max_index,:) == 0);
            for i=zeros_indices
                uncoveredZeroes(i+n) = uncoveredZeroes(i+n) - 1;
            end
        else
            zeros_indices = find(cost_mat_copy(:,first_max_index-n) == 0);
            for i=zeros_indices
                uncoveredZeroes(i) = uncoveredZeroes(i) - 1;
            end
        end
    end

    if sum(lines) < n
        temp = cost_mat_copy;
        line_index = find(lines == 1);
        for i=line_index
            if i > n
                temp(:,i-n) = Inf;
            else
                temp(i,:) = Inf;
            end
        end
        min_to_be_sub = min(temp(:));
        rowsLine = line_index(line_index <= n);
        colsLine = line_index(line_index > n);
        colsLine = colsLine - n;
   
        uvector = min_to_be_sub*ones(1,n);
        vvector = zeros(1,n);
        for i=rowsLine
            uvector(i) = 0;
        end
        for i=colsLine
            vvector(i) = -min_to_be_sub;
        end
        disp("Dual variables (ui & vj) :- ")
        disp("Vector associated with ui :-")
        disp(uvector);
        disp("Vector associated with vj :-")
        disp(vvector);
        [ColsLine, RowsLine] = meshgrid(colsLine, rowsLine);  
        cartesianProduct = [RowsLine(:), ColsLine(:)];
        temp(find(temp ~= Inf)) = -min_to_be_sub;
        temp(find(temp == Inf)) = 0;
        for i = 1:size(cartesianProduct, 1)  
            temp(cartesianProduct(i, 1), cartesianProduct(i, 2)) = min_to_be_sub;  
        end
        cost_mat_copy = cost_mat_copy + temp

    else
        break
    end
end

% Transform the matrix to boolean matrix (0 = True, others = False)
cur_mat = cost_mat_copy;
zero_bool_mat = (cur_mat == 0);
zero_bool_mat_copy = zero_bool_mat;

% Recording possible answer positions by marked_zero
marked_zero = [];
while any(zero_bool_mat_copy(:))
    min_row = [99999, -1];

    for row_num = 1:size(zero_bool_mat_copy, 1)
        if sum(zero_bool_mat_copy(row_num, :) == true) > 0 && min_row(1) > sum(zero_bool_mat_copy(row_num, :) == true)
            min_row = [sum(zero_bool_mat_copy(row_num, :) == true), row_num]
        end
    end

    % Mark the specific row and column as False
    zero_index = find(zero_bool_mat_copy(min_row(2), :) == true, 1);
    marked_zero = [marked_zero; [min_row(2), zero_index]];
    zero_bool_mat_copy(min_row(2), :) = false;
    zero_bool_mat_copy(:, zero_index) = false;
end

% Recording the row and column positions separately
marked_zero_row = marked_zero(:, 1);
marked_zero_col = marked_zero(:, 2);

% Step 2-2-1
non_marked_row = setdiff(1:size(cur_mat, 1), marked_zero_row);

marked_cols = [];
check_switch = true;
while check_switch
    check_switch = false;
    for i = 1:numel(non_marked_row)
        row_array = zero_bool_mat(non_marked_row(i), :);
        for j = 1:numel(row_array)
            % Step 2-2-2
            if row_array(j) == true && ~ismember(j, marked_cols)
                % Step 2-2-3
                marked_cols = [marked_cols, j];
                check_switch = true;
            end
        end
    end

    for k = 1:size(marked_zero, 1)
        % Step 2-2-4
        if ~ismember(marked_zero(k, 1), non_marked_row) && ismember(marked_zero(k, 2), marked_cols)
            % Step 2-2-5
            non_marked_row = [non_marked_row, marked_zero(k, 1)];
            check_switch = true;
        end
    end
end

% Step 2-2-6
marked_rows = setdiff(1:size(cost_mat_copy, 1), non_marked_row);

for i = 1:size(marked_zero, 1)
    correctAssignment(marked_zero(i, 1), marked_zero(i, 2)) = 1;
end

% Display the correctAssignment matrix
disp("Assignment for the given problem is :-")
disp(correctAssignment);
fprintf("\nSo optimal value is : %d\n",sum(sum(correctAssignment.*cost_mat)));
disp("Here NaN means 0 but it is used to show non-basic solutions.")
transportation_matrix = correctAssignment;
transportation_matrix(transportation_matrix == 0) = NaN

fprintf("For initial non-degenerate solution, we can add 'n-1' ie %d here 0s to any particular column or row. We chooose 1st column here", n-1)
for i=1:n
    if transportation_matrix(i,1) ~= 1
        transportation_matrix(i,1) = 0;
    end
end
transportation_matrix
disp("Now solving for dual variables for the associated transportation problem :-");

% Initialize u and v with zeros (you can choose other initial values)
u = zeros(n, 1);
v = zeros(n, 1);
MAX_ITER = 1000;  % Maximum number of iterations
EPSILON = 1e-6;   % Convergence threshold

for iter = 1:MAX_ITER
    prev_u = u;
    prev_v = v;
    
    % Update u based on v and the transportation matrix
    for i = 1:size(cost_mat, 1)
        non_nan_indices = find(~isnan(transportation_matrix(i, :)));
        if ~isempty(non_nan_indices)
            u(i) = cost_mat(i, non_nan_indices(1)) - v(non_nan_indices(1));
        end
    end
    
    % Update v based on u and the transportation matrix
    for j = 1:size(cost_mat, 2)
        non_nan_indices = find(~isnan(transportation_matrix(:, j)));
        if ~isempty(non_nan_indices)
            v(j) = cost_mat(non_nan_indices(1), j) - u(non_nan_indices(1));
        end
    end
    
    % Check for convergence
    if max(abs(prev_u - u)) < EPSILON && max(abs(prev_v - v)) < EPSILON
        break;
    end
end

disp('u:');
disp(u);
disp('v:');
disp(v');
