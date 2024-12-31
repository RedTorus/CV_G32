function dragPointLogic(tag, inner, vp)
    % dragPointLogic moves the roi points of the inner rectangle in a
    % consistent way
    % input arguments:  tag - event tag, which point was moved
    %                   inner - struct with inner 4 roi objects
    %                   vp - roi object
    
    
    switch(tag)
        % upper left
        case{'ul'}
            inner.ur.Position(2) = inner.ul.Position(2);
            inner.ll.Position(1) = inner.ul.Position(1);
            
            % keep vp inside box
            if inner.ul.Position(1) > vp.Position(1)
                vp.Position(1) = inner.ul.Position(1);
            elseif inner.ul.Position(2) > vp.Position(2)
                vp.Position(2) = inner.ul.Position(2);
            end
            
        % upper right
        case{'ur'}
            inner.ul.Position(2) = inner.ur.Position(2);
            inner.lr.Position(1) = inner.ur.Position(1);
            
            % keep vp inside box
            if inner.ur.Position(1) < vp.Position(1)
                vp.Position(1) = inner.ur.Position(1);
            elseif inner.ur.Position(2) > vp.Position(2)
                vp.Position(2) = inner.ur.Position(2);
            end
            
        % lower right
        case{'lr'}
            inner.ll.Position(2) = inner.lr.Position(2);
            inner.ur.Position(1) = inner.lr.Position(1);
            
            % keep vp inside box
            if inner.lr.Position(1) < vp.Position(1)
                vp.Position(1) = inner.lr.Position(1);
            elseif inner.lr.Position(2) < vp.Position(2)
                vp.Position(2) = inner.lr.Position(2);
            end
            
        % lower left
        case{'ll'}
            inner.lr.Position(2) = inner.ll.Position(2);
            inner.ul.Position(1) = inner.ll.Position(1);
            
            % keep vp inside box
            if inner.ll.Position(1) > vp.Position(1)
                vp.Position(1) = inner.ll.Position(1);
            elseif inner.ll.Position(2) < vp.Position(2)
                vp.Position(2) = inner.ll.Position(2);
            end
            
        % vanishing point
        case{'vp'}
            if vp.Position(1) > inner.ur.Position(1)
                vp.Position(1) = inner.ur.Position(1);
            elseif vp.Position(1) < inner.ul.Position(1)
                vp.Position(1) = inner.ul.Position(1);
            elseif vp.Position(2) > inner.lr.Position(2)
                vp.Position(2) = inner.lr.Position(2);
            elseif vp.Position(2) < inner.ur.Position(2)
                vp.Position(2) = inner.ur.Position(2);
            end
            
    end
end