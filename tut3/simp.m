function [BFS,A] = simp(A,BV,cost,var)
    BFS = [];
    ZjCj = cost(BV)*A - cost;
    
    Table = array2table([ZjCj;A]);
    Table.Properties.VariableNames(1:size(A,2))=var

    RUN = true;
    while RUN 
        Zc = ZjCj(1,1:end-1);
     
        if any(Zc < 0)
            [EnterCol, pvt_col] = min(Zc);
            
            sol = A(:,end);
            column = A(:,pvt_col);
            if column < 0
                fprintf('Unbounded LPP !!\n');
                return;
            else
                for i = 1:size(A,1)
                    if column(i) > 0
                        ratio(i) = sol(i)./column(i);
                    else
                        ratio(i) = inf;
                    end
                end
                [min_ratio, pvt_row] = min(ratio);
                fprintf('Entering Column = %d & Leaving Row = %d\n',pvt_col,pvt_row);
            end
        
            BV(pvt_row) = pvt_col;
            pvt_key = A(pvt_row,pvt_col);
        
            A(pvt_row,:) = A(pvt_row,:)./pvt_key;
            for i=1:size(A,1)
                if i~=pvt_row
                    A(i,:) = A(i,:)-A(i,pvt_col).*A(pvt_row,:);
                end
            end
            ZjCj = ZjCj-ZjCj(pvt_col).*A(pvt_row,:);
        
            Table = array2table([ZjCj;A]);
            Table.Properties.VariableNames(1:size(A,2))=var
        else
            RUN = false;
            fprintf('The phase has been finished ! \n');
            BFS = BV;
        end
    end
end