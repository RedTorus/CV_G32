function [back, left, right, roof, floor] = boxify(I, II, d, xul, yul, xol, yol, xor, yor, xur, yur)
%BOXIFY  extract 5 walls from given Image
%Parameters: I original color image
%II original image with black padding around it
%d Thickness of black padding in II
%xul, yul,xol,yol,xor,yor,xur,yur = x and y coordinates of points on vanishing lines extracted from GUI
%ol= ,,oben links''   or= ,,oben rechts''
%ul = ,,unten Links'' ur=,,unten Rechts''
% following coordinate system is used:          0------->x
%                                               |
 %                                              |   Image
  %                                             v
  %                                             y
[r,c,~]=size(I);
[rows,col,~]=size(II);
imshow(II);
boxx=[];
boxy=[];
hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[xul,yul]=ginput(2);  %xu=bottom left, xu(1),y(u) koordinate for box's lower left corner
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Extract the coordinates of 2 points from bottom left vanishing lines
%Determine Endpoints of vanishing line by determining intersection point
%between vanishing line's linear function f(x) and corresponding x or y line:
%leftwall needs intersection with min x value x=d
%floor needs intersection with max y value y=r+d
%Lines are extended in such way that no information is lost when extracting
%and warping wall
boxx=[boxx,xul(1)]; %stores x values of the back wall's corners
boxy=[boxy,yul(1)]; %stores y values of the back wall's corners
coefficients = polyfit([xul(1), xul(2)], [yul(1), yul(2)], 1); %extract linear fcn parameters
a = coefficients (1);
b = coefficients (2);
x3=d;
y3=a*x3+b;
yf=r+d;
xf=(yf-b)/a;
xw=x3;yw=y3;

%ul = ,,unten links"
yyleft=[yul(1) yw];  %yyleft stores all y cordinates of the left wall's corner points needed to extract left wall
xxleft=[xul(1) xw];  %xxleft stores all x cordinates of  left wall's corner points
xxflor=[xul(1) xf];  %xxflor stores all x cordinates of the floor's corner points needed to extract floor
yyflor=[yul(1) yf];  %yyflor stores all y coordinates of floor's corner points

%Depiction of vanishing lines
plot([xul(1),xw],[yul(1),yw],'LineWidth',2,'Color','red');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[xol,yol]=ginput(2); %coordinates for upper left corner of box and end point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Extract the coordinates of 2 points from upper left vanishing lines
%Determine Endpoints of vanishing line by determining intersection point
%between vanishing line's linear function f(x) and corresponding x or y
%line
%roof needs intersection with minimum y value y=d
%leftwall needs intersection with min x value x=d
%Lines are extended in such way that no information is lost when extracting
%and warping wall
boxx=[xol(1),boxx]; %add backwall coordinates into arrays boxx, boxy
boxy=[yol(1),boxy];
coefficients = polyfit([xol(1), xol(2)], [yol(1), yol(2)], 1); %determining parameters of linear function
a = coefficients (1);
b = coefficients (2);
x3=d;
y3=a*x3+b;
yf=d;
xf=(yf-b)/a;
xw=x3;yw=y3;
yyleft=[yyleft,yw,yol(1)];
xxleft=[xxleft,xw,xol(1)];
xxrof=[xol(1),xf];  %xxrof stores all x cordinates of the roof's corner points needed to extract roof
yyrof=[yol(1),yf];  %yyrof stores all y coordinates of roof's corner points

mask = poly2mask(xxleft, yyleft, rows, col); %Generates mask for Image I
% Erase outside mask by setting to zero
ch1=II(:,:,1);ch2=II(:,:,2);ch3=II(:,:,3); %Extract every color channel
%II2(~mask) = 0;
ch1(~mask)=0;ch2(~mask)=0;ch3(~mask)=0; %Mask every color channel
II2=cat(3,ch1,ch2,ch3); %Fuse all color channels back togethers and store in II2
leftside=II2(round(min(yyleft)):round(max(yyleft)),round(min(xxleft)):round(max(xxleft)),:); %Extract leftside
yleftside=yyleft-min(yyleft);  %get corner coorinates of leftside wall
xleftside=xxleft-min(xxleft); 
plot([xol(1),xw],[yol(1),yw],'LineWidth',2,'Color','red');  %draw vanishing lines
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[xor,yor]=ginput(2);    %Coordinates for upper fight box and its end point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Extract the coordinates of 2 points from upper right vanishing lines
%Determine Endpoints of vanishing line by determining intersection point
%between vanishing line's linear function f(x) and corresponding x and y
%lines
%roof needs intersection with minimum y value y=d
%rightwall needs intersection with max x value x=c+d

