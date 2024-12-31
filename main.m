% Graphic User Interface for Tour Into the Picture

% Group 32
% Simon Wallner, Kaustabh Paul, Luca Obwegs, Mohamed Fares Sahli, Malik Mandhouj

% - - - - - - - - - - - - - -


close all; clear; clc;

global app
app.rotateZoom = 0;
%foreground object variables
app.wall = "floor"; %standard position of foreground object
app.object = cell(4, 100); %cell array to save objects with maximum size of 100. 1->wall, 2->number
app.object_position = cell(4, 100); %cell array to save object positions with maximum size of 100. 1->wall, 2->number
app.object_counter = 0;

app.window = figure('units','pixels',...
        'position',[100 100 1000 600],...
        'menubar','none',...
        'name','TIP - Computer Vision Project 2022',...
        'numbertitle','off',...
        'resize','off');
    
app.info = uicontrol('style','tex',...
                 'unit','pix',...
                 'position',[40 20 220 100],...
                 'fontsize',12,... 
                 'string','Welcome to the TIP software! To start, please select your favourite image with the ''import image'' button.');
% 'fontweight','bold'

app.chooseWall = uicontrol('style','popupmenu',...
        'unit','pix',...
        'position',[20 495 120 30],...
        'string','Choose wall');
app.chooseWall.String = {'Floor', 'Roof', 'Left Wall', 'Right Wall'};
app.wall = app.chooseWall.Value;

app.importButton = uicontrol('style','push',...
        'unit','pix',...
        'position',[20 540 120 30],...
        'string','Import 2D image');

app.chooseForegroundObject = uicontrol('style','push',...
        'unit','pix',...
        'position',[140 500 120 30],...
        'string','Choose foreground object');
app.chooseForegroundObject.Enable = 'off';
 
app.show3DimageButton = uicontrol('style','push',...
        'unit','pix',...
        'position',[20 460 120 30],...
        'string','Show 3D image');
    
app.rotateButton = uicontrol('style','push',...
        'unit','pix',...
        'position',[140 460 50 30],...
        'string','Rotate');

app.zoomButton = uicontrol('style','push',...
        'unit','pix',...
        'position',[185 460 50 30],...
        'string','Zoom',...
        'ForegroundColor', [0.5 0.5 0.5]);
    
app.axes = axes('units','pixels',...
            'position',[300 50 650 520]);

set(app.chooseWall,'callback',{@chooseWall})
set(app.importButton,'callback',{@importImage})
set(app.chooseForegroundObject,'callback',{@chooseForegroundObject})
set(app.show3DimageButton,'callback',{@show3Dimage})
set(app.rotateButton,'callback',{@rotateOn})
set(app.zoomButton,'callback',{@zoomOn})

