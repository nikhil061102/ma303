function [] = plotLinearInequality(A, B)
    a = A(1, 1);
    b = A(1, 2);
    c = A(2, 1);
    d = A(2, 2);

    p = B(1);
    q = B(2);

    x_range = linspace(0, 10, 500);
    y_range = linspace(0, 10, 500);

    % Create a grid of x and y values
    [x, y] = meshgrid(x_range, y_range);
    
    Z1 = a*x + b*y - p;
    Z2 = c*x + d*y - q;

    % Create an index for the common area where both inequalities are satisfied
    common_area = double((Z1 <= 0) & (Z2 <= 0));
    figure;
    
    contourf(x, y, common_area);
    
    xlabel('x');
    ylabel('y');
    title('Common Area of Two Linear Inequalities');
    colorbar;
    grid on;
end
