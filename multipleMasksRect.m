function [mask, object] = multipleMasksRect(rgbImage)
    %this function starts the imrect() function which allows the user to
    %mark the foreground object. The rectangle is then used to create a
    %mask of the object and the foreground object is cropped to the right
    %size. 
    %input arguments:  rgImage - original rgb Image
    %output arguments:  mask - mask of the background without foreground
    %                          objects
    %                   object - cropped object image
    
    %run rectangle function to mark the object
    ROI = drawrectangle();

    %create mask
    mask = ROI.createMask(rgbImage);

    %get coordinates of the mask inside the Image
    %this also works with non rectangular masks!
    structBoundaries = bwboundaries(mask);
    xy=structBoundaries{1}; % Get n by 2 array of x,y coordinates.
    x = xy(:, 2); % Columns.
    y = xy(:, 1); % Rows.

    %remove everything outside of the mask and augment the mask to three channels
    blackMaskedImage = rgbImage;
    rgbMask = mask;
    rgbMask(:,:,2) = rgbMask;
    rgbMask(:,:,3) = rgbMask(:,:,1);
    blackMaskedImage(rgbMask == 0) = 0;

    % Save the coordinates to crop the image
    topLine = min(x);
    bottomLine = max(x);
    leftColumn = min(y);
    rightColumn = max(y);
    width = bottomLine - topLine + 1;
    height = rightColumn - leftColumn + 1;
 
    %now crop the image and save it to object 
    object = imcrop(blackMaskedImage, [topLine, leftColumn, width, height]);

end

