function plotLines(I, inner, outer, vp)
    % plotLines() plots the inner rectangle and the vanishing lines
    % input arguments:  I - image
    %                   inner - struct with inner 4 roi objects
    %                   outer - struct with otuer 4 roi objects
    %                   vp - roi object
    
    
    % overwrite current figure with image
    hold on; imshow(I);
    [h,w,~] = size(I);
    col = [0 0.4470 0.7410]; % colour for plot lines
    
    % plot inner frame & vanishing point
    plot([inner.ul.Position(1) inner.ur.Position(1)], [inner.ul.Position(2) inner.ur.Position(2)], 'color',col, 'linewidth', 5);
    plot([inner.ur.Position(1) inner.lr.Position(1)], [inner.ur.Position(2) inner.lr.Position(2)], 'color',col, 'linewidth', 5);
    plot([inner.lr.Position(1) inner.ll.Position(1)], [inner.lr.Position(2) inner.ll.Position(2)], 'color',col, 'linewidth', 5);
    plot([inner.ll.Position(1) inner.ul.Position(1)], [inner.ll.Position(2) inner.ul.Position(2)], 'color',col, 'linewidth', 5);
    
    % plot inner lines
    plot([inner.ul.Position(1) vp.Position(1)], [inner.ul.Position(2) vp.Position(2)], 'color',col, 'linewidth', 3);
    plot([inner.ur.Position(1) vp.Position(1)], [inner.ur.Position(2) vp.Position(2)], 'color',col, 'linewidth', 3);
    plot([inner.lr.Position(1) vp.Position(1)], [inner.lr.Position(2) vp.Position(2)], 'color',col, 'linewidth', 3);
    plot([inner.ll.Position(1) vp.Position(1)], [inner.ll.Position(2) vp.Position(2)], 'color',col, 'linewidth', 3);
    
    
    % plot outer lines (from rectangle to image border)
    grad = [inner.ll.Position(1) - vp.Position(1), inner.ll.Position(2) - vp.Position(2)]; % compute direction for the line
    len = min(vp.Position(1) / (vp.Position(1) - inner.ll.Position(1)), (h-vp.Position(2)) / (-vp.Position(2)+inner.ll.Position(2))); % compute length of line
    outer.ll.Position = fix(vp.Position + len*grad); % compute outer position
    plot([vp.Position(1) outer.ll.Position(1)], [vp.Position(2) outer.ll.Position(2)], 'color',col, 'linewidth', 3); % plot
    
    
    grad = [inner.lr.Position(1) - vp.Position(1), inner.lr.Position(2) - vp.Position(2)]; % compute direction for the line
    len = min((w-vp.Position(1)) / (-vp.Position(1) + inner.lr.Position(1)), (h-vp.Position(2)) / (-vp.Position(2)+inner.lr.Position(2))); % compute length of line
    outer.lr.Position = fix(vp.Position + len*grad); % compute outer position
    plot([vp.Position(1) outer.lr.Position(1)], [vp.Position(2) outer.lr.Position(2)], 'color',col, 'linewidth', 3);    
    
    grad = [inner.ur.Position(1) - vp.Position(1), inner.ur.Position(2) - vp.Position(2)]; % compute direction for the line
    len = min((w-vp.Position(1)) / (-vp.Position(1) + inner.ur.Position(1)), vp.Position(2) / (vp.Position(2)-inner.ur.Position(2))); % compute length of line
    outer.ur.Position = fix(vp.Position + len*grad); % compute outer position
    plot([vp.Position(1) outer.ur.Position(1)], [vp.Position(2) outer.ur.Position(2)], 'color',col, 'linewidth', 3);
    
    
    grad = [inner.ul.Position(1) - vp.Position(1), inner.ul.Position(2) - vp.Position(2)]; % compute direction for the line
    len = min(vp.Position(1) / (vp.Position(1) - inner.ul.Position(1)), vp.Position(2) / (vp.Position(2)-inner.ul.Position(2))); % compute length of line
    outer.ul.Position = fix(vp.Position + len*grad); % compute outer position
    plot([vp.Position(1) outer.ul.Position(1)], [vp.Position(2) outer.ul.Position(2)], 'color',col, 'linewidth', 3);
    
end