%Lines are extended in such way that no information is lost when extracting
%and warping wall
boxx=[boxx,xor(1)];
boxy=[boxy,yor(1)];
coefficients = polyfit([xor(1), xor(2)], [yor(1), yor(2)], 1);
a = coefficients (1);
b = coefficients (2);
x3=c+d;
y3=a*x3+b;
yf=d;
xf=(yf-b)/a;
xw=x3;yw=y3;
%add calculated points into corner point arrays
yyrof=[yyrof,yf,yor(1)];  
xxrof=[xxrof,xf,xor(1)];
yyright=[yor(1),yw];
xxright=[xor(1),xw];
mask = poly2mask(xxrof, yyrof, rows, col); %generate roof mask
% Erase outside mask by setting to zero
ch1=II(:,:,1);ch2=II(:,:,2);ch3=II(:,:,3); %extract color channel
%II2(~mask) = 0;
ch1(~mask)=0;ch2(~mask)=0;ch3(~mask)=0; %mask color channel
II2=cat(3,ch1,ch2,ch3); 
roof=II2(round(min(yyrof)):round(max(yyrof)),round(min(xxrof)):round(max(xxrof)),:); %extract roof
xroof=xxrof-min(xxrof); %get corner coordinates in extracted roof image coordinate system
yroof=yyrof-min(yyrof);
plot([xor(1),xw],[yor(1),yw],'LineWidth',2,'Color','red'); %plot vanishing line

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[xur,yur]=ginput(2);           %coordinates for lower right corner of box + its end point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Extract the coordinates of 2 points from lower right vanishing lines
%Determine Endpoints of vanishing line by determining intersection point
%between vanishing line's linear function f(x) and corresponding x or y
%line. Floor needs intersection point with minimum y value
%rightwall needs intersection with max xvalue
boxx=[boxx,xur(1)];
boxy=[boxy,yur(1)];
a1=boxx(3);boxx(3)=boxx(4);boxx(4)=a1; %swap 3rd and 4th element of arrays boxx and boxy
a2=boxy(3);boxy(3)=boxy(4);boxy(4)=a2;  %=swapping ur and or for back wall mask
coefficients = polyfit([xur(1), xur(2)], [yur(1), yur(2)], 1);
a = coefficients (1);
b = coefficients (2);
x3=c+d;
y3=a*x3+b;
yf=r+d;
xf=(yf-b)/a;
yw=y3;
xw=x3;
plot([xur(1),xw],[yur(1),yw],'LineWidth',2,'Color','red'); %plot vanishing line
%add calculated coordinates to corner point array
yyflor=[yyflor,yf,yur(1)];
xxflor=[xxflor,xf,xur(1)];
yyright=[yyright,yw,yur(1)];
xxright=[xxright,xw,xur(1)];
mask = poly2mask(xxflor, yyflor, rows, col); %Generate mask for floor
% Erase outside mask by setting to zero
ch1=II(:,:,1);ch2=II(:,:,2);ch3=II(:,:,3); %Extract color channels
%II2(~mask) = 0;
ch1(~mask)=0;ch2(~mask)=0;ch3(~mask)=0;
II2=cat(3,ch1,ch2,ch3);
floor=II2(round(min(yyflor)):round(max(yyflor)),round(min(xxflor)):round(max(xxflor)),:); %extract floor image
xfloor=xxflor-min(xxflor); %calculate floor's corner points in new coordinate system
yfloor=yyflor-min(yyflor);
%}
mask = poly2mask(xxright, yyright, rows, col); %mask for right side
% Erase outside mask by setting to zero
ch1=II(:,:,1);ch2=II(:,:,2);ch3=II(:,:,3);%extract color channels
%II2(~mask) = 0;

