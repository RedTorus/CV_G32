function [] = dispboxrect(ax, g,fl,h,rf,j,bck,k,lft,l,rgt,aa,c, object, object_position, object_counter)
%Plots 3D Box with sidewalls
%Parameters: Sidewalls and corresponding boolean variable (decides wether box should
%be displayed or not), axis and opbject parameters
%clf;
cla(ax,'reset');
%basis floor at -1 in z, left back corner always at -1,1,-1

%Stores sizes of each wall
%Most Walls already have some same side lenghts, because they were
%extracted with boxify
[rowback,colback,~]=size(flipud(imrotate(bck,0)));
[rowfl,colfl,~]=size(flipud(imrotate(fl,0)));
[rowtop,coltop,~]=size(flipud(imrotate(rf,0)));
[rowlft,collft,~]=size(flipud(imrotate(lft,0)));
[rowrgt,colrgt,~]=size(imrotate(rgt,180));

%Checks wether the corresponding boolean variables j,g,h,k and l to the
%walls back,floor,top,left and right are 1. If that's the case display the
%wall in the 3d box

% back
if j==1
     surface([-1 colback; -1 colback], [1 1; 1 1], [-1 -1; rowback rowback], ...
    'FaceColor', 'texturemap','EdgeColor', 'none', 'CData', flipud(imrotate(bck,0))); 
end
%floor
if g==1
     surface([-1 colfl; -1 colfl], [-rowfl -rowfl; 1 1], [-1 -1; -1 -1], ...
    'FaceColor', 'texturemap','EdgeColor', 'none','CData', fliplr(flipud(imrotate(fl,0))) );
     %place the foreground objects
     placeForegroundObject(object, object_position, object_counter, 1); 
end
% top
if h==1
    %coltop=1;rowtop=1;
surface([-1 coltop; -1 coltop], [-rowtop -rowtop; 1 1], [rowback rowback; rowback rowback], ...
    'FaceColor', 'texturemap','EdgeColor', 'none', 'CData', flipud((imrotate(rf,0)) ));
     %place the foreground objects
     placeForegroundObject(object, object_position, object_counter, 2);
end

% left
if k==1
 surface([-1 -1; -1 -1], [-collft 1; -collft  1], [-1 -1; rowlft rowlft], ...
    'FaceColor', 'texturemap','EdgeColor', 'none', 'CData', flipud(imrotate(lft,0)));
 %place the foreground objects
 placeForegroundObject(object, object_position, object_counter, 3);
end
% right
if l==1

surface([colback colback; colback colback], [-colrgt 1; -colrgt 1], [-1 -1; rowrgt rowrgt], ...
    'FaceColor', 'texturemap','EdgeColor', 'none', 'CData', imrotate(rgt,180));
 %place the foreground objects
 placeForegroundObject(object, object_position, object_counter, 4);
end
%axis off


%view(3)
if c==1
rotate3d on;
else
end
campos(aa);

%Set Limits for the axis such that coordinate system not made larger than
%it needs to be
xlim([-1 colback])
    zlim([-1 rowback])
    ylim([-max(colrgt,collft)-10, 2])
    xlabel('x')
    ylabel('y')
    zlabel('z')
axis off
end