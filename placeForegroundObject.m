function [] = placeForegroundObject(object, object_pos, counter, w)
%Places the foreground objects 
% input arguments:  object_pos - an array containing the position of the
%                                objects
%                   object - array with images of the objects 
%                            resized to the right size
%                   counter - amount of objects
%                   w - integer specifying the wall of the object

%loop through objects
for obj = 1:1:counter
        %assign variables
        object_temp = object{w, obj};
        object_pos_temp = object_pos{w, obj};

        %if object empty, go to next step
        if (isempty(object_temp))
            continue;
        elseif (isempty(object_pos_temp))
            continue;
        end

        %determine size of object
        [m,n,~] = size(object_temp);

        %flip object facing the right way
        object_temp = flip(object_temp);

        %plot the object
        Y = [-object_pos_temp(2) -object_pos_temp(2); -object_pos_temp(2) -object_pos_temp(2)];
        X = [(-1+object_pos_temp(1)) (n+object_pos_temp(1)); (-1+object_pos_temp(1)) (n+object_pos_temp(1))];
        Z = [(-1+object_pos_temp(3)) (-1+object_pos_temp(3)); (m+object_pos_temp(3)) (m+object_pos_temp(3))];
        surface(X, Y, Z, 'FaceColor', 'texturemap','EdgeColor', 'none','CData', object_temp);
end

end