ch1(~mask)=0;ch2(~mask)=0;ch3(~mask)=0; %mask color channel
II2=cat(3,ch1,ch2,ch3); %combine masked color channels
%extract image of right side from image
rightside=II2(round(min(yyright)):round(max(yyright)),round(min(xxright)):round(max(xxright)),:); 
xright=xxright-min(xxright); %calculate rightside wall's cornerpoints in new coordinate system of right side image
yright=yyright-min(yyright);
%
mask = poly2mask(boxx, boxy, rows, col);  %mask for back wall
ch1=II(:,:,1);ch2=II(:,:,2);ch3=II(:,:,3); %extract color channels
%II2(~mask) = 0;
ch1(~mask)=0;ch2(~mask)=0;ch3(~mask)=0; %mask color channels
II2=cat(3,ch1,ch2,ch3); %recombine color channels
back=II2(round(min(boxy)):round(max(boxy)),round(min(boxx)):round(max(boxx)),:); %extract back wall image

%
[rleft,cleft,~]=size(leftside);
%fixed point of unwarped leftside image are corners of leftside
fixleftside=[rleft,cleft;0,cleft;0,0;rleft,0]; 
%movedpoints= cornerpoints of left wall after warping = cornerpoints in new coordinate system
movleftside=[xleftside',yleftside'];
tform=fitgeotrans(movleftside,fixleftside,'projective');
%Determine geometric transformation from moved to fixed points

leftside2=imwarp(leftside,tform); %unwarp left wall by using imwarp (uses homograpy matrix)
leftside2=removeblackB(leftside2); %removes black area around image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[rroof,croof,~]=size(roof);
%Same unwarping procedure as with left wall: determining fixed and moved
%points of roof
%calculating geometric transformation and applying it with imwarp 
%removing black box

fixroof=[rroof,croof;0,croof;0,0;rroof,0];
movroof=[xroof',yroof'];
tform=fitgeotrans(movroof,fixroof,'projective');
roof2=imwarp(roof,tform);
roof2=imrotate(roof2,90);
roof2=removeblackB(roof2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%same unwarping procedure this time for floor
[rfloor,cfloor,~]=size(floor);
fixfloor=[rfloor,cfloor;0,cfloor;0,0;rfloor,0];
movfloor=[xfloor',yfloor'];
tform=fitgeotrans(movfloor,fixfloor,'projective');
floor2=imwarp(floor,tform);
floor2=imrotate(floor2,90);
floor2=removeblackB(floor2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[rright,cright,~]=size(rightside);
%same unwarping procedure, this time with right wall
fixrightside=[rright,cright;0,cright;0,0;rright,0];
movrightside=[xright',yright'];

tform=fitgeotrans(movrightside,fixrightside,'projective');
rightside2=imwarp(rightside,tform);
rightside2=imrotate(rightside2,180);
rightside2=removeblackB(rightside2);

%%%%%%%%%%
%%Walls are resized in such way that warped side Walls have same height as back
%%wall, without losing their width to height ratio
%floor and roof are resized in a way to have same width as backwall
%Since keeping the width to height ratio would result in very short roof and floor in the 3d box we decided that 
%the length bzw. height of floor/roof is set to the minimum width of the
%side walls
[rf,cf,~]=size(back);
[rowleft,colleft,~]=size(leftside2);
ratio=colleft/rowleft;
newcolleft=rf*ratio;

[rowright,colright,~]=size(rightside2);
ratio=colright/rowright;
newcolright=rf*ratio;

newcol=min(newcolleft,newcolright);

leftside3=imresize(leftside2,[rf,newcolleft]);
rightside3=imresize(rightside2,[rf,newcolright]);
floor3=imresize(floor2,[newcol,cf]);
roof3=imresize(roof2,[newcol,cf]);

%{
figure(50)
imshow(leftside);
axis on;
hold on;
plot(xleftside,yleftside, 'r+', 'MarkerSize', 15, 'LineWidth', 2);
figure(51)
imshow(floor3);
figure(52)
imshow(roof3);
figure(53)
imshow(rightside3);
figure(55)
imshow(leftside3);
figure(54)
imshow(front);
%}

left = leftside3;
right = rightside3;
roof = roof3;
floor = floor3;

end