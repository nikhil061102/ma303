format short 

table = [
    0     2     0      1.5    0     2     0     17.5;
    1     1     0     0.25    0     0     0     1.25;
    0     7     0     0.25    1     0     0     6.25;
    0     2     1     0.25    0     1     0     6.25;
    0     0     0    -0.25    0     0     1     -0.25
];

if any(table(:,end) < 0)
    [val, colpos] = min(table(:,end));
    rA = table(1,1:end-1);
    rB = table(colpos,1:end-1);
    for i=1:size(rA,2)
        if rA(i) > 0
            ratio(i) = abs(rA(i)./rB(i));
        else
            ratio(i) = Inf;
        end
    end
    [val, rowpos] = min(ratio);
    pivotval = table(colpos,rowpos);
    table(colpos,:) = table(colpos,:)./pivotval;
    for i=1:size(table,1)
        if i ~= colpos
            val = table(i,rowpos);
            table(i,:) = table(i,:) - val*table(colpos,:);
        end
    end
    table
else
    fprintf("done");
    A
end