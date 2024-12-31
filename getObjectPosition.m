function [object_pos, object_resized] = getObjectPosition(back, left, right, roof, floor, wall, object, rgbImage)
%This function displays the warped wall that is chosen using the variable
%wall. The user can then specify the position of the object by clicking on
%the image. 
% input arguments:  back - backwall
%                   left - warped left wall
%                   right - warped right wall
%                   roof - warped roof
%                   floor - warped floor
%                   wall - integer wall, specifying the wall on which the
%                           object is placed
%                   object - the cropped image of the object
%                   rgbImage - the original rgb Image
% output arguments: object_pos - an array containing the position of the
%                                objects
%                   object_resized - array with images of the objects 
%                                    resized to the right size

%load popup
mBoxIm = msgbox(" ","Position");
set(mBoxIm, 'position', [550 250 400 400]);
delete(findobj(mBoxIm,'string','OK'));
imshow(floor);
mBox = msgbox("Please choose the position of the object");
set(mBox, 'position', [600 500 200 50]);
waitfor(mBox);

%calculate scaling factor
[~, l, ~] = size(rgbImage);
[~, k, ~] = size(back);
sFactor = (k/l)*1.5;

%the wall is selected with the variable "wall" and checked using
%if-statements. Backwall is not considered, as no foreground object should
%be placed on the backwall.
    %floor
    if (wall == 1)
        %show warped floor
        imshow(floor);
        %choose position
        [X, Y, ~] = ginput(1);
        %resize foreground object
        object_resized = imresize(object, sFactor);
        %define object position
        [~, n, ~] = size(object_resized);
        [~, j, ~] = size(floor);
        object_pos(1) = j-X(1)-n;
        object_pos(2) = Y(1);
        object_pos(3) = 0;
    end

    %roof
    if (wall == 2)
        %show warped roof
        imshow(roof);
        %choose position
        [X, Y, ~] = ginput(1);
        %resize foreground object
        object_resized = imresize(object, sFactor);
        %define object position
        [m, ~, ~] = size(object_resized);
        [h, ~, ~] = size(back);
        object_pos(1) = X(1);
        object_pos(2) = Y(1);
        object_pos(3) = h-m;
    end

    %left wall
    if (wall == 3)
        %show warped left wall
        imshow(left);
        %choose position
        [X, Y, ~] = ginput(1);
        %resize foreground object
        object_resized = imresize(object, sFactor);
        %define object position
        [g, j, ~] = size(left);
        object_pos(1) = 0;
        object_pos(2) = j-X(1);
        object_pos(3) = g-Y(1);
    end

    %right wall
    if (wall == 4)
        %show warped right wall
        imshow(right);
        %choose position
        [X, Y, ~] = ginput(1);
        %scale foreground object
        object_resized = imresize(object, sFactor);
        %define object position
        [g, ~, ~] = size(right);
        [~, n, ~] = size(object_resized);
        [~, d, ~] = size(back);
        object_pos(1) =  d-n;
        object_pos(2) = X(1);
        object_pos(3) = g-Y(1);
    end

    %close msgBox
    delete(mBoxIm);
end