function importImage(varargin)
    global app    

    %reset foreground object variables
    app.object = cell(4, 100); %cell array to save objects with maximum size of 100. 1->wall, 2->number
    app.object_position = cell(4, 100); %cell array to save object positions with maximum size of 100. 1->wall, 2->number
    app.object_counter = 0;

    [name, path] = uigetfile({'*.png';'*.jpg'}, 'Select a file','C:\Documents\');
    folder = erase(path, 'name');
    app.image = imread(fullfile(folder, name));
    

    axes(app.axes)
    rotate3d off;
    imshow(app.image);
    
    % inner
    app.inner.ul = images.roi.Point(gca,'Position',[200 200],'tag','ul');
    app.inner.ur = images.roi.Point(gca,'Position',[400 200],'tag','ur');
    app.inner.lr = images.roi.Point(gca,'Position',[400 400],'tag','lr');
    app.inner.ll = images.roi.Point(gca,'Position',[200 400],'tag','ll');
    app.vp = images.roi.Point(gca,'Position',[300 300],'tag','vp');

    % outer
    app.outer.ul = images.roi.Point(gca,'Position',[0 0],'tag','outer_ul', 'visible','off');
    app.outer.ur = images.roi.Point(gca,'Position',[0 0],'tag','outer_ul', 'visible','off');
    app.outer.ll = images.roi.Point(gca,'Position',[0 0],'tag','outer_ul', 'visible','off');
    app.outer.lr = images.roi.Point(gca,'Position',[0 0],'tag','outer_ul', 'visible','off');

    plotLines(app.image, app.inner, app.outer, app.vp)
    bringToFront(app.inner.ul);
    bringToFront(app.inner.ur);
    bringToFront(app.inner.lr);
    bringToFront(app.inner.ll);
    bringToFront(app.vp);

    addlistener(app.inner.ul,'MovingROI',@(src,evt)allevents(app,src,evt));
    addlistener(app.inner.ur,'MovingROI',@(src,evt)allevents(app,src,evt));
    addlistener(app.inner.lr,'MovingROI',@(src,evt)allevents(app,src,evt));
    addlistener(app.inner.ll,'MovingROI',@(src,evt)allevents(app,src,evt));
    addlistener(app.vp,'MovingROI',@(src,evt)allevents(app,src,evt));
    
    app.info.String = 'You have successfuly imported an image! Now, drag and drop the corner points of the blue rectangle to frame the back wall and position the vanishing point!';

end

function chooseWall(varargin)
    global app
    %set wall variable
    app.wall = app.chooseWall.Value;
end

function chooseForegroundObject(varargin)
    global app
    %message box 
    mBox = msgbox("Choose the foreground object by drawing a rectangle around the object");
    set(mBox, 'position', [550 500 300 50]);
    waitfor(mBox);
    %choose object
    [mask, object] = multipleMasksRect(app.image);

    %start loading waitbar
    wBar = waitbar(0,'Please wait...');

    % fill the background
    app.image = inpaintExemplar(app.image, mask, 'FillOrder','tensor');
    waitbar(20/100);

    %create Box to specify position of foreground object
    d = fix(2 * length(app.image));
    app.image_padded = padarray(app.image,[d d],0);
    xul = [app.inner.ll.Position(1) app.outer.ll.Position(1)] + d;
    yul = [app.inner.ll.Position(2) app.outer.ll.Position(2)] + d;
    xol = [app.inner.ul.Position(1) app.outer.ul.Position(1)] + d;
    yol = [app.inner.ul.Position(2) app.outer.ul.Position(2)] + d;
    xor = [app.inner.ur.Position(1) app.outer.ur.Position(1)] + d;
    yor = [app.inner.ur.Position(2) app.outer.ur.Position(2)] + d;
    xur = [app.inner.lr.Position(1) app.outer.lr.Position(1)] + d;
    yur = [app.inner.lr.Position(2) app.outer.lr.Position(2)] + d;
    waitbar(50/100);
    [app.box.back, app.box.left, app.box.right, app.box.roof, app.box.floor] = boxify(app.image, app.image_padded, d, xul, yul, xol, yol, xor, yor, xur, yur);
    app.boxDone = true;


    %close waitbar
    waitbar(100/100);
    close(wBar);

    %choose position of foreground object
    [object_pos_temp, object_resized_temp] = getObjectPosition(app.box.back, app.box.left, app.box.right, app.box.roof, app.box.floor, app.wall, object, app.image);
    
    %count object
    app.object_counter = app.object_counter+1;

    %save all foreground objects inside a cell
    app.object{app.wall, app.object_counter} = object_resized_temp;
    %save position inside a cell
    app.object_position{app.wall, app.object_counter} = object_pos_temp;
end

function show3Dimage(varargin)
    global app
    %start loading waitbar
    wBar = waitbar(0,'Please wait...');
    
    d = fix(2 * length(app.image));
    app.image_padded = padarray(app.image,[d d],0);
    waitbar(20/100);

  
    xul = [app.inner.ll.Position(1) app.outer.ll.Position(1)] + d;
    yul = [app.inner.ll.Position(2) app.outer.ll.Position(2)] + d;
    xol = [app.inner.ul.Position(1) app.outer.ul.Position(1)] + d;
    yol = [app.inner.ul.Position(2) app.outer.ul.Position(2)] + d;
    xor = [app.inner.ur.Position(1) app.outer.ur.Position(1)] + d;
    yor = [app.inner.ur.Position(2) app.outer.ur.Position(2)] + d;
    xur = [app.inner.lr.Position(1) app.outer.lr.Position(1)] + d;
    yur = [app.inner.lr.Position(2) app.outer.lr.Position(2)] + d;
    waitbar(50/100);
    [app.box.back, app.box.left, app.box.right, app.box.roof, app.box.floor] = boxify(app.image, app.image_padded, d, xul, yul, xol, yol, xor, yor, xur, yur);
    app.boxDone = true;
    
    %close waitbar
    waitbar(100/100);
    close(wBar);
    
    app.info.String = 'Enjoy your tour into the picture!';

    axes(app.axes)
    cla(app.axes,'reset');
    adaptivebox2(app.axes, app.box.floor,app.box.roof,app.box.back,app.box.left,app.box.right, app.object, app.object_position, app.object_counter);
    
    app.info.String = 'You can now import a new image and start over again!';

end

function rotateOn(varargin)
    global  app
    axes(app.axes)
    rotate3d on;
    app.rotateButton.ForegroundColor = [0 0 0];
    app.zoomButton.ForegroundColor = [0.5 0.5 0.5];
end

function zoomOn(varargin)
    global app
    axes(app.axes)
    cameratoolbar(gcf,'SetMode','zoom')
    app.zoomButton.ForegroundColor = [0 0 0];
    app.rotateButton.ForegroundColor = [0.5 0.5 0.5];
end


% event listener for moving roi objects
function allevents(app, src, evt)
    evname = evt.EventName;
    switch(evname)
        case{'MovingROI'}
            dragPointLogic(src.Tag, app.inner, app.vp)
            hold on; imshow(app.image);
            plotLines(app.image, app.inner, app.outer, app.vp)
            bringToFront(app.inner.ul);
            bringToFront(app.inner.ur);
            bringToFront(app.inner.lr);
            bringToFront(app.inner.ll);
            bringToFront(app.vp);
            
            app.chooseForegroundObject.Enable = 'on';
            app.info.String = 'After selecting the back wall and vanishing point, either start choosing foreground objects or press ''Show 3D image''. ';


    end
end